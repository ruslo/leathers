// Copyright (c) 2014, Ruslan Baratov
// All rights reserved.

enum Foo {
  A,
  B
};

void boo(Foo foo);

void boo(Foo foo) {
#include <leathers/push>
#if !defined(SHOW_WARNINGS)
# include <leathers/switch-enum>
#endif
  switch (foo) {
    case A:
      break;
    default:
      break;
  }
#include <leathers/pop>
}

int main() {
}
