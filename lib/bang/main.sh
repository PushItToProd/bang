#!/usr/bin/env bash

bang::main() {
  local -r file="$1"
  bang::runner::run "$file"
}
