#!/usr/bin/env bash

bang::commands::internal::quicktest() {
  local -r testname="${1:-}"
  if [[ -z "$testname" ]]; then
    bang::main::err::usage "you must provide a test name to 'quicktest'"
  fi
  bash "${_BANG_INSTALL_PATH}/quicktests/$testname.sh"
}

bang::commands::internal::run_test() {
  local -r testfile="$1"
  local -r testname="$2"

  bang::runner::run "$testfile" "$testname"
}

bang::commands::internal::run_testfile() {
  local -r testfile="$1"

  bang::exec internal load_tests "$testfile" \
    | bang::exec internal run_tests "$testfile" \
    | bang::exec internal report_test_results
}

bang::commands::internal::run_tests() {
  local -r testfile="$1"

  while read testname; do
    bang::exec internal run_test "$testfile" "$testname"
  done
}

bang::commands::internal::load_tests() {
  local -r testfile="$1"

  bang::loader::load_tests "$testfile"
  bang::loader::list_tests
}

bang::commands::internal::report_test_results() {
  bang::fmt::warn "report_test_results not yet implemented"
  cat
}

bang::commands::internal() {
  local -r cmd="${1:-}"
  shift || true
  if [[ -z "$cmd" ]]; then
    bang::main::err::usage "you must provide a sub-command to 'internal'"
  fi
  local -r func="bang::commands::internal::$cmd"

  if ! bang::helpers::func_exists "$func"; then
    bang::main::err::usage "the subcommand '$cmd' does not exist for 'internal'"
  fi

  "$func" "$@"
}
