// Copyright (c) 2014, Ruslan Baratov
// All rights reserved.

int main() {
#include <leathers/push>
#if !defined(SHOW_WARNINGS)
# include <leathers/deprecated-register>
#endif
  register int x = 0;
#include <leathers/pop>
  return x;
}
