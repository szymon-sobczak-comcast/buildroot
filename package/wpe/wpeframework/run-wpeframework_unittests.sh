#!/bin/bash

DIRECTORY="/root/test_coverage"
if [ ! -d $DIRECTORY ]; then
  mkdir $DIRECTORY
fi
export GCOV_PREFIX=$DIRECTORY
export GCOV_PREFIX_STRIP=7

/usr/bin/WPEFramework_test_tests
/usr/bin/WPEFramework_test_core
