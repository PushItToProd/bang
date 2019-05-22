#!/usr/bin/env bash

bang::commands::run() {
  local -r testfile="${1:-}"
  if [[ -z "$testfile" ]]; then
    bang::main::err::usage "bang run requires the name of a test file to run"
  fi

  bang::err::internal "not implemented"
}
