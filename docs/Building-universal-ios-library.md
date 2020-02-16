### Overview
Universal library (multi-architecture library, fat library) is a library that contains several architectures.
Usually you can build library simply adding two or more `-arch` arguments:
```bash
> cat foo.cpp 
int foo() {
  return 0x42;
}
> clang++ -arch x86_64 -arch armv7 -c foo.cpp -o foo.a
> file foo.a 
foo.a: Mach-O universal binary with 2 architectures
foo.a (for architecture x86_64): Mach-O 64-bit object x86_64
foo.a (for architecture armv7):	Mach-O object arm
```
But not for ios (:

Different `isysroot` paths used during `iphoneos` and `iphonesimulator` compilation:
```bash
-isysroot /.../Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS7.0.sdk
-isysroot /.../Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator7.0.sdk
```
`clang` does not support multiple `isysroot` arguments, so you need to build every library individually and link them all together using [lipo](http://www.unix.com/man-page/osx/1/lipo/):
```bash
> lipo -output universal.a -create lib_x86_64.a lib_armv7.a
```
~~Additionally `install` cmake command [not working](http://public.kitware.com/Bug/view.php?id=12506) for `ios` targets.~~ Patched CMake version can be used to install universal libraries (`ios-universal*`):
* https://github.com/ruslo/CMake/releases

### Example (building universal library)

Copy `sugar` library and set environment variable `SUGAR_ROOT`:
```bash
> git clone https://github.com/ruslo/sugar
> cd sugar
> export SUGAR_ROOT=`pwd` # examples use this variable
> cd examples/06-ios/_universal_library/
```
Generate `Xcode` project with install prefix equals to example root directory (this is where
other examples found this library):
```bash
> cmake -H. -B_builds/xcode -GXcode -DCMAKE_INSTALL_PREFIX="`pwd`/install"
```

install library:
```bash
> cmake --build _builds/xcode --target install --config Release
> cmake --build _builds/xcode --target install --config Debug
...
** BUILD SUCCEEDED **
-- [iOS universal] Install done: /.../sugar/examples/06-ios/_universal_library/install/lib/libfood.a
...
```
Check installed files:
```bash
> ls install/include/
A.hpp
> ls install/lib/
cmake/     libfoo.a   libfood.a
> lipo -info install/lib/libfoo.a 
Architectures in the fat file: install/lib/libfoo.a are: i386 x86_64 armv7 armv7s arm64
```

### Example (linking libraries using find_package)
If you use this library not in one project, you can encapsulate all library/headers setting work inside `FooConfig.cmake` file and load this file using `find_package`:
```cmake
find_package(Foo CONFIG)
```
This will import `Foo::foo` target and reduce amount of boilerplate code.

```bash
> cd ..
> cd link_package
> cmake -H. -B_builds/xcode -GXcode
```
Note that for sake of simplicity `CMAKE_INSTALL_PREFIX` set inside `CMakeLists.txt`. More realistic
example of `find_package(... CONFIG)` can be found [here](https://github.com/forexample/package-example).

Open project in Xcode and build/test different configurations:
```bash
> open _builds/xcode/06-example-ios.link_package.xcodeproj
```

If you run application in `Debug` mode output will be:
* `Hello from libfood.a (debug)`

and if `Release`:

* `Hello from libfoo.a (release)`