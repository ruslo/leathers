# Copyright (c) 2014-2015, Ruslan Baratov
# All rights reserved.

cmake_minimum_required(VERSION 3.0)

### Hunter snapshot that will be used ###
include("cmake/HunterGate.cmake")
HunterGate(
    URL "https://github.com/ruslo/hunter/archive/v0.8.1.tar.gz"
    SHA1 "a9bd96ab113f3af870b13cd05cf4e75b8848cf4a"
)

project(Leathers VERSION 0.2.0)

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

### Global include
include_directories("Source")

### Targets ###
add_library(leathers INTERFACE)

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
set(generated_dir "${CMAKE_CURRENT_BINARY_DIR}/generated")

set(config_install_dir "lib/cmake/${PROJECT_NAME}")
set(include_install_dir "include")

set(version_config "${generated_dir}/${PROJECT_NAME}ConfigVersion.cmake")
set(project_config "${generated_dir}/${PROJECT_NAME}Config.cmake")
set(targets_export_name "${PROJECT_NAME}Targets")
set(namespace "${PROJECT_NAME}::")

include(CMakePackageConfigHelpers)
write_basic_package_version_file(
    "${version_config}" COMPATIBILITY SameMajorVersion
)

# Note: use 'targets_export_name'
configure_file("cmake/Config.cmake.in" "${project_config}" @ONLY)

install(
    TARGETS leathers
    EXPORT "${targets_export_name}"
    INCLUDES DESTINATION "${include_install_dir}"
)

install(
    DIRECTORY "Source/leathers"
    DESTINATION "${include_install_dir}"
)

install(
    FILES "${project_config}" "${version_config}"
    DESTINATION "${config_install_dir}"
)

install(
    EXPORT "${targets_export_name}"
    NAMESPACE "${namespace}"
    DESTINATION "${config_install_dir}"
)
