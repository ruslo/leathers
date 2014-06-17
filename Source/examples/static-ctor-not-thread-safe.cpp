// Copyright (c) 2014, Ruslan Baratov
// All rights reserved.

class Foo {
 public:
  Foo() {
  }
};

int main() {
#include <leathers/push>
#if !defined(SHOW_WARNINGS)
# include <leathers/static-ctor-not-thread-safe>
#endif
  static Foo foo;
#include <leathers/pop>
}
