#!/usr/bin/env bash
set -euo pipefail

# get the full directory name of the given file
bangentrypoint::getdir() {
  cd -P "$(dirname "$1")" >/dev/null 2>&1
  pwd
}

# get the actual path to this script by resolving any symlinks
# based on https://stackoverflow.com/a/246128
bangentrypoint::getsource() {
  SOURCE="${BASH_SOURCE[0]}"
  while [[ -h "$SOURCE" ]]; do
    DIR="$(bangentrypoint::getdir "$SOURCE")"
    SOURCE="$(readlink "$SOURCE")"
    # handle relative symlinks
    [[ "$SOURCE" != /* ]] && SOURCE="$DIR/$SOURCE"
  done
  printf "$(bangentrypoint::getdir "$SOURCE")"
}

SCRIPT_DIR="$(bangentrypoint::getsource)"
[[ "${BANG_DEBUG:-0}" -gt 50 ]] && echo "SCRIPT_DIR=$SCRIPT_DIR"
BANG_DIR="$(bangentrypoint::getdir "$SCRIPT_DIR/../lib/bang/x")"
[[ "${BANG_DEBUG:-0}" -gt 50 ]] && echo "BANG_DIR=$BANG_DIR"


for srcfile in "${BANG_DIR}/"*.sh; do
  [[ "${BANG_DEBUG:-0}" -gt 50 ]] && echo "bangentrypoint: sourcing $srcfile" >&2
  source "$srcfile"
done

source "${SCRIPT_DIR}/traceback_example.sh"

[[ "${BASH_SOURCE[0]}" == "$0" ]] && run_traceback_example
