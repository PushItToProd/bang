#!/usr/bin/env bash
set -euo pipefail

: "${BANG_DEBUG:=0}"  # set BANG_DEBUG to the lowest level if it isn't set
#
## get the full directory name of the given file
#bangentrypoint::getdir() {
#  cd -P "$(dirname "$1")" >/dev/null 2>&1
#  pwd
#}
#
## get the actual path to this script by resolving any symlinks
## based on https://stackoverflow.com/a/246128
#bangentrypoint::getsource() {
#  SOURCE="${BASH_SOURCE[0]}"
#  while [[ -h "$SOURCE" ]]; do
#    DIR="$(bangentrypoint::getdir "$SOURCE")"
#    SOURCE="$(readlink "$SOURCE")"
#    # handle relative symlinks
#    [[ "$SOURCE" != /* ]] && SOURCE="$DIR/$SOURCE"
#  done
#  printf "$(bangentrypoint::getdir "$SOURCE")"
#}
#
#export _BANG_SCRIPT_PATH="$(bangentrypoint::getsource)"
#(( "$BANG_DEBUG" >= 50 )) && echo "bangentrypoint: _BANG_SCRIPT_PATH=$_BANG_SCRIPT_PATH" >&2
#
#export _BANG_INSTALL_PATH="$(bangentrypoint::getdir "$_BANG_SCRIPT_PATH/../x")"
#(( "$BANG_DEBUG" >= 50 )) && echo "bangentrypoint: _BANG_INSTALL_PATH=$_BANG_INSTALL_PATH" >&2

source "$_BANG_INSTALL_PATH/lib/bootstrap.sh"

source "${_BANG_INSTALL_PATH}/quicktests/traceback_example.sh"

run_traceback_example
