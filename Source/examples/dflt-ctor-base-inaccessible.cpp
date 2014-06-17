// Copyright (c) 2014, Ruslan Baratov
// All rights reserved.

class Foo {
 public:
#include <leathers/push>
#include <leathers/c++98-compat>
  Foo() = delete;
#include <leathers/pop>
};

#include <leathers/push>
#if !defined(SHOW_WARNINGS)
# include <leathers/dflt-ctor-base-inaccessible>
#endif
class Boo: public Foo {
 public:
  int& a_;

  Boo& operator=(const Boo&);
};
#include <leathers/pop>

int main() {
}
