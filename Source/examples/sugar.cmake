# This file generated automatically by:
#   generate_sugar_files.py
# see wiki for more info:
#   https://github.com/ruslo/sugar/wiki/Collecting-sources

if(DEFINED LEATHERS_SOURCE_EXAMPLES_SUGAR_CMAKE_)
  return()
else()
  set(LEATHERS_SOURCE_EXAMPLES_SUGAR_CMAKE_ 1)
endif()

include(sugar_files)

sugar_files(
    LEATHERS_EXAMPLES_SOURCES
    # compatibility-c++98 (see one more below)
    c++98-compat-pedantic.cpp

    # special-members
    assign-base-inaccessible.cpp
    assign-could-not-be-generated.cpp
    copy-ctor-could-not-be-generated.cpp
    dflt-ctor-could-not-be-generated.cpp
    user-ctor-required.cpp

    # inline
    automatic-inline.cpp
    force-not-inlined.cpp
    not-inlined.cpp
    unreferenced-inline.cpp

    #
    cast-aligned.cpp
    catch-semantic-changed.cpp
    conditional-uninitialized.cpp
    constant-conditional.cpp
    conversion-loss.cpp
    conversion-sign-extended.cpp
    conversion.cpp
    covered-switch-default.cpp
    deprecated-declarations.cpp
    deprecated-register.cpp
    deprecated.cpp
    documentation-unknown-command.cpp
    documentation.cpp
    extra-semi.cpp
    global-constructors.cpp
    ill-formed-comma-expr.cpp
    inherits-via-dominance.cpp
    is-defined-to-be.cpp
    layout-changed.cpp
    missing-noreturn.cpp
    name-length-exceeded.cpp
    no-such-warning.cpp
    non-virtual-dtor.cpp
    object-layout-change.cpp
    old-style-cast.cpp
    padded.cpp
    reserved-user-defined-literal.cpp
    shift-sign-overflow.cpp
    sign-compare.cpp
    sign-conversion.cpp
    signed-unsigned-compare.cpp
    static-ctor-not-thread-safe.cpp
    switch-enum.cpp
    switch.cpp
    this-used-in-init.cpp
    undef.cpp
    unreachable-code.cpp
    unsafe-conversion.cpp
    unused-parameter.cpp
    unused-value.cpp
    used-but-marked-unused.cpp
    weak-vtables.cpp
)

if(NOT MSVC)
  sugar_files(
    LEATHERS_EXAMPLES_SOURCES
    c++98-compat.cpp # inline namespaces is not supported
  )
endif()

if(MSVC)
  sugar_files(
    LEATHERS_EXAMPLES_SOURCES
    behavior-change.cpp
    dflt-ctor-base-inaccessible.cpp # clang error
    digraphs-not-supported.cpp # clang error
  )
endif()
