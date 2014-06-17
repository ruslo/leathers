// Copyright (c) 2014, Ruslan Baratov
// All rights reserved.

#define FOO 0

#include <leathers/push>
#if !defined(SHOW_WARNINGS)
# include <leathers/is-defined-to-be>
#endif

# ifdef FOO
# endif

#include <leathers/pop>

int main() {
}
