#!/usr/bin/env bash
set -euo pipefail

bang::exec() {
  "${_BANG_EXE_PATH}" "$@"
}
