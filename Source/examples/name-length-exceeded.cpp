// Copyright (c) 2014, Ruslan Baratov
// All rights reserved.

#include <leathers/push>
#include <leathers/all>
# include <string>
# include <map>
#include <leathers/pop>

#include <leathers/push>
#include <leathers/c++98-compat>
#if !defined(SHOW_WARNINGS)
# include <leathers/name-length-exceeded>
#endif
class A1 {};

using A2 = std::map<A1, A1>;
using A3 = std::map<A2, A2>;
using A4 = std::map<A3, A3>;
using A5 = std::map<A4, A4>;

int main() {
  A5 a;
  (void)a;
}

#include <leathers/pop>
