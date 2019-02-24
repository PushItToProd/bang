#!/usr/bin/env bash
set -euo pipefail
shopt -s nullglob

(( "$BANG_DEBUG" >= 50 )) && echo "bang.sh: Loading modules" >&2

export BANG_DIR="$(bangentrypoint::getdir "$BASE_DIR/lib/bang/x")"
(( "$BANG_DEBUG" >= 50 )) && echo "BANG_DIR=$BANG_DIR" >&2

for srcfile in "${BANG_DIR}/"*.sh; do
  (( "$BANG_DEBUG" >= 50 )) && echo "bangentrypoint: sourcing $srcfile" >&2
  source "$srcfile"
done

for srcfile in "${BANG_DIR}/"**/*.sh; do
  (( "$BANG_DEBUG" >= 50 )) && echo "bangentrypoint: sourcing $srcfile" >&2
  source "$srcfile"
done

shopt -u nullglob
