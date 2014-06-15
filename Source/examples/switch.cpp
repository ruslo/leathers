// Copyright (c) 2014, Ruslan Baratov
// All rights reserved.

enum X {
  A,
  B
};

void foo(X x);

void foo(X x) {
#include <leathers/push>
#if !defined(SHOW_WARNINGS)
# include <leathers/switch>
#endif
  switch (x) {
  case A:
    break;
  }
# include <leathers/pop>
}

int main() {
}
