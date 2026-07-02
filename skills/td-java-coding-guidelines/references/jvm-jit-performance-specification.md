# JVM JIT Performance Specification

> Applies to performance-sensitive Java code, hot request paths, batch loops, serialization/deserialization, codec logic, rule engines, pricing/risk calculations, middleware adapters, and any code where latency, allocation rate, or CPU efficiency is an explicit requirement.

These rules aim to make code easier for HotSpot C2 and Graal JIT to optimize through method inlining, escape analysis, scalar replacement, lock elimination/coarsening, devirtualization, loop optimization, bounds-check elimination, and branch-predictable control flow. They improve the odds of strong JIT output; they do not guarantee native-equivalent performance. Do not apply them blindly to cold code where readability and maintainability dominate.

## 16.1 Measurement And Scope

- **[Mandatory]** Any change justified by JVM performance must identify the hot path and provide evidence, such as JMH, production profiling, async-profiler/JFR data, allocation rate, p99 latency, or CPU flame graphs. Do not claim JIT improvement from code shape alone.
- **[Mandatory]** Do not introduce global JVM flags, non-default compiler directives, or `@ForceInline`-style dependencies in business code unless the repository already owns a documented performance runtime policy.
- **[Mandatory]** Keep performance-specific code local to the hot path. Do not contaminate public APIs, domain models, or cold-path readability for speculative optimization.
- **[Mandatory]** Microbenchmarks must prevent dead-code elimination, unrealistic profile pollution, and loop-hoisting artifacts. Use returned results or JMH `Blackhole`, fork JVMs for competing variants, and avoid wrapping the measured operation in manual repetition loops unless `@OperationsPerInvocation` is intentionally modeling batch work.
- **[Recommended]** Prefer JMH microbenchmarks for isolated algorithm/object-allocation changes and end-to-end benchmarks for request-path changes. Warm up enough iterations before comparing results, and prefer production-like input distributions.
- **[Recommended]** When the optimization depends on JIT behavior, validate with diagnostic evidence such as `-XX:+UnlockDiagnosticVMOptions -XX:+PrintInlining`, `-XX:+LogCompilation`, JFR/JMC, async-profiler, allocation profiling, or Graal diagnostic dumps. Keep diagnostic flags out of normal production startup unless explicitly approved.

## 16.2 Profile-Guided JIT Stability

- **[Mandatory]** Hot code must keep runtime profiles stable after warmup. Do not route unrelated request shapes, many implementation classes, or incompatible modes through the same hot method only to reduce source duplication.
- **[Mandatory]** Do not benchmark or tune peak-performance code from cold-start measurements alone. HotSpot tiered compilation first gathers profiles, then produces more optimized code; benchmark and production evidence must distinguish warmup, steady state, and startup-sensitive paths.
- **[Mandatory]** Avoid loading new implementations, changing strategy maps, or toggling feature flags inside the tightest hot path after warmup unless the route is intentionally polymorphic and measured.
- **[Recommended]** Split stable fast paths from rare generic fallback paths when the split lets the common path stay monomorphic, branch-light, and inlinable.

## 16.3 Method Inlining

- **[Mandatory]** Hot-path helper methods must be small, focused, side-effect clear, and free of unnecessary exception edges so the JIT can inline them and unlock later optimizations.
- **[Mandatory]** Do not place logging, formatting, allocation-heavy diagnostics, reflection, dynamic class loading, or uncommon validation work inside methods expected to inline on hot paths. Move them to guards or cold branches.
- **[Mandatory]** Avoid deep chains of tiny wrappers in hot paths. One clear helper is acceptable; repeated pass-through layers can exceed inlining budgets and hide optimization opportunities.
- **[Recommended]** Keep polymorphic dispatch outside the tightest loop when possible. Resolve strategy, codec, parser, or handler once before entering the loop.

## 16.4 Escape Analysis And Scalar Replacement

- **[Mandatory]** Objects created only to carry temporary hot-path state must not escape through fields, arrays, collections, lambdas, method references, logging arguments, exceptions, or returned `Object`/interface types unless escape is required by the design.
- **[Mandatory]** Do not allocate short-lived wrapper objects, tuples, builders, optionals, streams, iterators, or boxed primitives inside tight loops when simple local variables can express the same state.
- **[Mandatory]** Avoid storing temporary objects into shared fields, `ThreadLocal`, static caches, or callback-captured variables only to pass data between nearby statements. This prevents scalar replacement and often increases memory pressure.
- **[Mandatory]** Do not apply object-identity operations to scalar-replacement candidates. `System.identityHashCode`, `wait`/`notify`, monitor use, identity-sensitive synchronization, and escaping object references can force materialization or prevent allocation elimination.
- **[Mandatory]** Do not pass temporary hot-path objects to native/JNI calls, reflective invocation, unknown callbacks, or asynchronous tasks when scalar replacement is expected. Treat those boundaries as escape boundaries unless profiling and compiler diagnostics prove otherwise.
- **[Recommended]** Prefer immutable local aggregates or primitive locals for calculation state. If a small object is used, keep its lifetime entirely within one method or one inlinable helper chain.

## 16.5 Lock Elimination And Lock Coarsening

- **[Mandatory]** Do not use `synchronized` on objects that are created only for local hot-path work. If the object cannot escape, synchronization is usually meaningless and should be removed instead of relying on lock elimination.
- **[Mandatory]** Do not synchronize inside tight loops unless shared mutable state truly requires it. Move synchronization outside the loop or redesign ownership so the hot loop works on thread-confined data.
- **[Mandatory]** Do not use synchronized collections, `StringBuffer`, or legacy synchronized APIs in hot paths when thread confinement or non-synchronized alternatives are valid.
- **[Recommended]** Keep lock scopes simple and visible. Complex callouts inside a lock make lock elimination/coarsening harder and increase contention risk.

## 16.6 Devirtualization And Call-Site Stability

- **[Mandatory]** Hot call sites must avoid unnecessary megamorphism. Do not feed many unrelated implementations through the same interface call inside a hot loop.
- **[Mandatory]** When a hot path always uses one implementation, keep the call site's receiver profile stable and resolve the implementation once before the hot loop. Do not add casts or API leaks merely to "force" devirtualization; prefer a concrete type only when it is already true at the boundary and improves clarity.
- **[Mandatory]** Do not repeatedly perform service lookup, map lookup, reflection, proxy dispatch, or interceptor-chain traversal per item in a tight loop.
- **[Mandatory]** Avoid reflection, dynamic proxies, expression engines, scripting, and generic interceptor chains in tight hot paths unless they are proven acceptable by profiling.
- **[Recommended]** Use `final`, package-private concrete classes, sealed hierarchies, or enum strategies where they accurately model a closed implementation set and match repository style.

## 16.7 Loop Optimization And Bounds-Check Elimination

- **[Mandatory]** Tight loops over arrays or lists must use stable loop bounds. Cache `length` or `size()` in a local variable when the source may be non-trivial or when the loop is performance-sensitive.
- **[Mandatory]** Do not mutate the iterated collection, array reference, or loop bound inside a tight loop unless the algorithm requires it and the invariant is documented.
- **[Mandatory]** Avoid hidden bounds checks from repeated nested indexing when a local reference or validated range can make the access pattern clear.
- **[Mandatory]** Prefer indexed loops over streams/foreach when loop overhead, allocation, or bounds-check elimination is material and measured.
- **[Recommended]** Validate ranges once before entering a hot loop, then keep loop indexes monotonic and simple so the JIT can prove safety.

## 16.8 Branch Prediction And Exception-Free Hot Paths

- **[Mandatory]** Hot paths must keep the common path stable and branch-light. Put rare validation failures, fallback logic, logging, and error construction behind guard clauses or cold helper methods.
- **[Mandatory]** Do not use exceptions for normal control flow. Exceptions on hot paths inhibit optimization, pollute profiles, and make branch behavior unstable.
- **[Mandatory]** Avoid mixing many data shapes, null conventions, or mode flags in one hot loop. Normalize inputs before the loop when practical.
- **[Recommended]** Order conditions by likelihood and cheapness when it improves the common path without reducing correctness or readability.

## 16.9 Allocation, Boxing, Data Shape, And Library Choices

- **[Mandatory]** Do not allocate per element in hot loops when allocation can be hoisted, reused safely, or represented by primitives/local variables.
- **[Mandatory]** Avoid accidental boxing/unboxing in hot paths, especially through generic collections, varargs, logging placeholders, streams, and `Map<String, Object>` style carriers.
- **[Mandatory]** Avoid pointer-heavy data structures such as linked lists, nested maps, and object-per-field records in CPU-bound tight loops when arrays, primitive arrays, compact value carriers, or pre-indexed lookup tables can represent the same data safely in the target JDK.
- **[Mandatory]** Avoid `Stream`, `Optional`, reflection-based mappers, regex compilation, JSON tree models, and general-purpose bean copying in hot loops unless profiling proves the overhead is acceptable.
- **[Mandatory]** Prefer well-known JDK APIs that HotSpot/Graal commonly optimize or intrinsify, such as `System.arraycopy`, `Arrays.fill`, `Math` operations, and normal string concatenation, before hand-written low-level code. Keep hand optimization only when profiling proves the JDK path is slower for the target JDK.
- **[Recommended]** Precompute reusable constants, lookup tables, parsed patterns, serializers, and codecs outside hot loops while respecting thread safety.

## 16.10 Memory Barriers, Volatile, And Atomic Operations

- **[Mandatory]** Do not put `volatile` reads/writes, `Atomic*` updates, `VarHandle` fences, or contended counters inside tight loops unless cross-thread visibility is part of the algorithm. These operations introduce memory-ordering constraints that can limit reordering and throughput.
- **[Mandatory]** Keep mutable hot-loop state thread-confined whenever possible. Publish results after the loop rather than publishing each iteration.
- **[Mandatory]** Avoid false-sharing-prone shared counters or adjacent hot fields in concurrent hot paths. Use sharding, batching, or existing padded primitives only when profiling shows contention or cache-line interference.
- **[Recommended]** Separate coordination code from numeric/data-processing loops so the compiler can optimize the pure computation path.

## 16.11 Review Checklist

- **[Mandatory]** For performance-sensitive Java review, explicitly check:
  - whether warmup, steady state, and profile pollution are measured separately;
  - whether the hot methods are small enough and simple enough to inline;
  - whether temporary objects escape or can be scalar-replaced;
  - whether object identity, native/JNI, reflection, callbacks, or async boundaries block escape analysis;
  - whether locks are necessary and whether lock scope is minimal;
  - whether hot call sites are monomorphic or at least not megamorphic;
  - whether loops have stable bounds and simple indexes;
  - whether common branches are stable and exceptions are off the hot path;
  - whether allocation, boxing, reflection, streams, logging, volatile/atomic operations, and memory fences are absent from tight loops unless measured and accepted;
  - whether data layout avoids unnecessary pointer chasing and allocation pressure;
  - whether claims about JIT behavior are backed by benchmark, profiler, or compiler diagnostic evidence.

## 16.12 Authoritative References

- **[For Reference]** [Oracle Java HotSpot VM Performance Enhancements](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/performance-enhancements-7.html) documents tiered compilation, compressed oops, escape analysis, scalar replacement, and lock elimination behavior.
- **[For Reference]** [Oracle Java command documentation](https://docs.oracle.com/javase/8/docs/technotes/tools/unix/java.html) lists HotSpot JIT options such as `-XX:+Inline`, `-XX:MaxInlineSize`, `-XX:+DoEscapeAnalysis`, `-XX:+PrintInlining`, `-XX:+LogCompilation`, and notes that advanced `-XX` options are not for casual use and may change.
- **[For Reference]** [OpenJDK JMH](https://openjdk.org/projects/code-tools/jmh/) is the preferred harness for JVM microbenchmarks. Its samples demonstrate dead-code elimination, loop-hoisting pitfalls, and the need for forked JVMs to avoid profile pollution.
- **[For Reference]** [GraalVM compiler documentation](https://www.graalvm.org/latest/reference-manual/java/compiler/) describes Graal as a dynamic compiler with aggressive inlining, polymorphic inlining, and partial escape analysis that can remove or sink allocations when objects do not escape a compilation unit.
