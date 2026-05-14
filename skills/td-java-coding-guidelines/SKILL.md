---
name: td-java-coding-guidelines
description: Tongdun Java development guideline assistant. Use when writing Java code, reviewing Java code, discussing Java coding standards or best practices, creating Java project structure, writing SQL/MyBatis code, or handling Java exceptions and logging. Based on Alibaba Java Coding Guidelines, it provides guidance for naming, OOP, collections, concurrency, exceptions, logging, MySQL, project layering, and security.
---

# TONGDUN Java Development Guidelines

This skill provides Java coding guidance based on [Alibaba Java Coding Guidelines](https://alibaba.github.io/Alibaba-Java-Coding-Guidelines/).

Guideline severity has three levels:

- **[Mandatory]**: must be followed.
- **[Recommended]**: should be followed when practical.
- **[For Reference]**: useful guidance and background.

## 1. Programming Specification

Covers naming style, constants, code formatting, OOP rules, collections, concurrency, control statements, and comments.

**Detailed rules:** read [references/programming-specification.md](references/programming-specification.md).

## 2. Exceptions And Logs

Covers exception handling and logging rules.

**Detailed rules:** read [references/exception-and-logs.md](references/exception-and-logs.md).

## 3. MySQL Rules

Covers table design, indexes, SQL, and ORM mapping rules.

**Detailed rules:** read [references/mysql-rules.md](references/mysql-rules.md).

## 4. Project Specification

Covers application layering, second-party library dependencies, and server configuration.

**Detailed rules:** read [references/project-specification.md](references/project-specification.md).

## 5. Security Specification

Covers permission checks, data masking, SQL injection prevention, CSRF protection, and related security rules.

**Detailed rules:** read [references/security-specification.md](references/security-specification.md).

## Middleware And Framework Specification

Covers dedicated rules for Dubbo, Kafka, ZooKeeper/Curator, InfluxDB, APEXDB, and HBase.

**Detailed rules:** read [references/middleware-framework-specification.md](references/middleware-framework-specification.md).

### Spring Database Transaction Rules

Database transaction rules are included in the MySQL rules.

**Detailed rules:** read [references/mysql-rules.md](references/mysql-rules.md).

### JDK 21 Virtual Thread Rules

Covers pinning prevention, third-party library compatibility checks, thread-pool configuration, and virtual-thread-specific constraints.

**Detailed rules:** read [references/virtual-thread-specification.md](references/virtual-thread-specification.md).

## How To Use

1. **When writing or reviewing code:** read `references/programming-specification.md`.
2. **When handling exceptions, logs, or comments:** read `references/exception-and-logs.md`.
3. **When database access, SQL, MyBatis, or Spring transaction rules are involved:** read `references/mysql-rules.md`.
4. **When designing project architecture:** read `references/project-specification.md`.
5. **When security-related functionality is involved:** read `references/security-specification.md`.
6. **When Dubbo, Kafka, ZooKeeper, HBase, APEXDB, or similar middleware is involved:** read `references/middleware-framework-specification.md`.
7. **When transactions or JDK 21 virtual threads are involved:** read `references/mysql-rules.md` and `references/virtual-thread-specification.md`.
