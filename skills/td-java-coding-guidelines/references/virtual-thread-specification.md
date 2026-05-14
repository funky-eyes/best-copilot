# JDK 21 Virtual Thread Specification

> Applies only to modules that explicitly use JDK 21 and enable virtual threads.

## 15.1 Pinning Prevention

- **[Mandatory]** When a virtual-thread scheduler encounters a `synchronized` block, pinning can occur. The virtual thread is pinned to a platform thread, preventing that platform thread from being reused by other virtual threads and seriously reducing throughput. Code executed on virtual threads should replace `synchronized` with `ReentrantLock`.

```java
// Bad, inside a virtual-thread execution path
synchronized (lock) {
    doIo();
}

// Good
lock.lock();
try {
    doIo();
} finally {
    lock.unlock();
}
```

- **[Mandatory]** Third-party library compatibility must be checked:
  - **JDBC drivers**: some drivers use `synchronized` heavily. Upgrade to versions that support virtual threads.
  - **Connection pools**: HikariCP should be `>= 5.1.0` for virtual-thread-friendly behavior. Older versions can pin because of internal `synchronized` usage.
  - **Apache Commons Pool (`commons-pool2`)**: `GenericObjectPool` and `GenericKeyedObjectPool` use internal `synchronized` locks. If the call path runs on virtual threads, borrow/return operations can pin. This affects Jedis, DBCP2, and other commons-pool2 users. Move those calls to a dedicated platform-thread executor or replace the dependency with a virtual-thread-friendly implementation, such as Lettuce + Netty or HikariCP 5.1+.
  - **SLF4J/Logback**: some `ConsoleAppender` versions use `synchronized`. In high-concurrency logging scenarios, upgrade or switch to an async appender.

  Diagnostic JVM flag:

```text
-Djdk.tracePinnedThreads=full
```

When pinning happens, the JVM prints full stack traces that can be used to locate the offending dependency.

- **[Mandatory]** If a third-party library cannot avoid `synchronized`, such as an old JDBC driver, isolate it in a dedicated platform-thread pool. Do not call it directly from virtual threads.

```java
// Submit the blocking call to a platform-thread pool.
// The virtual thread waits for the result but is not pinned.
Future<Result> future = platformExecutor.submit(() -> legacyBlockingCall());
return future.get();
```

## 15.2 Virtual Thread Pool Configuration

- **[Mandatory]** A virtual-thread pool should not set core/max limits. Virtual threads are lightweight and do not need reuse. Use `Executors.newVirtualThreadPerTaskExecutor()`.
- **[Mandatory]** Do not use virtual threads for CPU-intensive work. They are suitable for I/O-intensive workloads.
- **[Mandatory]** Do not store large objects in `ThreadLocal` from virtual threads. Virtual-thread cardinality can greatly amplify memory usage.
