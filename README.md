leathers
========

This C++ header only library helps to save some space while ignoring
compiler warnings by pragma pop/push mechanism.

### Example
Some mix-compiler code:

```cpp
#if defined(BOOST_MSVC)
# pragma warning(push)
# pragma warning(disable : 4511 4512)
#elif defined(BOOST_CLANG)
# pragma clang diagnostic push
# pragma clang diagnostic ignored "-Wexit-time-destructors"
#endif
// some code
#if defined(BOOST_MSVC)
# pragma warning(pop)
#elif defined(BOOST_CLANG)
# pragma clang diagnostic pop
#endif
```

12 lines of code for 2 compilers to ignore warning in 1 line.

Using this library:

```cpp
#include <leathers/push>
#include <leathers/exit_time_destructors>
// some code
#include <leathers/pop>
```

3 lines of code for **any** number of compilers to ignore warning in 1 line.

### Usage (manual install)

* Install `boost` (`config` library)
* Add `Source` directory to compiler include option: `-I${LEATHERS_ROOT}/Source`
```bash
> cat foo.cpp
#include <cstdio> // std::printf
#include <boost/config.hpp>

int main() {
  const char* fmt = "%d";

#include <leathers/push>
#include <leathers/format_nonliteral>
  std::printf(fmt, 1);
#include <leathers/pop>
}
> clang++ -I${BOOST_ROOT}/include -I${LEATHERS_ROOT}/Source -Weverything foo.cpp
```

### Usage (CMake, hunter package manager)
`Leathers` can be installed using [hunter](https://github.com/ruslo/hunter) package manager:
```bash
> cat CMakeLists.txt
cmake_minimum_required(VERSION 3.0)
project(Foo)

include(HunterGate.cmake)
hunter_add_package(Leathers)

find_package(Leathers CONFIG REQUIRED)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Weverything -Werror")

add_executable(foo foo.cpp)
target_link_libraries(foo leathers)
> cat foo.cpp
#include <cstdio> // std::printf
#include <boost/config.hpp>

int main() {
  const char* fmt = "%d";

#include <leathers/push>
#include <leathers/format_nonliteral>
  std::printf(fmt, 1);
#include <leathers/pop>
}
> cmake -H. -B_builds -DHUNTER_STATUS_DEBUG=ON
> cmake --build _builds
```
