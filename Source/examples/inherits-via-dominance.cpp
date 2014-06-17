// Copyright (c) 2014, Ruslan Baratov
// All rights reserved.

class Foo {
 public:
  virtual void foo() {
  }
};

#include <leathers/push>
#include <leathers/object-layout-change>
class Boo : virtual public Foo {
 public:
  virtual void foo() override {
  }
};
#include <leathers/pop>

#include <leathers/push>
#include <leathers/object-layout-change>
#if !defined(SHOW_WARNINGS)
# include <leathers/inherits-via-dominance>
#endif
class Baz : public Boo, virtual public Foo {
};
#include <leathers/pop>

int main() {
}