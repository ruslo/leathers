// Copyright (c) 2014, Ruslan Baratov
// All rights reserved.

int main() {
  bool x(false), y(true);

#include <leathers/push>
#if !defined(SHOW_WARNINGS)
# include <leathers/ill-formed-comma-expr>
#endif
  if (x, y) {
  }
#include <leathers/pop>
}

