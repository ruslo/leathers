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
    c++98-compat-pedantic.cpp
    c++98-compat.cpp
    cast-aligned.cpp
    conditional-uninitialized.cpp
    conversion.cpp
    covered-switch-default
    deprecated-declarations.cpp
    deprecated-register.cpp
    deprecated.cpp
    documentation-unknown-command.cpp
    documentation.cpp
    extra-semi.cpp
    global-constructors.cpp
    missing-noreturn.cpp
    non-virtual-dtor.cpp
    old-style-cast.cpp
    padded.cpp
    shift-sign-overflow.cpp
    sign-compare.cpp
    switch-enum.cpp
    switch.cpp
    undef.cpp
    unreachable-code.cpp
    unused-parameter.cpp
    used-but-marked-unused.cpp
    weak-vtables.cpp
)
