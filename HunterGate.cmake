# Copyright (c) 2013-2014, Ruslan Baratov
# All rights reserved.

# This is a gate file to Hunter package manager.
# Usage: include this file using `include` command and add package you need:
#
#     include("HunterGate.cmake")
#     hunter_add_package(Foo)
#     hunter_add_package(Boo COMPONENTS Bar Baz)
#
# Projects:
#     * https://github.com/hunter-packages/gate/
#     * https://github.com/ruslo/hunter

cmake_minimum_required(VERSION 2.8.10)

set(HUNTER_MINIMUM_VERSION "0.2.9")
set(HUNTER_MINIMUM_VERSION_HASH a47509e078a71ab7abbc66fc20faf37b439c2440)

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

# Download project to HUNTER_ROOT
function(hunter_gate_do_download)
  message(
      STATUS
      "[hunter] Hunter not found, start download to '${HUNTER_ROOT}' ..."
  )

  if(NOT PROJECT_BINARY_DIR)
    message(
        FATAL_ERROR
        "PROJECT_BINARY_DIR is empty. "
        "Move HunterGate file **after** first project command"
    )
  endif()

  set(TEMP_DIR "${PROJECT_BINARY_DIR}/Hunter-activity/gate")
  set(TEMP_BUILD "${TEMP_DIR}/_builds")

  set(URL_BASE "https://github.com/ruslo/hunter/archive")
  file(
      WRITE
      "${TEMP_DIR}/CMakeLists.txt"
      "cmake_minimum_required(VERSION 2.8.10)\n"
      "include(ExternalProject)\n"
      "ExternalProject_Add(\n"
      "    Hunter\n"
      "    URL\n"
      "    \"${URL_BASE}/v${HUNTER_MINIMUM_VERSION}.tar.gz\"\n"
      "    URL_HASH\n"
      "    SHA1=${HUNTER_MINIMUM_VERSION_HASH}\n"
      "    DOWNLOAD_DIR\n"
      "    \"${HUNTER_ROOT}/Download\"\n"
      "    SOURCE_DIR\n"
      "    \"${HUNTER_ROOT}/Source\"\n"
      "    CONFIGURE_COMMAND\n"
      "    \"\"\n"
      "    BUILD_COMMAND\n"
      "    \"\"\n"
      "    INSTALL_COMMAND\n"
      "    \"\"\n"
      ")\n"
  )

  execute_process(
      COMMAND
      "${CMAKE_COMMAND}" "-H${TEMP_DIR}" "-B${TEMP_BUILD}"
      WORKING_DIRECTORY
      "${TEMP_DIR}"
      RESULT_VARIABLE
      HUNTER_DOWNLOAD_RESULT
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

  execute_process(
      COMMAND
      "${CMAKE_COMMAND}"
      -E
      touch
      "${HUNTER_ROOT}/installed.by.gate"
  )

  message(STATUS "[hunter] downloaded to '${HUNTER_ROOT}'")
endfunction()

hunter_gate_detect_root() # set HUNTER_ROOT and HUNTER_ROOT_INFO

if(NOT HUNTER_ROOT)
  message(
      FATAL_ERROR
      "Internal error in 'hunter_gate_detect_root': HUNTER_ROOT is not setted"
  )
endif()

# Beautify path, fix probable problems with windows path slashes
get_filename_component(HUNTER_ROOT "${HUNTER_ROOT}" ABSOLUTE)

if(NOT EXISTS "${HUNTER_ROOT}")
  hunter_gate_do_download()
  if(NOT EXISTS "${HUNTER_ROOT}")
    message(
        FATAL_ERROR
        "Internal error in 'hunter_gate_do_download': "
        "directory HUNTER_ROOT not found"
    )
  endif()
endif()

# at this point: HUNTER_ROOT exists and is file or directory
if(NOT IS_DIRECTORY "${HUNTER_ROOT}")
  message(
      FATAL_ERROR
      "HUNTER_ROOT is not directory (${HUNTER_ROOT})"
      "(${HUNTER_ROOT_INFO})"
  )
endif()

# at this point: HUNTER_ROOT exists and is directory
file(GLOB _hunter_result "${HUNTER_ROOT}/*")
list(LENGTH _hunter_result _hunter_result_len)
if(_hunter_result_len EQUAL 0)
  # HUNTER_ROOT directory is empty, let's download it
  hunter_gate_do_download()
endif()

unset(_hunter_result)
unset(_hunter_result_len)

# at this point: HUNTER_ROOT exists and is not empty directory
if(NOT EXISTS "${HUNTER_ROOT}/Source/cmake/Hunter")
  message(
      FATAL_ERROR
      "HUNTER_ROOT directory exists (${HUNTER_ROOT})"
      "but '${HUNTER_ROOT}/Source/cmake/Hunter' file not found"
      "(${HUNTER_ROOT_INFO})"
  )
endif()

# check version
if(NOT EXISTS "${HUNTER_ROOT}/Source/cmake/version.cmake")
  message(
      FATAL_ERROR
      "HUNTER_ROOT directory exists (${HUNTER_ROOT})"
      "but '${HUNTER_ROOT}/Source/cmake/version.cmake' file not found"
      "(${HUNTER_ROOT_INFO})"
  )
endif()

unset(HUNTER_VERSION)
include("${HUNTER_ROOT}/Source/cmake/version.cmake")
if(NOT HUNTER_VERSION)
  message(
      FATAL_ERROR
      "Internal error: HUNTER_VERSION is not set in `version.cmake`"
  )
endif()

if(HUNTER_VERSION VERSION_LESS HUNTER_MINIMUM_VERSION)
  message(
      "Current version is ${HUNTER_VERSION}. "
      "Minimum version is ${HUNTER_MINIMUM_VERSION}. "
      "Try autoupdate..."
  )

  if(NOT EXISTS "${HUNTER_ROOT}/installed.by.gate")
    message(
        FATAL_ERROR
        "Please update version manually or remove directory `${HUNTER_ROOT}`."
    )
  endif()

  if(EXISTS "${HUNTER_ROOT}/Source/.git")
    message(
        FATAL_ERROR
        "Internal error: `installed.by.gate` and `.git`"
    )
  endif()
  # File `${HUNTER_ROOT}/installed.by.gate` exists, hence current version
  # installed by older gate file and can be auto-updated by current gate
  if(NOT EXISTS "${HUNTER_ROOT}/Source/scripts/sleep.cmake")
    message(FATAL_ERROR "Internal error: sleep.cmake not found")
  endif()

  set(_hunter_timeout 10)
  message("")
  message("***** AUTO UPDATE *****")
  message("")
  message("Directories:")
  message("    * `${HUNTER_ROOT}/Base`")
  message("    * `${HUNTER_ROOT}/Source`")
  message("will be REMOVED")
  message("")

  foreach(x RANGE ${_hunter_timeout})
    math(EXPR _hunter_output "(${_hunter_timeout}) - (${x})")
    execute_process(
        COMMAND
        "${CMAKE_COMMAND}"
        -E
        echo_append
        "${_hunter_output} "
    )
    if(NOT _hunter_output EQUAL 0)
      execute_process(
          COMMAND
          "${CMAKE_CTEST_COMMAND}"
          -S
          "${HUNTER_ROOT}/Source/scripts/sleep.cmake"
      )
    endif()
  endforeach()

  # One more sanity check...
  string(COMPARE EQUAL "${HUNTER_ROOT}" "" _hunter_root_is_empty)
  if(_hunter_root_is_empty)
    message(FATAL_ERROR "Internal error: HUNTER_ROOT is empty")
  endif()

  # Remove old version
  if(EXISTS "${HUNTER_ROOT}/Base")
    execute_process(
        COMMAND
        "${CMAKE_COMMAND}"
        -E
        remove_directory
        "${HUNTER_ROOT}/Base"
    )
  endif()
  if(EXISTS "${HUNTER_ROOT}/Source")
    execute_process(
        COMMAND
        "${CMAKE_COMMAND}"
        -E
        remove_directory
        "${HUNTER_ROOT}/Source"
    )
  endif()

  # Download new version
  hunter_gate_do_download()

  # Sanity check: master file exists
  if(NOT EXISTS "${HUNTER_ROOT}/Source/cmake/Hunter")
    message(FATAL_ERROR "Broken download: master file not found")
  endif()

  # Sanity check: version is not less than minimum
  if(NOT EXISTS "${HUNTER_ROOT}/Source/cmake/version.cmake")
    message(FATAL_ERROR "Broken download: version.cmake not found")
  endif()

  unset(HUNTER_VERSION)
  include("${HUNTER_ROOT}/Source/cmake/version.cmake")
  if(NOT HUNTER_VERSION)
    message(
        FATAL_ERROR
        "Internal error: HUNTER_VERSION is not set in `version.cmake`"
    )
  endif()

  if(HUNTER_VERSION VERSION_LESS HUNTER_MINIMUM_VERSION)
    message(FATAL_ERROR "Broken download: version is less than minimum")
  endif()
endif()

# HUNTER_ROOT found or downloaded if not exists, i.e. can be used now
include("${HUNTER_ROOT}/Source/cmake/Hunter")

include(hunter_status_debug)
hunter_status_debug("${HUNTER_ROOT_INFO}")

include(hunter_add_package)
