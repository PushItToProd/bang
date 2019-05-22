#!/usr/bin/env bash

declare _BANG_RUNNER_CURRENT_TESTCASE
declare _BANG_RUNNER_TARGET_TESTCASE

bang::runner::run() {
  local -r filename="$1"
  local -r testname="$2"

  # This approach doesn't work because it means the traceback doesn't show any
  # of the actual test code.
  #bang::loader::load_tests "$filename"
  #bang::loader::prep_testcase "$testname"
  #bang::assert::declare_funcs
  #testcase

  _BANG_RUNNER_TARGET_TESTCASE="$testname"
  source "$filename"
}

bang::runner::declare_functions(){
  @test() {
    _BANG_RUNNER_CURRENT_TESTCASE="$1"
  }

  @endtest() {
    if [[ "$_BANG_RUNNER_CURRENT_TESTCASE" == "$_BANG_RUNNER_TARGET_TESTCASE" ]]; then
      testcase
    fi
  }
}
