// Copyright (c) 2014, Ruslan Baratov
// All rights reserved.

#include <leathers/push>
#include <leathers/user-ctor-required>
#if !defined(SHOW_WARNINGS)
# include <leathers/dflt-ctor-could-not-be-generated>
#endif
class Boo {
 public:
  int& a_;

  Boo& operator=(const Boo&);
};
#include <leathers/pop>

int main() {
}
