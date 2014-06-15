// Copyright (c) 2014, Ruslan Baratov
// All rights reserved.

void f(int);

void f(int) {
}

int main() {
  double x = 1.5;
#include <leathers/push>
#if !defined(SHOW_WARNINGS)
# include <leathers/conversion>
#endif
  f(x);
#include <leathers/pop>
}
