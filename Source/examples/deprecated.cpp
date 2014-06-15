// Copyright (c) 2014, Ruslan Baratov
// All rights reserved.

struct Foo {
#include <leathers/push>
#if !defined(SHOW_WARNINGS)
# include <leathers/deprecated>
#endif
  void boo() throw() {
  }
#include <leathers/pop>
};

int main() {
}
