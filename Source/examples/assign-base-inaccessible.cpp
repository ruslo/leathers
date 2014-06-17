// Copyright (c) 2014, Ruslan Baratov
// All rights reserved.

class Foo {
 public:
#include <leathers/push>
#include <leathers/c++98-compat>
  Foo& operator=(const Foo&) = delete;
#include <leathers/pop>
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
