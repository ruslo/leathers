#include <leathers/push>
#include <leathers/all>
# include <boost/predef.h>
#include <leathers/pop>

#if (BOOST_COMP_CLANG) || (BOOST_COMP_GNUC)
# define UNUSED __attribute__((unused))
#else
# define UNUSED
#endif

struct Foo {
} UNUSED;

int main() {
#include <leathers/push>
#if !defined(SHOW_WARNINGS)
# include <leathers/used-but-marked-unused>
#endif
  Foo foo;
  (void)foo;
#include <leathers/pop>
}
