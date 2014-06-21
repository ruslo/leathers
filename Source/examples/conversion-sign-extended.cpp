// Copyright (c) 2014, Ruslan Baratov
// All rights reserved.

#include <cstdint> // uint64_t

uint64_t f(void*);

#include <leathers/push>
#if !defined(SHOW_WARNINGS)
# include <leathers/conversion-sign-extended>
#endif
uint64_t f(void* ptr) {
  return reinterpret_cast<uint64_t>(ptr);
}
#include <leathers/pop>

int main() {
}
