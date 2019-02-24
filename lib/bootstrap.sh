#!/usr/bin/env bash
set -euo pipefail
shopt -s nullglob

(( "$BANG_DEBUG" >= 50 )) && echo "bootstrap.sh: Loading modules" >&2

export _BANG_MODULE_PATH="$(bangentrypoint::getdir "$_BANG_INSTALL_PATH/lib/bang/x")"
(( "$BANG_DEBUG" >= 50 )) && echo "bootstrap.sh: _BANG_MODULE_PATH=$_BANG_MODULE_PATH" >&2

for srcfile in "${_BANG_MODULE_PATH}/"*.sh; do
  (( "$BANG_DEBUG" >= 50 )) && echo "bootstrap.sh: sourcing $srcfile" >&2
  source "$srcfile"
done

for srcfile in "${_BANG_MODULE_PATH}/"**/*.sh; do
  (( "$BANG_DEBUG" >= 50 )) && echo "bootstrap.sh: sourcing $srcfile" >&2
  source "$srcfile"
done

shopt -u nullglob
