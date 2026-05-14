# Programming Specification

## Naming Style

### Mandatory

1. Names must be meaningful and reflect business semantics. Avoid vague names such as `Data`, `Info`, `Common`, `Util`, or `Manager` unless they are already established in the target repository.
2. Class names use `UpperCamelCase`. Method, parameter, and local variable names use `lowerCamelCase`.
3. Constants use uppercase words separated by underscores.
4. Abstract classes may use the `Abstract` prefix or `Base` suffix according to repository convention.
5. Exception class names should end with `Exception`.
6. Test class names should correspond to the tested class or behavior.
7. Do not use pinyin or unclear abbreviations unless they are domain terms accepted by the repository.

### Recommended

8. Service and API names should include the concrete business capability.
9. Boolean fields should use positive, readable names.

## Constants

### Mandatory

1. Do not define magic values inline. Extract them to named constants when they carry business meaning.
2. Constant owners should be focused. Do not create catch-all constant classes.
3. Long and float constants should use uppercase suffixes where helpful for readability.

### Recommended

4. Prefer enum types for closed sets inside the application, but avoid exposing internal enums through public interface payloads unless the existing contract requires it.

## Code Formatting

### Mandatory

1. Use the repository formatter where one exists.
2. Keep indentation consistent.
3. Use braces for all `if`, `else`, `for`, `do`, and `while` statements, even for one-line bodies.
4. Keep one statement per line.
5. Avoid overly long methods and deeply nested branches.
6. Use blank lines to separate logical blocks, not to decorate code.

### Recommended

7. Prefer early returns for invalid states when it improves readability.
8. Keep method parameters manageable; introduce request objects when parameters become hard to understand.

## OOP Rules

### Mandatory

1. Avoid accessing static members through object references.
2. Override `equals` and `hashCode` together.
3. For objects used as `Set` elements or `Map` keys, `equals` and `hashCode` must be stable and correct.
4. Do not use deprecated APIs in new code unless compatibility requires it and the reason is documented.
5. Avoid exposing mutable internal collections directly.
6. Constructors should not perform complex work, network calls, or database calls.

### Recommended

7. Prefer composition over inheritance when inheritance does not model a real is-a relationship.
8. Keep class responsibilities focused.
9. Use interfaces for stable boundaries, not for every implementation class by default.

## Collections

### Mandatory

1. `keySet()`, `values()`, and `entrySet()` views must not be used to add elements.
2. `Collections.emptyList()` and `Collections.singletonList()` return immutable collections and must not be modified.
3. Do not cast `subList` to `ArrayList`; it is a view and changes to the original list can cause `ConcurrentModificationException`.
4. Convert lists to arrays with `toArray(T[] array)`. Do not use raw `toArray()` when a typed array is needed.
5. Do not add or remove elements inside foreach loops. Use `Iterator` or collect changes separately.
6. `Comparator` implementations must satisfy symmetry, transitivity, and consistency. Otherwise sort operations can throw `IllegalArgumentException`.

### Recommended

7. Specify initial capacity when creating large collections.
8. Understand each collection's null support and thread-safety behavior.
9. Use `Set` for deduplication instead of repeatedly calling `List.contains()`.
10. Avoid N+1 loops when a batch operation is available.

## Concurrency

### Mandatory

1. Singleton initialization and singleton methods must be thread-safe.
2. Threads must be named to make troubleshooting possible.
3. Threads must be provided by thread pools. Do not create threads directly in business code.
4. Prefer explicitly configured `ThreadPoolExecutor` over hidden defaults from `Executors`, unless the target repository has a documented exception.
5. `SimpleDateFormat` is not thread-safe and must not be stored as a shared static instance. Use `DateTimeFormatter` or `ThreadLocal` with cleanup.
6. `ThreadLocal` values must be removed in `finally`, especially in thread-pool scenarios, to prevent memory leaks and business data pollution.
7. Concurrent updates to the same record need locking or optimistic-lock protection. If conflict rate is low, optimistic lock with retry may be used; otherwise use pessimistic locking.

### Recommended

8. Every worker in a `CountDownLatch` flow should count down even on exception, and the caller should use a timeout.
9. Use `ThreadLocalRandom` instead of sharing `Random` across threads.
10. Be careful with `HashMap` under concurrency. Use concurrent collections when needed.

## Control Statements

### Mandatory

1. Every `switch` case must end with `break`, `return`, or equivalent termination, and must include `default`.
2. `if`, `else`, `for`, `do`, and `while` statements must always use braces.
3. Avoid complex nested ternary expressions.
4. Parameter validation is required for low-frequency methods, long-running methods, high-stability methods, Open APIs, and permission-related methods.

### Recommended

5. Keep conditions readable. Extract named variables or methods for complex boolean expressions.
6. Avoid deeply nested branches by using guard clauses when appropriate.

## Code Comments

### Mandatory

1. Abstract methods and interface methods must have Javadoc describing the method, parameters, return value, and possible exceptions.
2. Public or protected APIs should have Javadoc when their contract is not obvious from the signature.
3. Comments must be updated together with code changes.
4. Do not keep change history in code comments; Git owns history.

### Recommended

5. Comments should explain why, not simply repeat what the code does.
6. Use clear comments for non-obvious algorithms, concurrency assumptions, and compatibility constraints.
7. TODO/FIXME comments should include enough ownership and context to be actionable according to the repository convention.

## Other Rules

### Mandatory

1. Precompile regular expressions that are used repeatedly. Do not call `Pattern.compile(...)` repeatedly in hot methods.
2. In Velocity templates, use property names so the engine can call getters. Boolean wrapper types should prefer `getXxx()` over `isXxx()`.
3. Use `Random.nextInt()` or `Random.nextLong()` for random integers. Do not multiply `Math.random()` and cast.
4. Remove deprecated code or configuration promptly. Do not leave dead code in comments unless the repository has a temporary-removal convention and a reason is recorded.

### Recommended

5. Keep templates simple. Avoid variable declarations, complex expressions, and business logic in templates.
6. Prefer small, focused methods and classes that match the repository's existing architecture.
