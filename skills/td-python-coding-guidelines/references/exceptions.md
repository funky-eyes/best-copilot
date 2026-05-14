# Exception Handling (PyGuide Section 2.4)

## 1. When To Use Exceptions

Use exceptions for exceptional conditions and API contract failures, not normal control flow.

Good uses:

- invalid arguments,
- unavailable resources,
- failed external operations,
- impossible states that indicate a bug.

Bad uses:

- normal branches,
- loop termination when ordinary conditions work,
- replacing `if` validation.

## 2. Prefer Built-In Exceptions

Use built-in exceptions when they express the semantic meaning:

- `ValueError`: value is invalid.
- `TypeError`: type is invalid.
- `KeyError`: key is missing.
- `IndexError`: index is invalid.
- `FileNotFoundError`: file does not exist.
- `PermissionError`: operation lacks permission.

Principle: do not create a new exception when a built-in exception communicates the meaning clearly.

## 3. `assert` Boundaries

### Allowed Uses

- Test assertions.
- Internal invariants where removing the assertion does not change business correctness.
- Defensive checks that are purely for developer debugging.

### Forbidden Uses

- Runtime business validation.
- API precondition checks.
- User input validation.
- Security checks.
- Type narrowing that program correctness depends on.

Litmus test: if deleting the `assert` changes correct behavior, it is not an acceptable use.

## 4. Custom Exceptions

- Custom exceptions must inherit from an existing exception class.
- Names should end with `Error`.
- The class name should describe the domain error, not repeat the package or class name.
- Exception docstrings should describe the semantic condition.

```python
class InvalidPolicyError(ValueError):
    """Raised when a policy definition violates the business contract."""
```

## 5. Catch-All Exceptions

Avoid `except:`, `except Exception`, and `except BaseException`.

Two acceptable cases:

1. **Re-raise after adding context**

```python
try:
    run_step(step)
except Exception as exc:
    raise PipelineStepError(f'Failed step: {step.name!r}') from exc
```

2. **Isolation boundary**

```python
try:
    worker.run_forever()
except Exception:
    logging.exception('Worker crashed; isolating failure')
```

Even at an isolation boundary, avoid silently continuing without observability.

## 6. Exception Chaining

Use `raise NewError(...) from exc` when the new exception wraps a lower-level cause.

Use `raise NewError(...) from None` only when hiding the lower-level cause is intentional and safe for callers.

## 7. Cleanup

- Prefer `with` for resource cleanup.
- Use `finally` when the resource does not support context manager protocol or when cleanup must happen around a broader block.
- Do not return from `finally`.

## 8. Logging Exceptions

- Use `logging.exception(...)` inside an exception handler when stack trace is needed.
- Or use `logging.error(..., exc_info=True)`.
- Do not log only `str(exc)` when the stack trace is necessary for diagnosis.
- Do not log secrets or sensitive payloads.

## 9. Docstring `Raises:`

`Raises:` should document exceptions that are part of the public contract when the API is used correctly.

Do not list exceptions caused by API misuse, such as passing the wrong type when the type is already declared.

## 10. Common Anti-Patterns

- `except Exception: pass`.
- `except: pass`.
- Catching a broad exception around a large block and hiding the source.
- Creating meaningless exceptions such as `FooError` without domain semantics.
- Using `assert` for user input validation.
- Logging an exception without stack trace when stack trace is required.
- Raising raw `Exception`.
- Converting all errors into strings and losing type/cause.

## 11. Review Checklist

- [ ] Is a built-in exception enough?
- [ ] Does each custom exception inherit correctly and end with `Error`?
- [ ] Are broad catches limited to re-raise wrappers or isolation boundaries?
- [ ] Are resources cleaned up with `with` first, then `finally` only when needed?
- [ ] Does exception logging preserve stack trace when useful?
- [ ] Does `Raises:` document only API-contract exceptions?
- [ ] Are secrets and sensitive data excluded from exception messages and logs?
