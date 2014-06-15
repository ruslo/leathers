// Copyright (c) 2014, Ruslan Baratov
// All rights reserved.

void foo();

#include <leathers/push>
#if !defined(SHOW_WARNINGS)
# include <leathers/c++98-compat-pedantic>
#endif
void foo() {
};
#include <leathers/pop>

int main() {
}
