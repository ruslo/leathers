// Copyright (c) 2014, Ruslan Baratov
// All rights reserved.

#include <leathers/push>
#include <leathers/object-layout-change>
#include <leathers/c++98-compat>
#include <leathers/weak-vtables>
#include <leathers/padded>
class Foo {
 public:
  virtual void foo() {
  }

  virtual ~Foo() {
  }
};

class Boo : virtual public Foo {
 public:
  virtual void foo() override {
  }

  virtual ~Boo() override {
  }
};
#include <leathers/pop>

#include <leathers/push>
#include <leathers/object-layout-change>
#include <leathers/padded>
#include <leathers/c++98-compat>
#if !defined(SHOW_WARNINGS)
# include <leathers/inherits-via-dominance>
#endif
class Baz : public Boo, virtual public Foo {
  virtual ~Baz() override {
  }
};
#include <leathers/pop>

int main() {
}
