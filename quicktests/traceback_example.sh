#!/usr/bin/env bash

run_traceback_example() {
  foo args-to-foo
}

foo() {
  bar args-to-bar
}

bar() {
  baz args-to-baz
}

baz() {
  bang::traceback --skip-frames 1
  #bang::traceback
}
