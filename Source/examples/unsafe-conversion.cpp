// Copyright (c) 2014, Ruslan Baratov
// All rights reserved.

void boo(int) {
}

int main() {
  typedef void (*func)();

#include <leathers/push>
#if !defined(SHOW_WARNINGS)
# include <leathers/unsafe-conversion>
#endif
  func x = (func)boo;
#include <leathers/pop>

  (void)x;
}
