#!/usr/bin/env bash

_BANG_ASSERT_CMD="bang::assert::assert"

declare -g _BANG_ASSERT_MESSAGE
declare -ag _BANG_ASSERT_COMMAND
declare -g _BANG_ASSERT_MODE
declare -g _BANG_ASSERT_FILE
declare -g _BANG_ASSERT_LINENO

bang::assert::declare_funcs() {
  @assert() {
    _BANG_ASSERT_CMD="@assert"
    bang::assert::assert "$@"
  }
}

# Helper for assertion errors since the assert name may differ.
bang::assert::err::internal() {
  bang::err::internal "${_BANG_ASSERT_CMD}: $@"
}

# Helper for assertion errors since the assert name may differ.
bang::assert::err::user() {
  bang::err::user "${_BANG_ASSERT_CMD}: $@"
}

# Entrypoint for actually running assertions.
bang::assert::assert() {
  bang::assert::init "$@"
  bang::assert::exec
  bang::assert::cleanup
}

bang::assert::expr_initialized() {
    [[ "${_BANG_ASSERT_COMMAND:+defined}" == "defined" ]]
}

# Check if any assertion config is already initialized.
bang::assert::is_dirty() {
  [[ -n "${_BANG_ASSERT_MESSAGE:-}" ]] \
    || bang::assert::expr_initialized \
    || [[ -n "${_BANG_ASSERT_MODE:-}" ]] \
    || [[ -n "${_BANG_ASSERT_FILE:-}" ]] \
    || [[ -n "${_BANG_ASSERT_LINENO:-}" ]]
}

# Check that all assertion config is initialized.
bang::assert::is_initialized() {
  [[ -n "${_BANG_ASSERT_MESSAGE:-}" ]] \
    && bang::assert::expr_initialized \
    && [[ -n "${_BANG_ASSERT_MODE:-}" ]] \
    && [[ -n "${_BANG_ASSERT_FILE:-}" ]] \
    && [[ -n "${_BANG_ASSERT_LINENO:-}" ]]
}

# Safely initialize the assertion.
bang::assert::init() {
  if bang::assert::is_dirty; then
    bang::assert::err::internal "init called without cleanup"
  fi
  bang::assert::parse "$@"
}

# Clean up after running.
bang::assert::cleanup() {
  _BANG_ASSERT_MESSAGE=""
  _BANG_ASSERT_COMMAND=()
  _BANG_ASSERT_MODE=""
  _BANG_ASSERT_FILE=""
  _BANG_ASSERT_LINENO=""
}

# Parse the arguments provided to @assert.
bang::assert::parse() {
  local searchuntil
  local syntaxerr
  local status

  if bang::assert::expr_initialized; then
    bang::assert::err::internal "an expression has already been initalized"
  fi

  case "$1" in
    \[)
       _BANG_ASSERT_MODE=bang::assert::expr
       searchuntil="]"
       ;;
    \[\[)
      _BANG_ASSERT_MODE=bang::assert::expr
      searchuntil="]]"
      ;;
    \()
      _BANG_ASSERT_MODE=bang::assert::eval
      searchuntil=")"
      ;;
    *)
      bang::assert::err::user "'$*' is not a valid invocation - no opening bracket found"
      ;;
  esac
  shift

  until [[ "$1" == "$searchuntil" ]]; do
    testcmd+=("$1")
    if ! shift; then
      bang::assert::err::user "expected terminator ($searchuntil) but none was found"
    fi
  done
  shift

  _BANG_ASSERT_MESSAGE="${1:-${testcmd[@]}}"
}

bang::assert::exec() {
  "$_BANG_ASSERT_MODE" "$_BANG_ASSERT_MESSAGE" "${_BANG_ASSERT_COMMAND[@]}"
}

bang::assert::expr() {
  local -r assertmsg="$1"
  shift
  local -ra testcmd="$@"
  if ! test "${testcmd[@]}"; then
    bang::assert::fail "$assertmsg" "${testcmd[@]}"
  fi
}

bang::assert::eval() {
  local -r assertmsg="$1"
  shift
  local -ra testcmd="$@"
  if ! eval "${testcmd[@]}" >/dev/null 2>/dev/null; then
    bang::assert::fail "$assertmsg" "${testcmd[@]}"
  fi
}

# Invoked when the assertion fails.
bang::assert::fail() {
  bang::traceback
  echo "Assertion failed: $assertmsg"
}
