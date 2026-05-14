# Middleware And Framework Specification

## Chapter 8: Dubbo Framework Rules

### 8.1 Required JVM Options For JDK 17+

When using JDK 17 or later, the preboot script or startup command must include the required module-open options for the repository's Dubbo and serialization stack. Verify the exact options against the target application's runtime dependencies.

### 8.2 Serialization

- **[Mandatory]** Use Hessian2 serialization consistently. Do not use Java native serialization or JSON serialization for Dubbo interfaces unless the repository has an explicit compatibility contract.
- **[Mandatory]** Entity classes used as Dubbo request or response types must implement `Serializable` and declare `serialVersionUID` explicitly.

### 8.3 Production Constraints

- **[Mandatory]** Callers must catch and log all remote invocation exceptions, regardless of whether the interface declares `throws`.

```java
try {
    remoteService.invoke(request);
} catch (Exception e) {
    LOGGER.error("Dubbo invocation failed, requestId={}", requestId, e);
}
```

- **[Mandatory]** Interface names must follow standard Java interface naming and include concrete business meaning. Generic names such as `DataService` and `CommonService` are forbidden.
- **[Mandatory]** Do not define the same package name and interface name in two different applications.
- **[Mandatory]** Service version format must be numeric semantic versioning, such as `1.0.0`.
- **[Mandatory]** Dubbo service port should use the approved standard port, commonly `20880`, unless the target repository documents another value.

## Chapter 9: Kafka Framework Rules

### 9.1 Client

- **[Mandatory]** Sending and consuming messages should use the company-approved Kafka module when the repository provides one. Do not introduce raw Kafka clients directly without approval.
- **[Mandatory]** Use the company-approved Kafka client version for the target repository. Do not introduce an arbitrary version.

### 9.2 Producer Configuration

- **[Mandatory]** Producer configuration must explicitly define reliability, retry, timeout, and serialization behavior according to the repository's messaging contract.
- **[Mandatory]** Message keys and partition strategies must match ordering and load-distribution requirements.

### 9.3 Topic And Group Naming

- **[Mandatory]** Topic names should contain only lowercase letters, digits, underscores, and hyphens.
- **[Mandatory]** Consumer group names must identify the application and business purpose.
- **[Mandatory]** Topic ownership and lifecycle must be documented before production use.

### 9.4 Capacity Assessment

Before using Kafka, assess and record:

- expected QPS,
- message size,
- retention period,
- partition count,
- consumer concurrency,
- retry and dead-letter behavior,
- monitoring and alerting.

## Chapter 10: ZooKeeper / Curator Rules

- **[Mandatory]** Do not directly use the raw ZooKeeper client. Use Apache Curator or the approved repository wrapper.
- **[Mandatory]** Share one `CuratorFramework` instance inside an application. Do not create duplicate clients and waste connections.
- **[Mandatory]** Close unused clients and watchers promptly to avoid connection leaks.
- **[Mandatory]** Do not perform high-frequency writes. Treat QPS above 10 as high frequency.
- **[Mandatory]** Keep single-write data small, preferably below 4 KB, and keep total application data limited.
- **[Mandatory]** Do not create ZooKeeper paths without registration or approval.
- **[Mandatory]** A single path should not have more than 1024 children.
- **[Mandatory]** Do not use ZooKeeper as a database. It is not suitable for large-volume storage or high-frequency reads/writes.

## Chapter 11: InfluxDB / Metrics Rules

- **[Mandatory]** Prefer the company-approved metrics module. Do not concatenate raw data and write directly to InfluxDB unless the repository explicitly owns that integration.
- **[Mandatory]** Metric tag values must be enumerable, such as status code, environment, or service name. Never use user IDs, trace IDs, sequence IDs, or other high-cardinality values as tags, because this can cause cardinality explosion and cluster instability.

## Chapter 12: APEXDB Rules

- **[Mandatory]** Java applications should use the approved APEXDB/TDKV client.
- **[Mandatory]** Communicate with infrastructure and complete the required approval process before using APEXDB.
- **[Mandatory]** Keep the P999 size for a single key below 64 KB; 4 KB or less is preferred.
- **[Mandatory]** Do not repeatedly write the same key at high frequency.
- **[Mandatory]** Do not lend or share an allocated cluster with other business teams.

## Chapter 13: HBase Rules

- **[Mandatory]** Use the company-approved HBase client and version for the repository. Do not introduce unsupported legacy versions.
- **[Mandatory]** RowKey values must be well distributed to avoid hot spots. A hash prefix is recommended.
- **[Mandatory]** All tables must set TTL.
- **[Mandatory]** If total data volume is below 100 GB, MySQL is usually preferred over HBase.
- **[Recommended]** Use batch writes such as `BufferedMutator` when write concurrency is high.
- **[Recommended]** Do not query too many rows in a single batch Get; keeping a batch below 200 rows is recommended.
