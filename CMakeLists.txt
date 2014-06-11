# Copyright (c) 2014, Ruslan Baratov
# All rights reserved.

cmake_minimum_required(VERSION 3.0)
project(Leathers)

### Build Options ###
option(LEATHERS_BUILD_EXAMPLES "Build examples" OFF)

### Download dependencies ###
include(HunterGate.cmake)
hunter_add_package(Boost)

include("./sugar/cmake/Sugar") # TODO temporary

### Find dependencies ###
find_package(Boost REQUIRED)

### - ###
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

sugar_generate_warning_flags(flags ENABLE ALL CLEAR_GLOBAL)

if(LEATHERS_BUILD_EXAMPLES)
  foreach(src ${LEATHERS_EXAMPLES_SOURCES})
    get_filename_component(test_name "${src}" NAME_WE)
    set(sources ${src} ${LEATHERS_SOURCES} ${SUGAR_SOURCES})
    add_executable(example_${test_name} ${sources})
    sugar_groups_generate(${sources})
    target_compile_options(example_${test_name} PUBLIC ${flags})
    target_link_libraries(example_${test_name} leathers)
  endforeach()
endif()

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
