#!/usr/bin/env bash
# Helpers for bash scripting convenient.

bang::helpers::is_defined() {
  local -n ref="$1"
  [[ "${ref+defined}" == "defined" ]]
}

bang::helpers::func_exists() {
  declare -f "$1" >/dev/null 2>/dev/null
}
