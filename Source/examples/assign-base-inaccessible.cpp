// Copyright (c) 2014, Ruslan Baratov
// All rights reserved.

class Foo {
 public:
  Foo& operator=(const Foo&) = delete;
};

#include <leathers/push>
#if !defined(SHOW_WARNINGS)
# include <leathers/assign-base-inaccessible>
#endif
class Boo: public Foo {
};
#include <leathers/pop>

int main() {
}
