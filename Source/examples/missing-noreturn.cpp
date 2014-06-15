// Copyright (c) 2014, Ruslan Baratov
// All rights reserved.

void foo();

#include <leathers/push>
#if !defined(SHOW_WARNINGS)
# include <leathers/missing-noreturn>
#endif
void foo() {
  throw -1;
}
#include <leathers/pop>

int main() {
}
