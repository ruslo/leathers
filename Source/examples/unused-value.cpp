// Copyright (c) 2014, Ruslan Baratov
// All rights reserved.

int main() {
  int x(0);
#include <leathers/push>
#if !defined(SHOW_WARNINGS)
# include <leathers/unused-value>
#endif
  x;
#include <leathers/pop>
}
