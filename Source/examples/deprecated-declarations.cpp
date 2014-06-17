// Copyright (c) 2014, Ruslan Baratov
// All rights reserved.

#include <boost/predef/compiler.h> // BOOST_COMP_CLANG

#if (BOOST_COMP_CLANG) || (BOOST_COMP_GNUC)
# define DEPRECATED __attribute__((deprecated("boo")))
#elif (BOOST_COMP_MSVC)
# define DEPRECATED __declspec(deprecated)
#else
# define DEPRECATED
#endif

DEPRECATED void foo();

#include <leathers/push>
#include <leathers/automatic-inline>
void foo() {
}
#include <leathers/pop>

int main() {
#include <leathers/push>
#if !defined(SHOW_WARNINGS)
# include <leathers/deprecated-declarations>
#endif
  foo();
# include <leathers/pop>
}
