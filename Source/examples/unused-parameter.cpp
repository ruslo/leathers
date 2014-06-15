// Copyright (c) 2014, Ruslan Baratov
// All rights reserved.

void foo(int);

#include <leathers/push>
#if !defined(SHOW_WARNINGS)
# include <leathers/unused-parameter>
#endif
void foo(int a) {
}
#include <leathers/pop>

int main() {
}
