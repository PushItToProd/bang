#!/usr/bin/env bash

bang::err::internal() {
  fmt::error "[INTERNAL ERROR] $@"
  exit 99
}

bang::err::user() {
  fmt::error "$@"
  exit 1
}
