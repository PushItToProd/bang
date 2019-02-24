#!/usr/bin/env bash

declare -a _BANG_RUNNER_TESTLIST

bang::runner::run() {
  local -r filename="$1"
  source "$filename"
}

bang::runner::init() {
  :
}

bang::runner::reset() {
  :
}

# Given a file, populate BANG_RUNNER_TESTLIST with the defined tests.
bang::runner::list_tests() {
  :
}
