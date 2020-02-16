This [script](https://github.com/ruslo/sugar/blob/master/examples/test.py) help to test examples build (build project + project compiling) using different [generators](http://www.cmake.org/cmake/help/v2.8.11/cmake.html#section_Generators) and [configurations](http://www.cmake.org/cmake/help/v2.8.11/cmake.html#variable:CMAKE_BUILD_TYPE).

### Current
* Current tested generators: `Unix Makefiles` and `Xcode` (if mac os detected).
* Current tested build types: default (no type specification), `Debug`, `Release`.

### Setup
Script `test.py` use some [external](https://github.com/ruslo/configs/tree/master/python/detail) modules.
You need to load it and set `GITENV_ROOT` variable. All steps can look like this:
```bash
> git clone https://github.com/ruslo/gitenv && cd gitenv
> export GITENV_ROOT=`pwd`
> git submodule update --init ./configs/ ./sugar/
> git submodule foreach 'git checkout master'
> ./sugar/examples/test.py
```

*Note*: for [libc++](http://libcxx.llvm.org/) linkage use `--libcxx` option

### Directory testing
You can test directories which only fit some pattern. For example:
```bash
> ./test.py --include ./02-common/
...
DONE LIST:
dir = ./02-common, generator = Unix Makefiles
dir = ./02-common, generator = Unix Makefiles
dir = ./02-common, generator = Unix Makefiles
dir = ./02-common, generator = Xcode
```
Note, that pattern `02-common` not fit `./02-common`:
```bash
> ./test.py --dir 02-common/
skip "./02-common" directory (not fit "02-common")
```

Also you can exclude some directories from build:
```bash
> ./test.py --exclude ./00-detect ./01-simple
exclude directories: ['./00-detect', './01-simple']
skip "./00-detect" directory (excluded)
skip "./01-simple" directory (excluded)
```