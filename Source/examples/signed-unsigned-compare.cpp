// Copyright (c) 2014, Ruslan Baratov
// All rights reserved.

int main() {
#include <leathers/push>
#include <leathers/c++98-compat-pedantic>
  int x(1);
  unsigned long long y(2);
#include <leathers/pop>

#include <leathers/push>
#if !defined(SHOW_WARNINGS)
# include <leathers/signed-unsigned-compare>
#endif
  if (x == y) {
  }
#include <leathers/pop>
}
