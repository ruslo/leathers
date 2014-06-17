// Copyright (c) 2014, Ruslan Baratov
// All rights reserved.

int main() {
  long x(0);
  short y(0);

#include <leathers/push>
#if !defined(SHOW_WARNINGS)
# include <leathers/conversion-loss>
#endif
  y = x;
#include <leathers/pop>
}
