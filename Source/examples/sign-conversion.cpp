// Copyright (c) 2014, Ruslan Baratov
// All rights reserved.

int foo();

#include <leathers/push>
#if !defined(SHOW_WARNINGS)
# include <leathers/sign-conversion>
#endif
int foo() {
  unsigned x(3);
  return x;
}
#include <leathers/pop>

int main() {
}
