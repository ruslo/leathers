#!/bin/bash -e

set -x

rm -rf _builds/release _install

cmake -H. -B_builds/release \
    -DCMAKE_TOOLCHAIN_FILE=${POLLY_ROOT}/libcxx.cmake \
    -DCMAKE_VERBOSE_MAKEFILE=ON \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX="`pwd`/_install"

cmake --build _builds/release --target install
