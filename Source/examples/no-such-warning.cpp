// Copyright (c) 2014, Ruslan Baratov
// All rights reserved.

#include <boost/predef/compiler.h>

#if (BOOST_COMP_MSVC)
# include <leathers/push>
# if !defined(SHOW_WARNINGS)
#  include <leathers/no-such-warning>
# endif
# pragma warning(disable: 4675)
# include <leathers/pop>
#endif


int main() {
}
