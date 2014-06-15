#!/bin/bash -e

set -x

echo ">>> Expected no warning messages <<<"

rm -rf _builds/fortesting/xcode

cmake -H. -B_builds/fortesting/xcode \
    -DCMAKE_TOOLCHAIN_FILE=${POLLY_ROOT}/xcode.cmake \
    -GXcode \
    -DLEATHERS_BUILD_EXAMPLES=ON \
    -DLEATHERS_EXAMPLES_SHOW_WARNINGS=OFF \
    -DCMAKE_BUILD_TYPE=Release

COUT_LOG=_builds/fortesting/xcode/build.cout
CERR_LOG=_builds/fortesting/xcode/build.cerr

cmake --build _builds/fortesting/xcode \
    1> ${COUT_LOG} \
    2> ${CERR_LOG}

if [ "`grep -c warning ${COUT_LOG}`" != "0" ];
then
  echo "Warnings detected in ${COUT_LOG} file:"
  cat ${COUT_LOG}
  exit 1
fi

if [ "`wc -l ${CERR_LOG} | awk '{print $1;}'`" != "0" ];
then
  echo "Unexpected data in cerr file:"
  cat ${CERR_LOG}
  exit 1
fi

echo ">>> Warning messages expected <<<"

rm -rf _builds/fortesting/xcode

cmake -H. -B_builds/fortesting/xcode \
    -DCMAKE_TOOLCHAIN_FILE=${POLLY_ROOT}/xcode.cmake \
    -GXcode \
    -DLEATHERS_BUILD_EXAMPLES=ON \
    -DLEATHERS_EXAMPLES_SHOW_WARNINGS=ON \
    -DCMAKE_BUILD_TYPE=Release

EXPECTED=_builds/fortesting/xcode/expected

cmake --build _builds/fortesting/xcode \
    1> ${COUT_LOG} \
    2> ${CERR_LOG}

if [ "`grep -c warning ${CERR_LOG}`" != "0" ];
then
  echo "Warnings detected in ${CERR_LOG} file:"
  cat ${CERR_LOG}
  exit 1
fi

# Need to sort because parallel xcode build results unpredicable order
grep warning ${COUT_LOG} | sed 's,.*leathers,leathers,' | sort > ${EXPECTED}

diff ${EXPECTED} expected-warnings/xcode.log

echo "OK"
