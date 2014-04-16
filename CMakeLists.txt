# Copyright (c) 2014, Ruslan Baratov
# All rights reserved.

cmake_minimum_required(VERSION 3.0)
project(Leathers)

include(HunterGate.cmake)
hunter_add_package(Boost)

find_package(Boost REQUIRED)

add_subdirectory(Source)
