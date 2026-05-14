# Google PyGuide Language Rules Quick Reference (Section 2)

Related files: see `exceptions.md` for exception details and `type-annotations.md` for type annotation details.

## 2.1 Lint

- Use the repository's configured linter. If PyGuide is the standard, use `pylint` and do not ignore warnings by default.
- When suppressing a warning, prefer a line-level or block-level `# pylint: disable=<symbolic-name>`.
- If the reason is not obvious from the warning name, add a short explanation.
- Prefer `pylint: disable`; do not use the old `pylint: disable-msg` form.

## 2.2 Imports

- Use `import` for packages and modules, not individual functions, classes, or constants.
- Allowed forms:
  - `import x`
  - `from x import y` where `x` is a package prefix and `y` is a module name
  - `from x import y as z` only for name conflicts, ambiguity, overly long module names, or overly generic module names
- `import y as z` should be used only for well-established community abbreviations such as `import numpy as np`.
- Relative imports are forbidden unless the target repository explicitly uses them.

## 2.3 Packages

- Import each module by its full package path.
- Do not assume the main program directory is on `sys.path`.

## 2.4 Exceptions

- Prefer built-in exceptions when they express the meaning, such as `ValueError` for invalid arguments.
- `assert` must not be used for business validation or precondition checks because it can be optimized away.
- Custom exceptions must inherit from an existing exception class and should end with `Error`.
- Avoid `except:`, `except Exception`, and `except StandardError` except for:
  - wrappers that immediately re-raise after adding context,
  - explicit isolation boundaries such as a top-level task runner that logs and contains failures.
- `Raises:` in docstrings should list only exceptions that are part of the correct-use API contract.

## 2.5 Mutable Global State

- Avoid mutable module-level or class-level global state.
- Global state breaks encapsulation, complicates parallelism, and can change behavior at import time.

## 2.6 Nested, Local, Inner Classes And Functions

- Do not nest functions merely to hide them. Prefer module-level helpers with a leading underscore so they remain testable.
- Nested definitions are acceptable when they close over a small amount of state and improve clarity.

## 2.7 Comprehensions And Generator Expressions

- Use comprehensions for simple readable transformations.
- Prefer readability over compactness.
- Break complex comprehensions into normal loops or named helpers.

## 2.8 Default Iterators And Operators

- Prefer direct iteration: `for key in adict`, not `for key in adict.keys()`.
- Prefer direct file iteration: `for line in afile`, not `afile.readlines()`.
- Do not modify a container while iterating over it.

## 2.9 Generators

- Use generators when they simplify streaming or lazy evaluation.
- Document generator side effects and resource lifetime when relevant.

## 2.10 Lambda Functions

- Lambdas should be simple and short.
- For common operations, prefer `operator` helpers such as `operator.mul`.
- Prefer generator expressions over `map()` or `filter()` with lambda when readability improves.

## 2.11 Conditional Expressions

- Ternary expressions should be used only when all three parts remain clear.
- If the expression does not fit naturally, use a normal `if` statement.

## 2.12 Default Argument Values

- Default argument values are evaluated once at module load time.
- Do not use mutable defaults such as `[]` or `{}`.
- Do not use runtime-dependent defaults such as `time.time()` or flag values.
- Use `None` as a sentinel and initialize inside the function when needed.

## 2.13 Properties

- Do not create a property just to wrap an internal attribute.
- Use direct public attributes for simple data.
- Use explicit methods for expensive, complex, or side-effecting operations.

## 2.14 True / False Evaluations

- Use Python's implicit truthiness where it is clear.
- Do not compare booleans to `False`; use `if not x:`.
- When distinguishing `False` from `None`, write the condition explicitly.
- Use `if seq:` and `if not seq:` for containers.
- Be careful not to treat `None` as `0` for integers.

## 2.16 Lexical Scoping

- Use closures only when they improve clarity.
- Avoid surprising name shadowing.

## 2.17 Function And Method Decorators

- Decorator docstrings must explain that the object is a decorator.
- Decorators should have tests.
- Decorators run at definition/import time, so they must not depend on external resources that may be unavailable, such as files, sockets, databases, or networks.

## 2.18 Threading

- Do not rely on built-in operations appearing atomic.
- Prefer `queue.Queue` for communication between threads.
- Use synchronization primitives from `threading`; prefer `threading.Condition` over hand-written low-level lock protocols when appropriate.

## 2.19 Power Features

- Avoid powerful but obscure features such as custom metaclasses, bytecode manipulation, dynamic inheritance, object re-parenting, import hacks, abusive `getattr`, monkey-patching internals, or custom `__del__` cleanup.

## 2.20 Modern Python: `__future__` Imports

- Use `from __future__ import ...` to enable newer syntax or semantics per file when needed.
- A common modern use is `from __future__ import annotations`.
- Do not remove existing `__future__` imports without understanding compatibility.

## 2.21 Type Annotated Code

- Type analysis is encouraged.
- Public APIs must have type annotations.
- Use pytype, mypy, pyright, or the repository's configured type checker in builds when available.
- Use `Any` only when unavoidable, and consider adding a TODO or explanation.

## Quick Memory Aid

Imports are explicit, defaults are safe, exceptions are specific, globals are controlled, decorators are import-safe, threading is deliberate, and public APIs are typed.
