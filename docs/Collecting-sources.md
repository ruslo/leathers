# Overview
CMake provides several mechanisms for collecting targets source files:
* [file(GLOB ...)](http://www.cmake.org/cmake/help/v2.8.11/cmake.html#command:file)
* [aux_source_directory](http://www.cmake.org/cmake/help/v2.8.11/cmake.html#command:aux_source_directory)
* [add_library(... OBJECT ...)](http://www.cmake.org/cmake/help/v2.8.11/cmake.html#command:add_library)
* Explicit listing in `CMakeLists.txt`

Each of them suffers from different problems:
* `file(GLOB *)` and `aux_source_directory`
 * Well-known problem described in documentation:
<pre>
We do not recommend using GLOB to collect a list of source files from your source tree.
If no CMakeLists.txt file changes when a source is added or removed then the generated
build system cannot know when to ask CMake to regenerate.
</pre>
 * Even if careful programmer is okay with running cmake every time when file structure has been changed, you now not able to use automatic tools efficiently anymore (like [git-bisect](http://git-scm.com/docs/git-bisect)). You must not forget to **force all** project regeneration before every test.
 * Sometimes it's hard to describe the criteria of selection of sources. For example, files may not have extension like
[STL sources](http://en.cppreference.com/w/cpp/header/algorithm), directory can hold different groups of files, e.g. sources, mock-object, unit tests, resources... you may want to pick some files only if option enabled, etc.

* `add_library(... OBJECT ...)`
 * This function is not recursive. If you try to create "object library" with sources from another "object library",
you'll get the error:
<pre>
Only executables and non-OBJECT libraries may reference target objects.
</pre>
 * You can use "object library" only for creating target, but, for example, you are not able to set `COMPILE_DEFINITIONS` or `MACOSX_PACKAGE_LOCATION` source property
 * It is a **target**, so you need to invent names for all temporary "object library" targets and to watch
that there are no collisions occured. As far as target name is global, you can't create `templib` somewhere deeper
in `A` directory and create one more in `B` directory

* explicit listing in `CMakeLists.txt`
 * Well, that's why previous solutions exist (: if you got a lot of files in project and list them all
while creating target, soon your `CMakeLists.txt` will become unnavigatable and inflexible
 * There are some restrictions in reading variables across directories:
 * Example 1:
```cmake
# CMakeLists.txt 
cmake_minimum_required(VERSION 2.8.4)
project(proj)
add_subdirectory(A)
add_subdirectory(B)
```
```cmake
# A/CMakeLists.txt 
set(COMMON_SOURCES a.cpp)
```
```cmake
# B/CMakeLists.txt 
message("common sources: '${COMMON_SOURCES}'")
```
If you run `cmake`, output will be `common sources: ''` because variable has been updated only inside directory `A`.
You can fix it by adding [PARENT_SCOPE](http://www.cmake.org/cmake/help/v2.8.11/cmake.html#command:set):
```cmake
# A/CMakeLists.txt 
set(COMMON_SOURCES a.cpp PARENT_SCOPE)
```
 * But now you need to set `COMMON_SOURCES` in every intermediate directory, even if `CMakeLists.txt` not
using it explicitly. Example 2:
```cmake
# A/CMakeLists.txt
add_subdirectory(C)
set(COMMON_SOURCES ${COMMON_SOURCES} PARENT_SCOPE) # if you remove this, variable will be lost
```
```cmake
# A/C/CMakeLists.txt
set(COMMON_SOURCES a.cpp PARENT_SCOPE)
```
 * And even if this okay, you can't update variables simultaneously in two subdirectories. Directory that
parsed first is not able to see any variables from directory which parsed second. Example 3:
```cmake
# A/CMakeLists.txt
set(COMMON_SOURCES_A a.cpp PARENT_SCOPE)
message("from A: ${COMMON_SOURCES_A}")
message("from A: ${COMMON_SOURCES_B}")
```
```cmake
# B/CMakeLists.txt
set(COMMON_SOURCES_B b.cpp PARENT_SCOPE)
message("from B: ${COMMON_SOURCES_A}")
message("from B: ${COMMON_SOURCES_B}")
```
Output depends on order of directories' listing inside the top `CMakeLists.txt` file and may be:
```
from A: 
from A: 
from B: a.cpp
from B: 
```
or
```
from B: 
from B: 
from A: 
from A: b.cpp
```

# Separating Concepts
Take a look at your `CMakeLists.txt` file. What you see? (: Adding compile flags, definitions, searching libraries, checking options, ... let's call it `tuning`. Plus, of course, collecting sources for targets, let's call it `listing`:
![intro](https://raw.github.com/ruslo/sugar/master/wiki/images/collecting/png/intro-tuning-listing.png)
Let's make it in two steps:
* Imagine that all variables already contain all source lists:
![listing](https://raw.github.com/ruslo/sugar/master/wiki/images/collecting/png/listing.png)
* Tune your project:
![tuning](https://raw.github.com/ruslo/sugar/master/wiki/images/collecting/png/tuning.png)

Note that:
* Variable `SRC_3` can be used inside `C` directory even if `SRC_3` defined in `D`
* Directory `A` is not holding any `CMakeLists.txt` file anymore

# Implementation
Magic can be achieved using [two](https://github.com/ruslo/sugar/tree/master/cmake/collecting) macroses: [sugar_files](https://github.com/ruslo/sugar/tree/master/cmake/collecting#sugar_files) and [sugar_include](https://github.com/ruslo/sugar/tree/master/cmake/collecting#sugar_include), and one file `sugar.cmake`:
![sugar](https://raw.github.com/ruslo/sugar/master/wiki/images/collecting/png/sugar.png)

* `sugar_files`
 * Add files from current directory (usually) to given variable. `list(APPEND ...)` command has been used, i.e. `SRC_1` from `A` and `C` directories will be merged, but not overwriten
 * On adding file, relative path converted to absolute, so variable can further be used in any directory
* `sugar_include`
 * processes `sugar.cmake` file from given directory
 * uses cmake `include` command, so all variables `SRC_*` defined in the same scope. Note that `SRC_3` is visible even if `B` directory is not using it
* Note that `sugar.cmake` is a separate file and you can have `CMakeLists.txt` and `sugar.cmake` in one directory simultaneously

# Pros
* No cache variables, no additional properties, just `include` + `list(APPEND ...)`
* Implementation based on pure-cmake macro without any external tools. As a result `sugar.cmake` is a cmake file and you, for example, can easily test some variables:
```cmake
# inside sugar.cmake
if(UNIX)
  sugar_files(
      TARGET_A_SOURCES
      A_unix.cpp
      A_unix.hpp
  )
else()
  sugar_files(
      TARGET_A_SOURCES
      A_non_unix.cpp
      A_non_unix.hpp  
  )
endif()
```
* `sugar.cmake` file is included, so if you update source structure, cmake will run generator **automatically**
* Files listed explicitly:
```cmake
sugar_include(A)
sugar_include(B)
# sugar_include(C) # no, files from C not needed

sugar_files(
    TARGET_A_SOURCES
    A.cpp
    B.cpp
    # C.cpp # no, this file is not source, it's some example
)

sugar_files(
    TARGET_A_HEADERS
    A.hpp
    some_file_without_extension
)

sugar_files(
    TARGET_A_MOCKS
    A_mock_object.cpp # used only for testing
)
```
* Files listed locally:
```cmake
# this file can be easily verified by simple ls command:
# > ls .
# A/ B/ OtherDir/ some_file.cpp some_file.hpp
sugar_include(A)
sugar_include(B)
sugar_include(OtherDir)

sugar_files(
    SOURCES
    some_file.cpp
    some_file.hpp
    some_file.cxx # Where it comes from? There is no such file!
)
```
* Unlike "object library", variables can be used for any purpose:
```cmake
# inside some CMakeLists.txt
sugar_include(A) # update SOURCES and RESOURCES variables
set_source_files_properties(${SOURCES} PROPERTIES COMPILE_FLAGS "-Wall")
set_source_files_properties(${RESOURCES} PROPERTIES MACOSX_PACKAGE_LOCATION Resources)
```
* No temporary names, concept uses only names that you need
* First try to focus on source listing. When done, focus on project tuning
* Vice versa, when tuning done, focus on source listing. When file `A/foo.cpp` added, modify `A/sugar.cmake` only, no need to modify other files

# Usage
Typical `sugar.cmake` file:
```cmake
# sugar.cmake is an include file, so header guards required
# to prevent collisions make guard variable name like that: <PROJECT>_<PATH>_SUGAR_CMAKE_
# (compare to C++: http://google-styleguide.googlecode.com/svn/trunk/cppguide.xml, see 'The #define Guard')
if(defined MY_PROJECT_DIR_A_SUBDIR_B_)
  return()
else()
  set(MY_PROJECT_DIR_A_SUBDIR_B_ 1)
endif()

# load 'sugar_include.cmake' and 'sugar_files.cmake' modules with 'sugar_include' and 'sugar_files' macroses
include(sugar_include)
include(sugar_files)

# list directories
sugar_include(DirectoryFoo)
sugar_include(DirectoryBoo)

# list files
sugar_files(
    TARGET_MYLIB_SOURCES # tie source variable to target name for clearness and to prevent names collision
    foo.cpp # list only local files for easy verification
    boo.cpp
)

sugar_files(
    TARGET_MYBIN_SOURCES
    xxx.cpp
    yyy.cpp
)

sugar_files(
    MYPROJECT_RESOURCES
    cat.png
    girl.jpeg
)
```
Take a look at [this](https://github.com/ruslo/sugar/blob/master/python/generate_sugar_files.py) script if
you need to generate files from empty project:
```bash
> ls ./myproj_dir/A/
C/ CMakeLists.txt boo.hpp foo.cpp
> generate_sugar_files.py --top ./myproj_dir/ --var MYPROJ_SOURCES
> cat ./myproj_dir/A/sugar.cmake
# This file generated automatically by:
#   generate_sugar_files.py
# see wiki for more info:
#   https://github.com/ruslo/sugar/wiki/Collecting-sources

if(DEFINED MYPROJ_DIR_A_SUGAR_CMAKE_)
  return()
else()
  set(MYPROJ_DIR_A_SUGAR_CMAKE_ 1)
endif()

include(sugar_files)
include(sugar_include)

sugar_include(C)

sugar_files(
    MYPROJ_SOURCES
    boo.hpp
    foo.cpp
)
```

# Examples
* Examples can be found [here](https://github.com/ruslo/sugar/tree/master/examples)
 * Start from [simple](https://github.com/ruslo/sugar/tree/master/examples/01-simple) one file project
 * Listing [common](https://github.com/ruslo/sugar/tree/master/examples/02-common) sources from different subdirectories without any visibility problem described in [overview 1-3](#overview)
 * [this](https://github.com/ruslo/sugar/tree/master/examples/06-ios/empty_application) and [this](https://github.com/ruslo/sugar/tree/master/examples/06-ios/single_view_application) example
use same image resources selected by `sugar_include` from [external](https://github.com/ruslo/sugar/tree/master/examples/resources/ios/images) directory
