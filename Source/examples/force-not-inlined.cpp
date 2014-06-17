// Copyright (c) 2014, Ruslan Baratov
// All rights reserved.

#include <leathers/push>
#include <leathers/padded>
#include <leathers/undef>
#include <leathers/signed-unsigned-mismatch>
#include <leathers/behavior-change>
#include <leathers/layout-changed>
#include <leathers/catch-semantic-changed>
#include <leathers/assign-base-inaccessible>
#include <leathers/deprecated-declarations>
#include <leathers/copy-ctor-could-not-be-generated>
#include <leathers/static-ctor-not-thread-safe>
#if !defined(SHOW_WARNINGS)
# include <leathers/force-not-inlined>
#endif

#include <boost/xpressive/xpressive.hpp>

int main() {
  using namespace boost::xpressive;
  sregex pat1 = "foo" >> +space >> "bar";
}

#include <leathers/pop>