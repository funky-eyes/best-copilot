# Type Annotations (PyGuide Sections 2.21 And 3.19)

## 0. General Rule

- Type analysis is encouraged.
- Public APIs must have type annotations.
- Use the repository's configured type checker, such as pytype, mypy, pyright, or pylance.
- If an annotation would be misleading, add a TODO or explanation instead of pretending it is precise.

## 3.19.1 General Rules

- Use modern type hints.
- Do not annotate `self` or `cls`.
- Do not annotate the return type of `__init__`; `None` is the only legal runtime result.
- Prefer precise types over `Any`.

## 3.19.2 Line Breaking

- Prefer breaking between parameters.
- Do not split between a parameter name and its type annotation.
- If a type is long, prefer breaking at the outer container while keeping inner types readable.

## 3.19.3 Forward Declarations

Use one of:

- `from __future__ import annotations` at the top of the file, preferred for modern code;
- string literal annotations when needed.

## 3.19.4 Default Values

- A default value of `None` does not imply the parameter type is nullable. Nullable types must be explicit.

```python
def load(path: str | None = None) -> bytes:
    ...
```

## 3.19.5 NoneType

- If a value can be `None`, declare it explicitly.
- Do not rely on implicit optional behavior.

Bad:

```python
def f(x: str = None): ...
```

Good:

```python
def f(x: str | None = None) -> None: ...
```

## 3.19.6 Type Aliases

- Use `TypeAlias` when defining a public or non-obvious alias.

```python
from typing import TypeAlias

UserId: TypeAlias = str
```

## 3.19.7 Ignoring Types

- Use `# type: ignore` only when necessary.
- Pytype-style category suppression is allowed if the repository uses pytype.
- Suppressions should include a reason when the reason is not obvious.

## 3.19.8 Typing Variables

- Prefer variable annotations when inference is insufficient.
- Do not add redundant annotations when inference is already clear.
- Do not add new type comments; use modern annotation syntax.

## 3.19.9 Tuples Vs Lists

- Use tuples for fixed-size heterogeneous structures.
- Use lists or sequences for variable-length homogeneous structures.

## 3.19.10 Type Variables

- Public or constrained `TypeVar` names should be descriptive.
- Single-letter names are acceptable only for simple private generic helpers.

```python
from typing import TypeVar

AddableType = TypeVar('AddableType')
```

## 3.19.11 String Types

- Use `str` for text and `bytes` for binary data.
- Use `AnyStr` only when multiple arguments or return values must be consistently text or bytes.

## 3.19.12 Imports For Typing

- Import names directly from `typing` and `collections.abc` when they are type primitives.

```python
from collections.abc import Mapping, Sequence
from typing import Any, Generic, TYPE_CHECKING, cast
```

- Prefer abstract containers such as `Sequence` and `Mapping` for public signatures.
- Use built-in generic containers such as `list[str]` and `tuple[int, str]` when a concrete type is required.
- Avoid deprecated `typing.List` and `typing.Tuple` in new code.

## 3.19.13 Conditional Imports

- Use `if TYPE_CHECKING:` only when runtime import must be avoided.
- Prefer normal top-level imports when possible.
- Types imported inside `TYPE_CHECKING` should be referenced as strings unless future annotations are enabled.
- Place the block after normal imports and keep it sorted.

## 3.19.14 Circular Dependencies

- Circular dependencies caused by annotations are a code smell. Prefer refactoring.
- Do not hide real dependency problems with `Any` unless there is a clear transitional reason.

## 3.19.15 Generics

- Generic types should include explicit type parameters.
- Missing type parameters often imply `Any` and should be avoided.

## 3.19.16 Build Dependencies

- If the project uses pytype, mypy, pyright, or another type checker, include the relevant checks in the build or CI path.
- Avoid long-lived type-check suppressions without ownership.

## Common Pitfall Checklist

- [ ] Public APIs are annotated.
- [ ] `None` is explicit.
- [ ] Generics have type parameters.
- [ ] `Any` is justified.
- [ ] `TYPE_CHECKING` does not hide avoidable imports.
- [ ] Suppressions include reasons.
- [ ] Runtime behavior does not depend on type-only imports.
