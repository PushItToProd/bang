#!/usr/bin/env bash

export TESTCASE_DEFAULT_NAME=testcase

@test() {
  _TESTCASE_NAME="$1"
  _TESTCASE_LINENO="${BASH_LINENO[-2]}"
  _TESTCASE_FILE="${BASH_SOURCE[-2]}"
  _TESTCASE_ASSERTION_FAILURES=()
}

@endtest() {
  local -r testcase="${1:-$TESTCASE_DEFAULT_NAME}"
  run_test "$TESTCASE_DEFAULT_NAME" "$_TESTCASE_NAME"
  unset _TESTCASE_NAME
  unset _TESTCASE_LINENO
  unset _TESTCASE_FILE
  unset _TESTCASE_ASSERTION_FAILURES
}
