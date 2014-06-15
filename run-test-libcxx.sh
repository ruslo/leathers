#!/bin/bash -e

set -x

echo ">>> Expected no warning messages <<<"

rm -rf _builds/fortesting

cmake -H. -B_builds/fortesting \
    -DCMAKE_TOOLCHAIN_FILE=${POLLY_ROOT}/libcxx.cmake \
    -DLEATHERS_BUILD_EXAMPLES=ON \
    -DLEATHERS_EXAMPLES_SHOW_WARNINGS=OFF \
    -DCMAKE_BUILD_TYPE=Release

COUT_LOG=_builds/fortesting/build.cout
CERR_LOG=_builds/fortesting/build.cerr

cmake --build _builds/fortesting \
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

rm -rf _builds/fortesting

cmake -H. -B_builds/fortesting \
    -DCMAKE_TOOLCHAIN_FILE=${POLLY_ROOT}/libcxx.cmake \
    -DLEATHERS_BUILD_EXAMPLES=ON \
    -DLEATHERS_EXAMPLES_SHOW_WARNINGS=ON \
    -DCMAKE_BUILD_TYPE=Release

EXPECTED=_builds/fortesting/expected

cmake --build _builds/fortesting \
    1> ${COUT_LOG} \
    2> ${CERR_LOG}

if [ "`grep -c warning ${COUT_LOG}`" != "0" ];
then
  echo "Warnings detected in ${COUT_LOG} file:"
  cat ${COUT_LOG}
  exit 1
fi

grep warning ${CERR_LOG} | sed 's,.*leathers,leathers,' > ${EXPECTED}

diff ${EXPECTED} expected-warnings/libcxx.log

echo "OK"
