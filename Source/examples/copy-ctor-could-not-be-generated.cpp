// Copyright (c) 2014, Ruslan Baratov
// All rights reserved.

class Foo {
 public:
#include <leathers/push>
#include <leathers/c++98-compat>
  Foo() = default;
  Foo(const Foo&) = delete;
#include <leathers/pop>
};

#include <leathers/push>
#if !defined(SHOW_WARNINGS)
# include <leathers/copy-ctor-could-not-be-generated>
#endif
class Boo: public Foo {
};
#include <leathers/pop>

int main() {
}
