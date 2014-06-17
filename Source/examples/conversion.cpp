// Copyright (c) 2014, Ruslan Baratov
// All rights reserved.

void f(int);

#include <leathers/push>
#include <leathers/automatic-inline>
void f(int) {
}
#include <leathers/pop>

int main() {
  double x = 1.5;
#include <leathers/push>
#if !defined(SHOW_WARNINGS)
# include <leathers/conversion>
#endif
  f(x);
#include <leathers/pop>
}
