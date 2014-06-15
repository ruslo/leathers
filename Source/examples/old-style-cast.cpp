// Copyright (c) 2014, Ruslan Baratov
// All rights reserved.

int main() {
  char* a = 0;

#include <leathers/push>
#if !defined(SHOW_WARNINGS)
# include <leathers/old-style-cast>
#endif
  char* b = (char*)a;
#include <leathers/pop>

  (void)b;
}
