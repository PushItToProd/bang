# bang

A test library for bash.

## Project layout

### Directories

* `bin` contains the `bang` entrypoint
* `examples` contain code demonstrating the usage of bang
* `lib` contains the modules that comprise bang's core functionality
  * `exports` contains modules defining functions that will be exposed
    to test code
* `privatebin` contains internal entrypoints that are used to isolate
  test executions

## Conventions

### Files

There are two kinds of files containing bash code: executables and
modules.

* Executables are entrypoints that are intended to be called directly.
  * Executables must never be sourced.
  * Executables must contain as little code as possible. They should
    only perform some basic setup and then call out to a module
    function.
  * Executables names must not include an extension. (e.g. it's
    `bang`, not `bang.sh`)

* Modules define the code that does the work.
  * Modules must never be called directly.
  * Modules must never have side effects until they are invoked.
  * Module filenames must end with `.sh`.

### Modules

* Each module's name should be one short word (e.g. `assert`, `err`).
* To prevent collisions, all global names must be namedspaced.
  * Module-scope variables must be all-caps and prefixed with `_BANG_`
    followed by an underscore-delimited list of module names.
    * Thus, if we want to declare a variable `VAR` in a module file at
      `lib/foo/bar.sh`, the actual variable name should be
      `_BANG_FOO_BAR_VAR`.
  * Function names must be prefixed with `bang::` followed by a list
    of module names delimited by `::`.
    * Thus, if we want to declare a function `func` in
      `lib/foo/bar.sh`, our function must be named
      `bang::foo::bar::func`.
