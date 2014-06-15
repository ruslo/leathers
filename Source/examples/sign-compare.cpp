// Copyright (c) 2014, Ruslan Baratov
// All rights reserved.

int main() {
  int a(0);
  unsigned b(0);
#include <leathers/push>
#if !defined(SHOW_WARNINGS)
# include <leathers/sign-compare>
#endif
  if (a == b) {
  }
#include <leathers/pop>
}
