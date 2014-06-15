// Copyright (c) 2014, Ruslan Baratov
// All rights reserved.

#include <leathers/push>
#if !defined(SHOW_WARNINGS)
# include <leathers/non-virtual-dtor>
#endif
struct Foo {
  virtual void foo() = 0;
};
#include <leathers/pop>

int main() {
}
