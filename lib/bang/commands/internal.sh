#!/usr/bin/env bash

bang::commands::internal::quicktest() {
  local -r testname="${1:-}"
  if [[ -z "$testname" ]]; then
    bang::main::err::usage "you must provide a test name to 'quicktest'"
  fi
  bash "${_BANG_INSTALL_PATH}/quicktests/$testname.sh"
}

bang::commands::internal::run_tests() {
  bang::err::internal "not implemented"
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
