#!/usr/bin/env bash
set -euo pipefail

readonly _TEST_NAME=testcase

declare -A _BANG_LOADER_TESTS
declare _BANG_LOADER_CURRENT_TEST

bang::loader::declare_funcs() {
  @test() {
    _BANG_LOADER_CURRENT_TEST="$1"
  }

  @endtest() {
    _BANG_LOADER_TESTS["$_BANG_LOADER_CURRENT_TEST"]="$(declare -f testcase)"
  }
}

bang::loader::load_tests() {
  local -r testfile="$1"
  bang::loader::declare_funcs
  source "$testfile"
}

bang::loader::list_tests() {
  local -r callback="${1:-echo}"
  for test in "${!_BANG_LOADER_TESTS[@]}"; do
    "$callback" "$test"
  done
}

bang::loader::print_tests_full() {
  for test in "${!_BANG_LOADER_TESTS[@]}"; do
    echo "Test: $test"
    echo "${_BANG_LOADER_TESTS[$test]}"
  done
}

bang::loader::prep_testcase() {
  local -r testname="$1"

  eval "${_BANG_LOADER_TESTS[$testname]}"
  declare -g testcase
}
