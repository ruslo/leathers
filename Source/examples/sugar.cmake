# This file generated automatically by:
#   generate_sugar_files.py
# see wiki for more info:
#   https://github.com/ruslo/sugar/wiki/Collecting-sources

if(DEFINED LEATHERS_SOURCE_EXAMPLES_SUGAR_CMAKE_)
  return()
else()
  set(LEATHERS_SOURCE_EXAMPLES_SUGAR_CMAKE_ 1)
endif()

include(sugar_files)

sugar_files(
    LEATHERS_EXAMPLES_SOURCES
    padded.cpp
)
