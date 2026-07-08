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

- **[Mandatory]** Default virtual-thread usage should be task-per-virtual-thread. Virtual threads are lightweight and usually do not need reuse. Use `Executors.newVirtualThreadPerTaskExecutor()` only after checking the third-party library compatibility rules below.
- **[Mandatory]** Do not use virtual threads for CPU-intensive work. They are suitable for I/O-intensive workloads.
- **[Mandatory]** Do not store large objects in `ThreadLocal` from virtual threads. Virtual-thread cardinality can greatly amplify memory usage.

## 15.3 ThreadLocal Buffer Compatibility

- **[Mandatory]** Before using a per-task virtual-thread executor around an old client library, check whether the library stores large reusable buffers in `ThreadLocal` or per-thread caches. This includes known or suspected buffer-heavy clients such as Aerospike-client, fastjson, old serializers, codecs, drivers, and binary protocol clients.
- **[Mandatory]** If the library owns large `ThreadLocal` buffers and cannot be changed, do not run every request on a fresh virtual thread. Use a small, bounded fixed virtual-thread executor so a limited number of long-lived virtual worker threads can reuse those per-thread buffers.
- **[Mandatory]** Do not solve a `ThreadLocal` buffer problem by switching directly to an equally large platform-thread pool. A small fixed virtual-thread executor is usually lighter than the same-size platform-thread pool while still preserving ThreadLocal cache reuse.
- **[Mandatory]** If the library also pins carriers through `synchronized`, native calls, or other pinning behavior, `ThreadLocal` reuse is not enough. Isolate the library on a dedicated platform-thread executor or replace/upgrade the dependency.
- **[Recommended]** Bound concurrency and queue size explicitly for legacy-buffer paths. The pool size should be based on downstream capacity and buffer memory budget, not on request volume.

```java
// Good for legacy libraries that keep expensive ThreadLocal buffers.
// This intentionally reuses a small number of virtual worker threads.
ExecutorService legacyClientExecutor = new ThreadPoolExecutor(
    16,
    16,
    0L,
    TimeUnit.MILLISECONDS,
    new ArrayBlockingQueue<>(1024),
    Thread.ofVirtual().name("legacy-client-vt-", 0).factory(),
    new ThreadPoolExecutor.CallerRunsPolicy());

CompletableFuture<Result> future = CompletableFuture.supplyAsync(
    () -> aerospikeOrFastjsonCall(input),
    legacyClientExecutor);
```

```java
// Bad for ThreadLocal-buffer-heavy legacy clients.
// Each task gets a fresh virtual thread, so the library repeatedly allocates
// large per-thread buffers and cannot reuse them.
try (ExecutorService executor = Executors.newVirtualThreadPerTaskExecutor()) {
    executor.submit(() -> aerospikeOrFastjsonCall(input));
}
```
