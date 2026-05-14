# Google PyGuide Style Rules Quick Reference (Section 3)

Applies to formatting, whitespace, naming, comments, docstrings, strings, logging, TODOs, and import organization.

Related file: see `type-annotations.md` for type annotation details.

## 3.1 Semicolons

- Do not use semicolons to terminate statements.
- Do not put multiple statements on one line.

## 3.2 Line Length

- Follow the repository formatter. PyGuide defaults to 80 columns.
- Common exceptions include:
  - long URLs,
  - long import statements,
  - long flag or tool-disable comments,
  - command examples that cannot be split.
- Do not use backslashes for explicit line continuation. Use implicit continuation inside parentheses, brackets, or braces.
- Prefer breaking at the highest syntactic level and keep repeated breaks aligned by structure.
- A docstring summary line should fit within the line-length limit.

## 3.3 Parentheses

- Do not add unnecessary parentheses around `return` expressions or simple `if`/`while` conditions.
- Use parentheses for line continuation and clarity.

## 3.4 Indentation

- Use 4 spaces. Do not use tabs.
- Keep continuation indentation readable and consistent.
- Avoid vertical alignment with extra spaces because it is fragile.

### 3.4.1 Trailing Commas

- Use trailing commas where the repository formatter expects them for multiline literals or calls.
- Do not add trailing commas to force noisy formatting unless it improves diffs.

## 3.5 Blank Lines

- Separate top-level definitions with blank lines according to repository convention.
- Use blank lines inside functions only to group logical steps.
- Do not add decorative blank lines.

## 3.6 Whitespace

- Use normal spacing around operators and after commas.
- Do not add spaces inside parentheses, brackets, or braces.
- Do not vertically align `:`, `#`, or `=` with extra spaces.

## 3.7 Shebang Line

- Add a shebang only for files intended to be executed directly.
- Prefer `#!/usr/bin/env python3` when compatible with the repository.

## 3.8 Comments And Docstrings

### 3.8.1 General Docstrings

- Use triple double quotes for docstrings.
- A docstring should summarize the purpose and contract.
- Keep the first line short and meaningful.

### 3.8.2 Modules

- Module docstrings should describe what the module provides.
- Test module docstrings are optional unless they explain special setup, environment dependencies, or golden-file update procedures.

### 3.8.3 Functions And Methods

Write a docstring when any of these are true:

- the function is public,
- behavior is non-obvious,
- side effects matter,
- arguments or return semantics are not obvious,
- exceptions are part of the contract.

Common sections:

- `Args:` for parameters.
- `Returns:` for return semantics.
- `Yields:` for generators.
- `Raises:` for contract exceptions.

Do not list exceptions caused by API misuse as `Raises:` contract.

### 3.8.3.1 Overridden Methods

- If an override decorator is used and inherited behavior is unchanged, a repeated docstring may be unnecessary.
- Without an override marker, write a docstring when the override changes behavior.

### 3.8.4 Classes

- Class docstrings should describe responsibility and important attributes.
- Avoid redundant wording such as "Class that describes...".

### 3.8.5 Block And Inline Comments

- Use comments for complex or counterintuitive blocks.
- Explain why, not what the code plainly does.
- Keep inline comments short and useful.

### 3.8.6 Punctuation, Spelling, And Grammar

- Prefer complete sentences for longer comments.
- Keep style consistent within a file.

## 3.10 Strings

- Use one formatting style consistently within a local context: f-string, `%`, or `.format`.
- Do not use `+` for formatting multi-part strings. A single `+` can be acceptable, but repeated concatenation should be avoided.
- Do not build strings in loops with `+` or `+=`; use list append plus `''.join(...)` or `io.StringIO`.
- Use triple double quotes for docstrings.

### 3.10.1 Logging

- For logging methods that accept a `%` pattern, the first argument must be a literal pattern and values should be passed as later arguments.

Good:

```python
logging.info('Current $PAGER is: %s', os.getenv('PAGER', default=''))
logging.error('Cannot write to home directory, $HOME=%r', homedir)
```

Bad:

```python
logging.info(f'Current $PAGER is: {os.getenv("PAGER", "")}')
logging.info('Current $PAGER is:')
logging.info(os.getenv('PAGER', default=''))
```

### 3.10.2 Error Messages

- Error messages should be precise and easy to grep.
- Interpolated fragments should be obvious, such as `%r` or `{value=}`.
- Avoid messages that become ambiguous after interpolation.

## 3.11 Files, Sockets, And Similar Resources

- Use `with` statements for resources when possible.
- Explicitly manage lifetime for resources that cannot use context managers.

## 3.12 TODO Comments

- TODOs should follow repository convention.
- They need enough ownership and context to be actionable.
- Avoid stale TODOs without links, owners, or descriptions.

## 3.13 Imports Formatting

- Imports should be grouped and sorted according to repository tooling.
- Keep one import per line except approved grouped imports from `typing` or `collections.abc`.
- Avoid wildcard imports.

## 3.14 Statements

- One statement per line.
- Avoid compound statements after a colon.

## 3.15 Getters And Setters

- Use direct attributes for simple data.
- Use `@property` only when it provides meaningful logic while remaining cheap and unsurprising.
- Use explicit methods for expensive or side-effecting operations.

## 3.16 Naming

Use repository conventions first. PyGuide defaults:

| Type | Style |
| --- | --- |
| modules | `lower_with_under` |
| packages | `lower_with_under` |
| classes | `CapWords` |
| exceptions | `CapWordsError` |
| functions | `lower_with_under` |
| methods | `lower_with_under` |
| constants | `CAPS_WITH_UNDER` |
| private names | `_leading_underscore` |

- Avoid names that shadow builtins unless there is a strong reason.
- Avoid unclear abbreviations.

## 3.17 Main

- Executable modules should use:

```python
def main() -> None:
    ...


if __name__ == '__main__':
    main()
```

- Import-time behavior should be minimal.

## 3.18 Function Length

- Keep functions focused.
- Split functions when a smaller helper has a clear responsibility and improves testing or readability.
- Do not split only to satisfy a number if the result obscures flow.

## 3.19 Type Annotations

See `type-annotations.md`.
