// Copyright (c) 2014, Ruslan Baratov
// All rights reserved.

class Boo;

class Foo {
 public:
  Foo(Boo&) {
  }
};

class Boo {
 public:
#include <leathers/push>
#if !defined(SHOW_WARNINGS)
# include <leathers/this-used-in-init>
#endif
  Boo(): foo_(*this) {
  }
#include <leathers/pop>

 private:
  Foo foo_;
};

int main() {
}
