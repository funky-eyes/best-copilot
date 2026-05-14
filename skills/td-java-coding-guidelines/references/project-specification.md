# Project Specification

## Application Layers

### Recommended Layering Structure

| Layer | Description |
| --- | --- |
| **Open Interface** | Wraps services as RPC/HTTP interfaces and handles gateway security and traffic control. |
| **Terminal Display** | Templates, rendering, and page display. |
| **Web Layer** | Request forwarding, parameter checking, and simple response assembly. |
| **Service Layer** | Business logic orchestration and transaction control. |
| **Manager Layer** | Common business processing, cache interaction, and calls to external services or DAO. |
| **DAO Layer** | Data access to MySQL, Oracle, HBase, and similar stores. |

### Exception Handling By Layer

- **DAO layer**: `catch (Exception e)` and throw `DAOException(e)`; do not log here.
- **Service/Manager layer**: log errors and include useful parameters for troubleshooting.
- **Web layer**: convert business exceptions into user-facing responses.
- **Open interface layer**: convert exceptions into the interface contract, such as result codes or RPC errors.

### Domain Models

| Model | Description |
| --- | --- |
| **DO** | Data Object. Mirrors database table structure and is passed upward by the DAO layer. |
| **DTO** | Data Transfer Object. Transfers data across services or remote interfaces. |
| **BO** | Business Object. Represents internal business semantics. |
| **VO** | View Object. Represents data returned to pages or external clients. |
| **Query** | Query object for upper-layer query requests. If there are more than two query conditions, do not use `Map`. |

## Library Specification

### Mandatory

1. Second-party library APIs must avoid returning internal implementation classes.
2. Initial versions must start at `1.0.0`.
3. Production applications must not depend on `SNAPSHOT` versions, except explicitly approved security packages.
4. Library upgrades must be compatible or clearly documented as incompatible.
5. Second-party libraries may define enum types, but interface return values must not expose enums or POJOs containing enums.
6. Dependencies should be minimal and necessary.
7. Child projects with the same `groupId` and `artifactId` must use the same version.

### Recommended

1. Keep dependencies explicit and avoid hidden transitive reliance.
2. Prefer semantic versioning for library releases.
3. Record incompatible changes in release notes or migration docs.

## Server Specification

### Recommended

1. **Reduce `time_wait` on high-concurrency servers**: the default is often 240 seconds. High-concurrency scenarios should reduce it, for example `net.ipv4.tcp_fin_timeout = 30`.
2. **Increase file descriptor limits**: Linux defaults are often 1024, which can easily trigger "too many open files" under high concurrency.
