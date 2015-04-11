# Copyright (c) 2014, Ruslan Baratov
# All rights reserved.

cmake_minimum_required(VERSION 3.0)

### Hunter snapshot that will be used ###
include("cmake/HunterGate.cmake")
HunterGate(
    URL "https://github.com/ruslo/hunter/archive/v0.8.0.tar.gz"
    SHA1 "2436e92eb9ef39e9ccd31dc1351648cff2c10b3d"
)

project(Leathers)

### Build Options ###
option(LEATHERS_BUILD_EXAMPLES "Build examples" OFF)
option(
    LEATHERS_EXAMPLES_SHOW_WARNINGS
    "Disable warning suppression in examples"
    OFF
)

### Download dependencies ###
hunter_add_package(Boost)
hunter_add_package(Sugar)

### Find dependencies ###
find_package(Boost REQUIRED)

### - ###
include("${SUGAR_ROOT}/cmake/Sugar")
include(sugar_generate_warning_flags)
include(sugar_groups_generate)
include(sugar_include)

### Target sources. Init variables: ###
#    LEATHERS_SOURCES
#    LEATHERS_EXAMPLES_SOURCES
sugar_include("./Source")

### Targets ###
add_library(leathers INTERFACE)

set(INCL_DEST "include")

target_include_directories(
    leathers
    INTERFACE
    "$<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}/Source>"
    "$<INSTALL_INTERFACE:${INCL_DEST}>"
)

target_include_directories(leathers SYSTEM INTERFACE "${Boost_INCLUDE_DIR}")

if(LEATHERS_EXAMPLES_SHOW_WARNINGS)
  set(treat_as_error "")
else()
  set(treat_as_error ALL)
endif()

sugar_generate_warning_flags(
    target_compile_options
    target_properties
    DISABLE
    unreferenced-inline # https://github.com/ruslo/leathers/issues/1
    name-length-exceeded # https://github.com/ruslo/leathers/issues/2
    not-inlined # https://github.com/ruslo/leathers/issues/3
    force-not-inlined # https://github.com/ruslo/leathers/issues/4
    ENABLE ALL
    TREAT_AS_ERROR ${treat_as_error}
    CLEAR_GLOBAL
)

if(LEATHERS_BUILD_EXAMPLES)
  foreach(src ${LEATHERS_EXAMPLES_SOURCES})
    get_filename_component(test_name "${src}" NAME_WE)
    set(sources ${src} ${LEATHERS_SOURCES} ${SUGAR_SOURCES})
    add_executable(example_${test_name} ${sources})
    if(LEATHERS_EXAMPLES_SHOW_WARNINGS)
      target_compile_definitions(example_${test_name} PUBLIC SHOW_WARNINGS)
    endif()
    set_target_properties(
        example_${test_name}
        PROPERTIES
        ${target_properties}
        COMPILE_OPTIONS
        "${target_compile_options}"
    )
    target_link_libraries(example_${test_name} leathers)
  endforeach()
endif()

sugar_groups_generate(
    ${LEATHERS_EXAMPLES_SOURCES} ${LEATHERS_SOURCES} ${SUGAR_SOURCES}
)

### Install ###
set(CONF_DEST "lib/cmake/Leathers")

include(CMakePackageConfigHelpers)

set(leathers_config "${CMAKE_CURRENT_BINARY_DIR}/LeathersConfig.cmake")

configure_package_config_file(
    "./Source/LeathersConfig.cmake.in"
    "${leathers_config}"
    INSTALL_DESTINATION ${CONF_DEST}
    PATH_VARS CONF_DEST
)

# Install targets and configs
install(FILES "${leathers_config}" DESTINATION ${CONF_DEST})
install(TARGETS leathers EXPORT LeathersTargets)
install(FILES ${LEATHERS_SOURCES} DESTINATION ${INCL_DEST}/leathers)
install(EXPORT LeathersTargets DESTINATION ${CONF_DEST})
