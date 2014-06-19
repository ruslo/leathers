#!/usr/bin/env python3

# Copyright (c) 2014, Ruslan Baratov
# All rights reserved.

import argparse
import os
import re
import shutil
import subprocess
import sys

parser = argparse.ArgumentParser(description="Script for library testing")
parser.add_argument(
    '--toolchain',
    choices=[
        'libcxx',
        'xcode',
        'vs2013x64',
        'vs2013'
    ],
    help="CMake generator/toolchain",
)

parser.add_argument(
    '--type',
    required=True,
    help="CMake build type",
)

args = parser.parse_args()

toolchain = ''
generator = ''
expected_log = ''
if args.toolchain == 'libcxx':
  toolchain = 'libcxx'
  expected_log = 'libcxx.log'
elif args.toolchain == 'xcode':
  toolchain = 'xcode'
  generator = '-GXcode'
  expected_log = 'xcode.log'
elif args.toolchain == 'vs2013x64':
  generator = '-GVisual Studio 12 2013 Win64'
  if args.type == "Debug":
    expected_log = 'vs-debug.log'
  else:
    expected_log = 'vs-release.log'
elif args.toolchain == 'vs2013':
  generator = '-GVisual Studio 12 2013'
  if args.type == "Debug":
    expected_log = 'vs-debug.log'
  else:
    expected_log = 'vs-release.log'
else:
  assert(False)

cdir = os.getcwd()

expected_log = os.path.join(cdir, 'expected-warnings', expected_log)
if not os.path.exists(expected_log):
  sys.exit('Path not found: {}'.format(expected_log))

def call(args):
  try:
    print('Execute command: [')
    for i in args:
      print('  `{}`'.format(i))
    print(']')
    result = subprocess.check_output(
        args,
        stderr=subprocess.STDOUT,
        universal_newlines=True
    )
    return result
  except subprocess.CalledProcessError as error:
    print(error)
    print(error.output)
    sys.exit(1)
  except FileNotFoundError as error:
    print(error)
    sys.exit(1)

call(['cmake', '--version'])

polly_root = os.getenv("POLLY_ROOT")
if not polly_root:
  sys.exit("Environment variable `POLLY_ROOT` is empty")

toolchain_option = ''
if toolchain:
  toolchain_path = os.path.join(polly_root, "{}.cmake".format(toolchain))
  toolchain_option = "-DCMAKE_TOOLCHAIN_FILE={}".format(toolchain_path)

build_dir = os.path.join(cdir, '_builds', 'ForTesting')
build_dir_option = "-B{}".format(build_dir)

build_type_for_generate_step = "-DCMAKE_BUILD_TYPE={}".format(args.type)

def remove_useless_info(line):
  line = line.replace("no-such-warning", "")
  line = line.replace("1 warning generated.", "")
  line = line.replace("2 warnings generated.", "")
  line = line.replace("For Visual Studio warning", "") # nice comment :)
  line = line.replace("to silence this warning", "")
  line = line.replace(cdir, "")
  line = line.replace(cdir.lower(), "") # strange MSVC feature
  return line

# Expected no warnings

shutil.rmtree(build_dir, ignore_errors=True)

generate_command = [
    'cmake',
    '-H.',
    build_dir_option,
    '-DLEATHERS_BUILD_EXAMPLES=ON',
    '-DLEATHERS_EXAMPLES_SHOW_WARNINGS=OFF',
    build_type_for_generate_step
]

if generator:
  generate_command.append(generator)

if toolchain_option:
  generate_command.append(toolchain_option)

build_command = [
    'cmake',
    '--build',
    build_dir,
    '--config',
    args.type
]

call(generate_command)
build_log = call(build_command)

build_lines = build_log.split('\n')
for line in build_lines:
  line = remove_useless_info(line)
  if line.find("warning") != -1:
    print("Build generates warning (line: `{}`)".format(line))
    print("Full log:\n{}".format(build_log))
    sys.exit(1)

# Expected warning list

shutil.rmtree(build_dir, ignore_errors=True)

generate_command = [
    'cmake',
    '-H.',
    build_dir_option,
    '-DLEATHERS_BUILD_EXAMPLES=ON',
    '-DLEATHERS_EXAMPLES_SHOW_WARNINGS=ON',
    build_type_for_generate_step
]

if generator:
  generate_command.append(generator)

if toolchain_option:
  generate_command.append(toolchain_option)

build_command = [
    'cmake',
    '--build',
    build_dir,
    '--config',
    args.type
]

call(generate_command)
build_log = call(build_command)

expected_warnings = open(expected_log, "r").read()
result_warnings = ""

build_lines = build_log.split('\n')
build_lines.sort()

for line in build_lines:
  line = remove_useless_info(line)
  if line.find("warning") != -1:
    result_warnings += line
    result_warnings += '\n'

if expected_warnings != result_warnings:
  print("Expected:")
  print(expected_warnings)
  print("Result:")
  print(result_warnings)
  temp = '__temp-expected.log'
  open(temp, 'w').write(result_warnings)
  print('Files differ:\n  {}\n  {}'.format(expected_log, temp))
  sys.exit(1)

print("OK")
