// Copyright (c) 2014, Ruslan Baratov
// All rights reserved.

#include <leathers/push>
#if !defined(SHOW_WARNINGS)
# include <leathers/weak-vtables>
#endif
class Foo {
 public:
  virtual void foo() {
  }

  virtual ~Foo() {
  }
};
#include <leathers/pop>

int main() {
  Foo foo;
}
