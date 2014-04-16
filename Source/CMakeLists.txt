# Copyright (c) 2014, Ruslan Baratov
# All rights reserved.

add_library(leathers INTERFACE)

set(
    LEATHERS_SOURCES
    ###
    leathers/push
    leathers/pop
    ###
    leathers/cast_align
    leathers/conversion
    leathers/deprecated
    leathers/direct_ivar_access
    leathers/disabled_macro_expansion
    leathers/enum_not_handled_in_switch
    leathers/exit_time_destructors
    leathers/explicit_ownership_type
    leathers/extended_offsetof
    leathers/format_nonliteral
    leathers/global_constructors
    leathers/gnu
    leathers/implicit_fallthrough
    leathers/missing_prototypes
    leathers/missing_variable_declarations
    leathers/over_aligned
    leathers/pedantic
    leathers/selector
    leathers/sign_conversion
    leathers/unreachable_code
    leathers/unused_function
    leathers/unused_macros
    leathers/unused_parameter
    leathers/unused_variable
    leathers/used_but_marked_unused
    leathers/weak_template_vtables
    leathers/weak_vtables
)

set(INCL_DEST include)
set(CONF_DEST lib/cmake/Leathers)

target_include_directories(
    leathers INTERFACE "$<INSTALL_INTERFACE:${INCL_DEST}>"
)
target_include_directories(leathers SYSTEM INTERFACE "${Boost_INCLUDE_DIR}")

include(CMakePackageConfigHelpers)

set(leathers_config "${CMAKE_CURRENT_BINARY_DIR}/LeathersConfig.cmake")

configure_package_config_file(
    "./LeathersConfig.cmake.in"
    "${leathers_config}"
    INSTALL_DESTINATION ${CONF_DEST}
    PATH_VARS CONF_DEST
)

# Install targets and configs
install(FILES "${leathers_config}" DESTINATION ${CONF_DEST})
install(TARGETS leathers EXPORT LeathersTargets)
install(FILES ${LEATHERS_SOURCES} DESTINATION ${INCL_DEST}/leathers)
install(EXPORT LeathersTargets DESTINATION ${CONF_DEST})
