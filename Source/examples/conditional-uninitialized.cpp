// Copyright (c) 2014, Ruslan Baratov
// All rights reserved.

struct Foo;

template <class X> bool boo(int&) { return false; }

inline int foo(int arg) {
  int result;
  bool y = arg && boo<Foo>(result);
  if(!y) throw 1;
#include <leathers/push>
#if !defined(SHOW_WARNINGS)
# include <leathers/conditional-uninitialized>
#endif
  return result;
#include <leathers/pop>
}

int main() {
}
