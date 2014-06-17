// Copyright (c) 2014, Ruslan Baratov
// All rights reserved.

class A {
};

class B {
 public:
  B(B&) {
  }

  B(A) {
  }

  operator A() {
    return A();
  }
};

inline B source() {
  return A();
}

int main() {
#include <leathers/push>
#if !defined(SHOW_WARNINGS)
# include <leathers/behavior-change>
#endif
  B ap(source());
#include <leathers/pop>
}
