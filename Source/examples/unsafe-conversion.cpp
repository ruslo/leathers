// Copyright (c) 2014, Ruslan Baratov
// All rights reserved.

void boo(int);

void boo(int) {
}

int main() {
  typedef void (*func)();

#include <leathers/push>
#include <leathers/old-style-cast>
#if !defined(SHOW_WARNINGS)
# include <leathers/unsafe-conversion>
#endif
  func x = (func)boo;
#include <leathers/pop>

  (void)x;
}
