// Copyright (c) 2014, Ruslan Baratov
// All rights reserved.

struct Foo {
  char x;
#include <leathers/push>
#if !defined(SHOW_WARNINGS)
# include <leathers/padded>
#endif
  long y;
#include <leathers/pop>
};

int main() {
  // struct Foo must be used, otherwise there will be no warning (clang)
  return static_cast<int>(Foo().y);
}
