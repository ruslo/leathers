// Copyright (c) 2014, Ruslan Baratov
// All rights reserved.

int main() {
#include <leathers/push>
#include <leathers/constant-conditional>
  if (true) {
    return 1;
  }
#include <leathers/pop>

#include <leathers/push>
#if !defined(SHOW_WARNINGS)
# include <leathers/unreachable-code>
#endif
  return 2;
#include <leathers/pop>
}
