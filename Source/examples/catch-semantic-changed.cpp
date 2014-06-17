// Copyright (c) 2014, Ruslan Baratov
// All rights reserved.

// MSVC flags: EHs

int main() {
#include <leathers/push>
#if !defined(SHOW_WARNINGS)
# include <leathers/catch-semantic-changed>
#endif
  try {
  }
  catch (...) {
  }
#include <leathers/pop>
}
