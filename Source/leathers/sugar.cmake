# This file generated automatically by:
#   generate_sugar_files.py
# see wiki for more info:
#   https://github.com/ruslo/sugar/wiki/Collecting-sources

if(DEFINED LEATHERS_SOURCE_LEATHERS_SUGAR_CMAKE_)
  return()
else()
  set(LEATHERS_SOURCE_LEATHERS_SUGAR_CMAKE_ 1)
endif()

include(sugar_files)

sugar_files(
    LEATHERS_SOURCES
    ###
    push
    pop
    ###
    cast_align
    conversion
    deprecated
    direct_ivar_access
    disabled_macro_expansion
    enum_not_handled_in_switch
    exit_time_destructors
    explicit_ownership_type
    extended_offsetof
    format_nonliteral
    global_constructors
    gnu
    implicit_fallthrough
    missing_prototypes
    missing_variable_declarations
    over_aligned
    pedantic
    selector
    sign_conversion
    unreachable_code
    unused_function
    unused_macros
    unused_parameter
    unused_variable
    used_but_marked_unused
    weak_template_vtables
    weak_vtables
)
