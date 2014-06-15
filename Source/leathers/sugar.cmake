# This file generated automatically:
# https://github.com/ruslo/sugar/wiki/Cross-platform-warning-suppression

# Copyright (c) 2014, Ruslan Baratov
# All rights reserved.

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
    all
    ###
    c++98-compat
    c++98-compat-pedantic
    cast-align
    conditional-uninitialized
    conversion
    covered-switch-default
    deprecated
    deprecated-declarations
    deprecated-objc-isa-usage
    deprecated-register
    disabled-macro-expansion
    documentation
    documentation-unknown-command
    empty-body
    extra-semi
    global-constructors
    implicit-fallthrough
    four-char-constants
    missing-noreturn
    non-virtual-dtor
    old-style-cast
    padded
    shift-sign-overflow
    sign-compare
    switch
    switch-enum
    undef
    unreachable-code
    unused-parameter
    used-but-marked-unused
    weak-vtables
    shadow
    bool-conversion
    constant-conversion
    shorten-64-to-32
    enum-conversion
    int-conversion
    sign-conversion
    missing-braces
    return-type
    parentheses
    missing-field-initializers
    missing-prototypes
    newline-eof
    pointer-sign
    format
    uninitialized
    unknown-pragmas
    unused-function
    unused-label
    unused-value
    unused-variable
    exit-time-destructors
    overloaded-virtual
    invalid-offsetof
    c++11-extensions
    duplicate-method-match
    implicit-atomic-properties
    objc-missing-property-synthesis
    protocol
    selector
    deprecated-implementations
    strict-selector-match
    undeclared-selector
    objc-root-class
    explicit-ownership-type
    implicit-retain-self
    arc-repeated-use-of-weak
    receiver-is-weak
    arc-bridge-casts-disallowed-in-nonarc
)
