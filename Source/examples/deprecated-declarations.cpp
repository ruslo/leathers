// Copyright (c) 2014, Ruslan Baratov
// All rights reserved.

__attribute__((deprecated("boo"))) void foo();

void foo() {
}

int main() {
#include <leathers/push>
#if !defined(SHOW_WARNINGS)
# include <leathers/deprecated-declarations>
#endif
  foo();
# include <leathers/pop>
}
