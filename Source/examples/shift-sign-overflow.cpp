// Copyright (c) 2014, Ruslan Baratov
// All rights reserved.

int main() {
#include <leathers/push>
#if !defined(SHOW_WARNINGS)
# include <leathers/shift-sign-overflow>
#endif
  (void)~(static_cast<long>(1) << (8*sizeof(long) - 1));
#include <leathers/pop>
}
