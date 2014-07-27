# Copyright (c) 2013-2014, Ruslan Baratov
# All rights reserved.

# This is a gate file to Hunter package manager.
# Usage: include this file using `include` command and add package you need:
#
#     include("cmake/HunterGate.cmake")
#     HunterGate(
#         URL "https://github.com/path/to/hunter/archive.tar.gz"
#         SHA1 "798501e983f14b28b10cda16afa4de69eee1da1d"
#     )
#     hunter_add_package(Foo)
#     hunter_add_package(Boo COMPONENTS Bar Baz)
#
# Projects:
#     * https://github.com/hunter-packages/gate/
#     * https://github.com/ruslo/hunter

cmake_minimum_required(VERSION 3.0)
include(CMakeParseArguments)

# Set HUNTER_ROOT cmake variable to suitable value.
# Info about variable can be found in HUNTER_ROOT_INFO.
function(hunter_gate_detect_root)
  # Check CMake variable
  if(HUNTER_ROOT)
    set(HUNTER_ROOT_INFO "HUNTER_ROOT detected by cmake variable" PARENT_SCOPE)
    return()
  endif()

  # Check environment variable
  string(COMPARE NOTEQUAL "$ENV{HUNTER_ROOT}" "" not_empty)
  if(not_empty)
    set(HUNTER_ROOT "$ENV{HUNTER_ROOT}" PARENT_SCOPE)
    set(
        HUNTER_ROOT_INFO
        "HUNTER_ROOT detected by environment variable"
        PARENT_SCOPE
    )
    return()
  endif()

  # Check HOME environment variable
  string(COMPARE NOTEQUAL "$ENV{HOME}" "" result)
  if(result)
    set(HUNTER_ROOT "$ENV{HOME}/HunterPackages" PARENT_SCOPE)
    set(
        HUNTER_ROOT_INFO
        "HUNTER_ROOT set using HOME environment variable"
        PARENT_SCOPE
    )
    return()
  endif()

  # Check PROGRAMFILES environment variable (windows only)
  if(WIN32)
    string(COMPARE NOTEQUAL "$ENV{PROGRAMFILES}" "" result)
    if(result)
      set(HUNTER_ROOT "$ENV{PROGRAMFILES}/HunterPackages" PARENT_SCOPE)
      set(
          HUNTER_ROOT_INFO
          "HUNTER_ROOT set using PROGRAMFILES environment variable"
          PARENT_SCOPE
      )
      return()
    endif()
  endif()

  # Create in project
  if(NOT PROJECT_SOURCE_DIR)
     message(FATAL_ERROR "PROJECT_SOURCE_DIR is empty")
  endif()

  set(HUNTER_ROOT "${PROJECT_SOURCE_DIR}/HunterPackages" PARENT_SCOPE)
  set(
      HUNTER_ROOT_INFO
      "HUNTER_ROOT set by project sources directory"
      PARENT_SCOPE
  )
endfunction()

# If several processes simultaneously try to init base hunter directory
# this synchronisation helps to do it correctly
function(hunter_gate_try_lock result)
  if(NOT HUNTER_LOCK_PATH)
    message(FATAL_ERROR "Internal error (HUNTER_LOCK_PATH is empty)")
  endif()

  if(NOT HUNTER_LOCK_INFO)
    message(FATAL_ERROR "Internal error (HUNTER_LOCK_INFO is empty)")
  endif()

  if(NOT HUNTER_LOCK_FULL_INFO)
    message(FATAL_ERROR "Internal error (HUNTER_LOCK_FULL_INFO is empty)")
  endif()

  if(NOT PROJECT_BINARY_DIR)
    message(FATAL_ERROR "Internal error (PROJECT_BINARY_DIR is empty)")
  endif()

  file(TO_NATIVE_PATH "${HUNTER_LOCK_PATH}" lock_path)

  # `cmake -E make_directory` is not fit here because this command succeed
  # even if directory already exists
  if(WIN32)
    if(MINGW)
      # He-he :)
      string(REPLACE "/" "\\" lock_path "${lock_path}")
    endif()
    execute_process(
        COMMAND cmd /C mkdir "${lock_path}"
        RESULT_VARIABLE lock_result
        OUTPUT_VARIABLE lock_result_info
        ERROR_VARIABLE lock_result_info
    )
  else()
    execute_process(
        COMMAND mkdir "${lock_path}"
        RESULT_VARIABLE lock_result
        OUTPUT_VARIABLE lock_result_info
        ERROR_VARIABLE lock_result_info
    )
  endif()

  if(NOT lock_result EQUAL 0)
    message("Lock failed with result: ${lock_result}")
    message("Reason:  ${lock_result_info}")
    set(${result} FALSE PARENT_SCOPE)
    return()
  endif()

  file(WRITE "${HUNTER_LOCK_INFO}" "${PROJECT_BINARY_DIR}")

  string(TIMESTAMP time_now)
  file(
      WRITE
      "${HUNTER_LOCK_FULL_INFO}"
      "    Project binary directory: ${PROJECT_BINARY_DIR}\n"
      "    Build start at: ${time_now}"
  )

  set(${result} TRUE PARENT_SCOPE)
endfunction()

# Download project to HUNTER_BASE
function(hunter_gate_do_download)
  if(NOT HUNTER_BASE)
    message(FATAL_ERROR "Internal error (HUNTER_BASE is empty)")
  endif()

  if(NOT HUNTER_GATE_INSTALL_DONE)
    message(FATAL_ERROR "Internal error (HUNTER_GATE_INSTALL_DONE is empty)")
  endif()

  if(NOT HUNTER_LOCK_PATH)
    message(FATAL_ERROR "Internal error (HUNTER_LOCK_PATH is empty)")
  endif()

  if(NOT PROJECT_BINARY_DIR)
    message(
        FATAL_ERROR
        "PROJECT_BINARY_DIR is empty. "
        "Move HunterGate file **after** first project command"
    )
  endif()

  hunter_gate_try_lock(lock_successful)
  if(NOT lock_successful)
    # Return and wait until HUNTER_GATE_INSTALL_DONE created
    return()
  endif()

  set(TEMP_DIR "${PROJECT_BINARY_DIR}/_3rdParty/gate")
  set(TEMP_BUILD "${TEMP_DIR}/_builds")

  message(
      STATUS
      "[hunter] Hunter not found, start download to '${HUNTER_BASE}' ..."
      "(${TEMP_BUILD})"
  )

  file(
      WRITE
      "${TEMP_DIR}/CMakeLists.txt"
      "cmake_minimum_required(VERSION 2.8.10)\n"
      "include(ExternalProject)\n"
      "ExternalProject_Add(\n"
      "    Hunter\n"
      "    URL\n"
      "    \"${HUNTER_URL}\"\n"
      "    URL_HASH\n"
      "    SHA1=${HUNTER_SHA1}\n"
      "    DOWNLOAD_DIR\n"
      "    \"${HUNTER_BASE}/Download\"\n"
      "    SOURCE_DIR\n"
      "    \"${HUNTER_BASE}/Self\"\n"
      "    CONFIGURE_COMMAND\n"
      "    \"\"\n"
      "    BUILD_COMMAND\n"
      "    \"\"\n"
      "    INSTALL_COMMAND\n"
      "    \"\"\n"
      ")\n"
  )

  # CMAKE_*_COMPILER_WORKS speed up a little bit
  # and avoid path too long windows error
  execute_process(
      COMMAND
          "${CMAKE_COMMAND}"
          "-H${TEMP_DIR}"
          "-B${TEMP_BUILD}"
          -DCMAKE_CXX_COMPILER_WORKS=ON
          -DCMAKE_C_COMPILER_WORKS=ON
      WORKING_DIRECTORY "${TEMP_DIR}"
      RESULT_VARIABLE HUNTER_DOWNLOAD_RESULT
  )

  if(NOT HUNTER_DOWNLOAD_RESULT EQUAL 0)
    message(FATAL_ERROR "Configure download project failed")
  endif()

  execute_process(
      COMMAND
      "${CMAKE_COMMAND}" --build "${TEMP_BUILD}"
      WORKING_DIRECTORY
      "${TEMP_DIR}"
      RESULT_VARIABLE
      HUNTER_DOWNLOAD_RESULT
  )

  if(NOT HUNTER_DOWNLOAD_RESULT EQUAL 0)
    message(FATAL_ERROR "Build download project failed")
  endif()

  file(REMOVE_RECURSE "${HUNTER_LOCK_PATH}")
  file(WRITE "${HUNTER_GATE_INSTALL_DONE}" "done")

  message(STATUS "[hunter] downloaded to '${HUNTER_BASE}'")
endfunction()

macro(HunterGate)
  # HUNTER_SHA1 may already be defined by other project
  if(NOT HUNTER_SHA1)
    cmake_parse_arguments(HUNTER "" "URL;SHA1" "" ${ARGV})
    if(HUNTER_UNPARSED_ARGUMENTS)
      message(FATAL_ERROR "HunterGate unparsed arguments")
    endif()
  endif()

  hunter_gate_detect_root() # set HUNTER_ROOT and HUNTER_ROOT_INFO

  if(NOT HUNTER_ROOT)
    message(FATAL_ERROR "Internal error: HUNTER_ROOT is not set")
  endif()

  # Beautify path, fix probable problems with windows path slashes
  get_filename_component(HUNTER_ROOT "${HUNTER_ROOT}" ABSOLUTE)

  if(EXISTS "${HUNTER_ROOT}/cmake/Hunter")
    # hunter installed manually
    set(HUNTER_SHA1 "")
    set(HUNTER_URL "")
    set(HUNTER_BASE "${HUNTER_ROOT}")
    set(HUNTER_SELF "${HUNTER_ROOT}")
    set(HUNTER_GATE_INSTALL_DONE "${HUNTER_BASE}")
  else()
    set(HUNTER_BASE "${HUNTER_ROOT}/_Base/${HUNTER_SHA1}")
    set(HUNTER_SELF "${HUNTER_BASE}/Self")
    set(HUNTER_GATE_INSTALL_DONE "${HUNTER_BASE}/install-gate-done")
  endif()

  set(HUNTER_URL "${HUNTER_URL}" CACHE STRING "Hunter archive URL")
  set(HUNTER_SHA1 "${HUNTER_SHA1}" CACHE STRING "Hunter archive SHA1 hash")

  # Beautify path, fix probable problems with windows path slashes
  get_filename_component(HUNTER_BASE "${HUNTER_BASE}" ABSOLUTE)
  get_filename_component(HUNTER_SELF "${HUNTER_SELF}" ABSOLUTE)

  set(HUNTER_ROOT "${HUNTER_ROOT}" CACHE PATH "Hunter root directory")
  set(HUNTER_BASE "${HUNTER_BASE}" CACHE PATH "Hunter base directory")
  set(HUNTER_SELF "${HUNTER_SELF}" CACHE PATH "Hunter self directory")

  set(HUNTER_LOCK_PATH "${HUNTER_BASE}/directory-lock")
  set(HUNTER_LOCK_INFO "${HUNTER_LOCK_PATH}/info")
  set(HUNTER_LOCK_FULL_INFO "${HUNTER_LOCK_PATH}/fullinfo")

  if(NOT EXISTS "${HUNTER_BASE}")
    file(MAKE_DIRECTORY "${HUNTER_BASE}")
    if(NOT EXISTS "${HUNTER_BASE}")
      message(
          FATAL_ERROR
          "Can't create directory `${HUNTER_BASE}`"
          "(probably no permissions)"
      )
    endif()
    hunter_gate_do_download()
  endif()

  while(NOT EXISTS "${HUNTER_GATE_INSTALL_DONE}")
    # Directory already created, but installation is not finished yet
    if(EXISTS "${HUNTER_LOCK_FULL_INFO}")
      file(READ "${HUNTER_LOCK_FULL_INFO}" _fullinfo)
    else()
      set(_fullinfo "????")
    endif()
    string(TIMESTAMP _time_now)
    message(
        "[${_time_now}] Install already triggered, waiting for:\n${_fullinfo}\n"
        "If that build cancelled (interrupted by user or some other reason), "
        "please remove this directory manually:\n\n"
        "    ${HUNTER_LOCK_PATH}\n\n"
        "then run CMake again."
    )
    # Some sanity checks
    if(EXISTS "${HUNTER_LOCK_INFO}")
      file(READ "${HUNTER_LOCK_INFO}" _info)
      string(COMPARE EQUAL "${_info}" "${PROJECT_BINARY_DIR}" incorrect)
      if(incorrect)
        message(FATAL_ERROR "Waiting for self")
      endif()
      if(NOT EXISTS "${_info}")
        # Do not crash here, this may happens (checking/reading is not atomic)
        message("Waiting for deleted directory!")
      endif()
    endif()
    execute_process(COMMAND "${CMAKE_COMMAND}" -E sleep 1)
  endwhile()

  if(NOT EXISTS "${HUNTER_SELF}/cmake/Hunter")
    message(
        FATAL_ERROR
        "Internal error can't find master file in directory `${HUNTER_BASE}`"
    )
  endif()

  # HUNTER_BASE found or downloaded if not exists, i.e. can be used now
  include("${HUNTER_SELF}/cmake/Hunter")

  include(hunter_status_debug)
  hunter_status_debug("${HUNTER_ROOT_INFO}")

  include(hunter_add_package)
endmacro()
