// Copyright (c) 2014, Ruslan Baratov
// All rights reserved.

template <class T>
class Foo {
};

int main() {
#include <leathers/push>
#if !defined(SHOW_WARNINGS)
# include <leathers/digraphs-not-supported>
#endif
    Foo<::Foo<char>> x;
#include <leathers/pop>
    (void)x;
}
