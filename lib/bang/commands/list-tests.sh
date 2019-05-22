#!/usr/bin/env bash

bang::commands::list-tests() {
  local -r testfile="$1"

  bang::loader::load_tests "$testfile"

  echo "Tests found in $testfile:"
  bang::loader::list_tests 'bang::commands::list-tests::print'
}

bang::commands::list-tests::print() {
  echo "  - $1"
}
