// Copyright (c) 2014, Ruslan Baratov
// All rights reserved.

class Foo {
 public:
  Foo(int);
};

#include <leathers/push>
#include <leathers/dflt-ctor-could-not-be-generated>
#if !defined(SHOW_WARNINGS)
# include <leathers/user-ctor-required>
#endif
class Boo {
 public:
  int& a_;

  Boo& operator=(const Boo&);
};
#include <leathers/pop>

int main() {
}
