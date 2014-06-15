// Copyright (c) 2014, Ruslan Baratov
// All rights reserved.

struct Foo {
  Foo() {
  }
};

extern Foo foo;

#include <leathers/push>
#if !defined(SHOW_WARNINGS)
# include <leathers/global-constructors>
#endif
Foo foo;
#include <leathers/pop>

int main() {
}
