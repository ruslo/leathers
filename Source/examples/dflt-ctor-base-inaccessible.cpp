// Copyright (c) 2014, Ruslan Baratov
// All rights reserved.

class Foo {
 public:
  Foo() = delete;
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
