// Copyright (c) 2014, Ruslan Baratov
// All rights reserved.

// Visual Studio release build

void foo();

#include <leathers/push>
#if !defined(SHOW_WARNINGS)
# include <leathers/automatic-inline>
#endif
void foo() {
}
#include <leathers/pop>

int main() {
  foo();
}
