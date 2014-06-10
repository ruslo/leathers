#include <cstdint> // uint8_t
#include <iostream> // std::cout

#include <boost/config.hpp>

struct Foo {
  uint8_t x;
#include <leathers/push>
#include <leathers/padded>
  uint64_t y;
#include <leathers/pop>
};

int main() {
  // struct Foo must be used, otherwise there will be no warning (clang)
  std::cout << Foo().x << std::endl;
}
