#!/usr/bin/env bash

declare _BANG_TEST_FILE

declare _BANG_MODE
declare _BANG_CMD

bang::main() {
  if [[ "${1:-}" == "--internal" ]]; then
    shift
    bang::main::parse_args_internal "$@"
  else
    bang::main::parse_args_external "$@"
  fi
}

bang::main::print_about() {
  cat <<EOF
bang: $_BANG_VERSION
EOF
  }

bang::main::print_usage() {
  cat <<EOF
Usage: $_BANG_SCRIPT_NAME <testfile>
EOF
  }

bang::main::err::usage() {
  local -r err="$*"
  bang::err::user "invalid arguments: $err" "$(bang::main::print_usage)"
}

bang::main::parse_args_external() {
  _BANG_MODE=external
  _BANG_CMD=exectestfile

  _BANG_TEST_FILE="${1:-}"
  if [[ -z "$_BANG_TEST_FILE" ]]; then
    bang::main::err::usage "a test file must be specified"
  fi
}

bang::main::parse_args_internal() {
  local -r cmd="$1"
  shift
  _BANG_MODE=internal
  case "$cmd" in
    --quicktest)
      source "${_BANG_INSTALL_PATH}/quicktests/${1}.sh"
      ;;
    run-tests)
      _BANG_CMD=run-tests
      ;;
    *)
      bang::err::internal "invalid internal mode command: $cmd"
      ;;
  esac
}
