#!/usr/bin/env bash
set -euo pipefail

_BANG_TRACEBACK_DEFAULT_NAME="default"

bang::traceback() {
  bang::traceback::create
  bang::traceback::print
}

bang::traceback::new() {
  local -r tb_name="${1:-${_BANG_TRACEBACK_DEFAULT_NAME}}"

  declare -ga "_bang_traceback_${tb_name}_funcname"
  declare -ga "_bang_traceback_${tb_name}_lineno"
  declare -ga "_bang_traceback_${tb_name}_source"
  declare -ga "_bang_traceback_${tb_name}_fileline"
}

# Destroy all objects associated with the traceback.
bang::traceback::destroy() {
  local -r tb_name="${1:-${_BANG_TRACEBACK_DEFAULT_NAME}}"

  unset "_bang_traceback_${tb_name}_funcname"
  unset "_bang_traceback_${tb_name}_lineno"
  unset "_bang_traceback_${tb_name}_source"
  unset "_bang_traceback_${tb_name}_fileline"
}

bang::traceback::exists() {
  local -r tb_name="${1:-${_BANG_TRACEBACK_DEFAULT_NAME}}"

  bang::helpers::is_defined "_bang_traceback_${tb_name}_funcname" \
    || bang::helpers::is_defined "_bang_traceback_${tb_name}_lineno" \
    || bang::helpers::is_defined "_bang_traceback_${tb_name}_source" \
    || bang::helpers::is_defined "_bang_traceback_${tb_name}_fileline"
}

# Save a copy of the Bash variables reflecting the current traceback.
bang::traceback::create() {
  local -r tb_name="${1:-${_BANG_TRACEBACK_DEFAULT_NAME}}"

  bang::traceback::new "$tb_name"

  local -n tb_funcname="_bang_traceback_${tb_name}_funcname"
  local -n tb_lineno="_bang_traceback_${tb_name}_lineno"
  local -n tb_source="_bang_traceback_${tb_name}_source"
  local -n tb_fileline="_bang_traceback_${tb_name}_fileline"

  local funcname lineno source fileline

  # Reverse the arrays so that the most recent invocation comes last.
  # We start at i=1 because this function should not be included in
  # the traceback.
  for ((i="${#BASH_SOURCE[@]}"-1; i>0; i--)); do
    source="${BASH_SOURCE[$i]}"

    # BASH_LINENO is offset from FUNCNAME and BASH_SOURCE because it's
    # not set for the current function.
    lineno="${BASH_LINENO[$i-1]}"

    funcname="${FUNCNAME[$i]}"
    # The very last frame is the script-level invocation which sets
    # FUNCNAME to 'main', but we name main functions 'main' so this is
    # confusing. Thus, we override the funcname to clearly indicate
    # this is the script file.
    if (( "$i" == "${#BASH_SOURCE[@]}" - 1)); then
      funcname="<file>"
    fi

    fileline="$(bang::traceback::_fileline "$source" "$lineno")"

    tb_funcname+=("$funcname")
    tb_lineno+=("$lineno")
    tb_source+=("$source")
    tb_fileline+=("$fileline")
  done

  #funcname=("${FUNCNAME[@]::${#FUNCNAME[@]}-1}")
  #lineno=("${BASH_LINENO[@]::${#BASH_LINENO[@]}-1}")
  #source=("${BASH_SOURCE[@]::${#BASH_SOURCE[@]}-1}")
}

# Get the given line number of the file with leading and trailing
# whitespace trimmed.
bang::traceback::_fileline() {
  local -r file="$1"
  local -r line="$2"
  sed "${line}q;d" "$file" | awk '{$1=$1};1'
}

# Print the named traceback.
bang::traceback::print() {
  local -r tb_name="${1:-${_BANG_TRACEBACK_DEFAULT_NAME}}"
  local -r skip_frames="${2:-1}"
  local -n tb_funcname="_bang_traceback_${tb_name}_funcname"
  local -n tb_lineno="_bang_traceback_${tb_name}_lineno"
  local -n tb_source="_bang_traceback_${tb_name}_source"
  local i funcname lineno source line


  for ((i=0; i < "${#tb_funcname[@]}" - "$skip_frames"; i++)); do
    funcname="${tb_funcname[$i]}"
    lineno="${tb_lineno[$i]}"
    source="${tb_source[$i]}"
    line="$(bang::traceback::_fileline "$source" "$lineno")"

    echo "- $source:$funcname:$lineno"
    echo "    $line"
  done
}
