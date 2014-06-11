#include <boost/config.hpp>

struct Foo {
  char x;
#include <leathers/push>
#include <leathers/padded>
  long y;
#include <leathers/pop>
};

int main() {
  // struct Foo must be used, otherwise there will be no warning (clang)
  return static_cast<int>(Foo().y);
}
