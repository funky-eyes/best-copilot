# Exception And Logging Specification

## Exception

### Mandatory

1. **Pre-checks are better than try-catch**: do not catch JDK runtime exceptions such as `NullPointerException` or `IndexOutOfBoundsException` when a pre-check can avoid them. Use try-catch only when pre-checking is difficult, such as `NumberFormatException`.
2. **Do not use exceptions for flow control**: exceptions are not normal business branches. They are inefficient and reduce readability.
3. **Keep try-catch precise**: do not wrap large blocks. Separate stable code from unstable code and catch specific exception types.
4. **Do not swallow exceptions**: either handle and log the exception, or rethrow it. The top layer must convert it into information understandable to the user or caller.
5. **Ensure rollback on exceptions**: methods that throw exceptions must preserve transaction rollback semantics.
6. **Close resources reliably**: streams, connections, sessions, and similar closeable resources must be closed. Java 7+ code should prefer try-with-resources.
7. **Do not return from `finally`**: a return in `finally` can hide exceptions or overwrite return values from try/catch.
8. **Catch compatible exception types**: the caught exception type must be the same type or a parent type of the thrown exception.

### Recommended

9. **Differentiate null and empty values**:
   - `null` means not initialized or absent.
   - an empty collection means initialized but empty.
   - a collection being non-empty does not mean its elements are non-null.
10. **Avoid duplicate exception handling**: do not log and rethrow the same exception repeatedly through multiple layers unless each layer adds useful context.
11. **Error codes versus exceptions**: HTTP/Open API should use error codes; internal application code should usually throw exceptions; cross-application RPC should wrap results with success state, error code, and message.
12. **Custom exceptions**: do not throw raw `RuntimeException`, `Exception`, or `Throwable`. Use semantic exceptions such as `DAOException` and `ServiceException`.

## Logs

### Mandatory

1. **Use the SLF4J facade**: do not directly use Log4j or Logback APIs.

```java
private static final Logger LOGGER = LoggerFactory.getLogger(CurrentClass.class);
```

2. **Retain logs for at least 15 days** because some failures appear on a weekly cycle.
3. **Use extended log naming**: `appName_logType_logName.log`, such as `mppserver_monitor_timeZoneConvert.log`. Store error logs and business logs separately.
4. **Use guards or placeholders for TRACE/DEBUG/INFO**:

```java
LOGGER.debug("Current id is {}", id);

if (LOGGER.isDebugEnabled()) {
    LOGGER.debug("Expensive value is {}", expensiveValue());
}
```

5. **Set Log4j additivity to false** to avoid duplicate log output.
6. **Exception logs must include context and stack trace**:

```java
LOGGER.error("Failed to process order, orderId={}", orderId, e);
```

### Recommended

7. **Log carefully**: do not enable DEBUG in production by default. Use WARN carefully for business behavior because excessive logs can fill disks.
8. **Use stable and searchable messages**: include important identifiers, state, and operation names.

## Additional Tongdun Exception Rules

### Mandatory

1. **Do not swallow exceptions**: after catch, log the exception or rethrow it.
2. **Do not use exceptions as business control flow**: `try-catch` must not replace `if-else`.
3. **Do not return from `finally`**.
4. **Use try-with-resources for resources**: `InputStream`, `Connection`, `Session`, and similar resources must be closed reliably.
5. **Layered exception semantics must be clear**: DAO throws `DAOException`; Service throws business-semantic exceptions; Web converts exceptions to responses. Do not expose technical exceptions outward.
6. **Use SLF4J as the logging facade**: do not directly call Log4j or Logback APIs.
7. **Use placeholders and pass exception objects**:

```java
LOGGER.error("Failed to execute task, taskId={}", taskId, e);
```

8. **Be restrained with production log levels**: DEBUG should be used carefully; WARN is for self-healing alerts; ERROR is for failures requiring intervention.

### Recommended

9. **Exception messages should include context**: include parameters, key IDs, and business state for troubleshooting.
10. **External exception messages must be masked**: never expose internal stack traces or implementation details.

## Additional Tongdun Comment Rules

### Mandatory

1. **Each `.java` file must have a complete file structure**: correct `package`, `import`, and class-level Javadoc that describes responsibility and author information when required by local convention.
2. **Public and protected methods must have Javadoc** with `@param`, `@return`, and `@throws` when applicable.
3. **Interface methods must have Javadoc** and should not explicitly declare the `public` modifier.
4. **Code changes must keep comments synchronized**: stale comments are forbidden.
5. **Do not maintain change history in code comments**: Git owns change history. Existing `@author` information may be retained if the local convention requires it.

### Recommended

6. **Comments should explain why**, not repeat what clear code already says.
7. **Keep comments concise and accurate**.
8. **Prefer `//` line comments** except for Javadoc. Avoid `/* */` block comments unless they are genuinely useful.
