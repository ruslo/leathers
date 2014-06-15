// Copyright (c) 2014, Ruslan Baratov
// All rights reserved.

enum Foo {
  A,
  B,
  C
};

void foo(Foo a);

void foo(Foo a) {
  switch(a) {
    case A:
      break;
    case B:
      break;
    case C:
      break;
#include <leathers/push>
#if !defined(SHOW_WARNINGS)
# include <leathers/covered-switch-default>
# include <leathers/unreachable-code>
#endif
    default:
      break;
#include <leathers/pop>
  }
}

int main() {
}
