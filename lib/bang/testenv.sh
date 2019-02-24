#!/usr/bin/env bash

bang::testenv::init() {
  declare -g _TESTCASE_NAME
  declare -g _TESTCASE_LINENO
  declare -g _TESTCASE_FILE
  declare -ag _TESTCASE_ASSERTION_FAILURES
}

bang::testenv::reset() {
  _TESTCASE_NAME=""
  _TESTCASE_LINENO=""
  _TESTCASE_FILE=""
  _TESTCASE_ASSERTION_FAILURES=()
}
