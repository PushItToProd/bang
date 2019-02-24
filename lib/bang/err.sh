#!/usr/bin/env bash

bang::err::internal() {
  bang::fmt::error "[INTERNAL ERROR]" "$@"
  exit 99
}

bang::err::user() {
  bang::traceback --skip-frames 1
  bang::fmt::error "[error]" "$@"
  exit 1
}
