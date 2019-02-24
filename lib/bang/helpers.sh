#!/usr/bin/env bash
# Helpers for bash scripting convenient.

bang::helpers::is_defined() {
  local -n ref="$1"
  [[ "${ref+defined}" == "defined" ]]
}
