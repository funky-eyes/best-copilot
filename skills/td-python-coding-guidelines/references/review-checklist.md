# Google PyGuide Code Review Checklist

Use this checklist for Python code review. Load the more detailed reference only when the touched area needs it:

- Language rules: `language-rules.md`
- Style rules: `style-rules.md`
- Exceptions: `exceptions.md`
- Type annotations: `type-annotations.md`

## A. Structure, Imports, And Packages

- [ ] Imports appear at the top of the file after module comments and docstrings.
- [ ] Imports are grouped and ordered according to repository convention.
- [ ] No relative imports unless the target repository explicitly uses them.
- [ ] `import package_or_module` is preferred over importing individual functions/classes, except for approved typing or local conventions.
- [ ] `from x import y as z` is used only for conflicts, ambiguity, overly long names, or overly generic module names.
- [ ] Each import line imports one module, except approved grouped imports from `typing` or `collections.abc`.

## B. Naming And Readability

- [ ] Module, package, class, method, function, constant, and variable names follow the local convention.
- [ ] Names describe business meaning, not implementation accidents.
- [ ] No misleading abbreviations or single-letter names outside tiny local scopes.
- [ ] The code is readable without clever tricks or unnecessary metaprogramming.

## C. Comments And Docstrings

- [ ] Public modules, classes, functions, and methods have docstrings when required.
- [ ] Docstrings describe contract, inputs, outputs, raised contract exceptions, and side effects where relevant.
- [ ] Comments explain why, not what obvious code does.
- [ ] Comments are synchronized with code.
- [ ] TODO format follows repository convention and has durable context.
- [ ] Tests are allowed to have lighter docstrings, but not meaningless comments.

## D. Exception Handling

- [ ] Built-in exceptions such as `ValueError` and `TypeError` are preferred when they express the error.
- [ ] Custom exceptions inherit from an appropriate exception class and end with `Error`.
- [ ] `assert` is not used for runtime business validation.
- [ ] No `except:` or broad `except Exception` unless it is a re-raise wrapper or explicit isolation boundary.
- [ ] Exception chaining uses `raise ... from ...` when preserving cause matters.
- [ ] Cleanup uses `with` first, then `finally` only when necessary.
- [ ] `Raises:` lists API-contract exceptions, not API misuse exceptions.

## E. Correctness And Robustness

- [ ] Mutable default arguments are not used.
- [ ] Runtime-computed defaults such as `time.time()` are not used as default argument values.
- [ ] Mutable global state is avoided or clearly justified.
- [ ] The code distinguishes `None`, falsey values, and empty containers correctly.
- [ ] Iteration does not mutate the container being iterated.
- [ ] Resource ownership is clear.

## F. Control Flow And Expressions

- [ ] Comprehensions are simple and readable.
- [ ] Lambdas are short; longer logic uses named functions.
- [ ] Conditional expressions fit naturally on one line or are rewritten as normal `if` statements.
- [ ] Complex boolean logic is named or split.

## G. Getters, Setters, And Properties

- [ ] Plain attributes are used when no logic is needed.
- [ ] Properties are used only when access has meaningful logic and remains cheap and unsurprising.
- [ ] Explicit methods are used for expensive or side-effecting operations.

## H. Decorators And Top-Level Code

- [ ] Decorators have tests and document that they are decorators.
- [ ] Decorators do not depend on resources unavailable at import time, such as files, sockets, databases, or network services.
- [ ] Top-level code does not perform expensive or side-effecting work.

## I. Resources And I/O

- [ ] Files, sockets, and other resources are managed with `with` where possible.
- [ ] Encoding is explicit when reading or writing text if the repository requires it.
- [ ] I/O errors are handled at the correct boundary.

## J. Strings, Logs, And Error Messages

- [ ] Logging calls use literal patterns plus arguments when the logging API supports lazy formatting.
- [ ] Logs do not use f-strings in hot paths when lazy formatting is available.
- [ ] Error messages are precise and grep-friendly.
- [ ] Logs and error messages do not expose secrets, credentials, tokens, or sensitive payloads.

## K. Type Annotations

See `type-annotations.md`.

- [ ] Public APIs have type annotations.
- [ ] Nullable types are explicit, such as `X | None`.
- [ ] Abstract containers from `collections.abc` are preferred for public signatures.
- [ ] Forward references use `from __future__ import annotations` or string literals.
- [ ] `TypeVar` and `ParamSpec` names are descriptive when public or constrained.
- [ ] `TYPE_CHECKING` is used only when runtime imports must be avoided.
- [ ] `# type: ignore` and tool-specific disables include a reason.

## L. Formatting And Whitespace

- [ ] Line length follows repository settings; PyGuide defaults to 80 columns with documented exceptions.
- [ ] No semicolons.
- [ ] No unnecessary parentheses around `return` or simple conditions.
- [ ] Indentation is consistent and uses spaces.
- [ ] Blank lines separate logical sections.

## M. Function Size

- [ ] Functions are focused and readable.
- [ ] Long functions are split when doing so clarifies behavior and does not create artificial abstraction.

## N. `__future__` And Modern Syntax

- [ ] `from __future__ import annotations` is used when helpful.
- [ ] Existing `__future__` imports are not removed without understanding compatibility.

## Review Output Template

Report findings in this structure:

```text
Findings:
- [Critical|Major|Minor] file:line - issue
  Area: imports / naming / docstring / exceptions / typing / whitespace / logging / resources / tests
  Evidence: ...
  Fix: ...

No issues found:
- State the reviewed scope.
- State the checks that were actually applied.
- State remaining test or verification gaps.
```
