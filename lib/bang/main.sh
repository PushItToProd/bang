#!/usr/bin/env bash

readonly _BANG_COMMAND_PREFIX="bang::commands::"

declare _BANG_TEST_FILE
declare _BANG_COMMAND_NAME
declare _BANG_COMMAND_ARGS
declare _BANG_COMMAND_FUNC
declare -a _BANG_ARGS

bang::main() {
  bang::main::parse_args "$@"
  bang::main::exec
}

bang::main::exec() {
  "${_BANG_COMMAND_FUNC}" "${_BANG_COMMAND_ARGS[@]}"
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

bang::main::parse_args() {
  _BANG_ARGS=("$@")
  _BANG_COMMAND_NAME="${1:-}"
  shift || true
  _BANG_COMMAND_FUNC="${_BANG_COMMAND_PREFIX}${_BANG_COMMAND_NAME}"
  _BANG_COMMAND_ARGS=("$@")

  if [[ -z "$_BANG_COMMAND_NAME" ]]; then
    bang::main::err::usage "you must provide a command"
  fi

  if ! bang::helpers::func_exists "$_BANG_COMMAND_FUNC"; then
    bang::main::err::usage "the command '$_BANG_COMMAND_NAME' does not exist"
  fi
}
