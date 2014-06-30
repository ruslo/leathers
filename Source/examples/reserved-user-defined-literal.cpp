// Copyright (c) 2014, Ruslan Baratov
// All rights reserved.

#include <leathers/push>
#if !defined(SHOW_WARNINGS)
# include <leathers/reserved-user-defined-literal>
#endif

#define N
const char* x = "abc"N;

#include <leathers/pop>

int main() {
}
