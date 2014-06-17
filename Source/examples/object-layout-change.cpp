// Copyright (c) 2014, Ruslan Baratov
// All rights reserved.

class A {
 public:
  virtual ~A() {}
};

#include <leathers/push>
#if !defined(SHOW_WARNINGS)
# include <leathers/object-layout-change>
#endif
class B: public virtual A {
};
#include <leathers/pop>

int main() {
}
