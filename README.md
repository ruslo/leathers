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
