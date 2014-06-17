// Copyright (c) 2014, Ruslan Baratov
// All rights reserved.

#include <leathers/push>
#if !defined(SHOW_WARNINGS)
# include <leathers/layout-changed>
#endif

class Foo;

struct Boo {
  void (Foo::*mem)();
  void* ptr;
};

#include <leathers/pop>

int main() {
}
