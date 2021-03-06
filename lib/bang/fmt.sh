#!/usr/bin/env bash

_bang_fmt_bold="$(tput bold)"
_bang_fmt_color_error="$(tput setaf 9)"
_bang_fmt_color_success="$(tput setaf 2)"
_bang_fmt_color_warn="$(tput setaf 3)"
_bang_fmt_color_info="$(tput setaf 4)"
_bang_fmt_bgcolor_error="$(tput setab 1)"
_bang_fmt_bgcolor_success="$(tput setab 2)"
_bang_fmt_bgcolor_warn="$(tput setab 3)"
_bang_fmt_bgcolor_info="$(tput setab 4)"
_bang_fmt_reset="$(tput sgr0)"

bang::fmt::error() {
  echo "${_bang_fmt_bold}${_bang_fmt_bgcolor_error}[error]${_bang_fmt_reset} "\
       "${_bang_fmt_bold}${_bang_fmt_color_error}$*${_bang_fmt_reset}"
}

bang::fmt::warn() {
  echo "${_bang_fmt_bold}${_bang_fmt_bgcolor_warn}[warn]${_bang_fmt_reset} "\
       "${_bang_fmt_bold}${_bang_fmt_color_warn}$*${_bang_fmt_reset}"
}

bang::fmt::success() {
  echo "${_bang_fmt_bold}${_bang_fmt_color_success}[success] $*${_bang_fmt_reset}"
}

bang::fmt::info() {
  echo "${_bang_fmt_bold}${_bang_fmt_color_info}[info] $*${_bang_fmt_reset}"
}

main() {
  bang::fmt::error "This is an example error message."
  bang::fmt::success "This is an example success message."
  bang::fmt::warn "This is an example warn message."
  bang::fmt::info "This is an example info message."
}
[[ "${BASH_SOURCE[0]}" == "$0" ]] && main "$@"
unset -f main
