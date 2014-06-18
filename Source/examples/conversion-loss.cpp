// Copyright (c) 2014, Ruslan Baratov
// All rights reserved.

inline int foo() {
  return 0;
}

int main() {
  char y;

#include <leathers/push>
#if (BOOST_COMP_MSVC)
# include <leathers/conversion>
#endif
#if !defined(SHOW_WARNINGS)
# include <leathers/conversion-loss>
#endif
  y = foo();
#include <leathers/pop>
}
