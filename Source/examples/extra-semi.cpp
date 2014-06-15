// Copyright (c) 2014, Ruslan Baratov
// All rights reserved.

struct Foo {
#include <leathers/push>
#if !defined(SHOW_WARNINGS)
# include <leathers/extra-semi>
#endif
  void foo() {
  };
#include <leathers/pop>
};

int main() {
}
