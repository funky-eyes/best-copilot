# MySQL Rules

## Table Design

### Mandatory

1. Table and field names must use lowercase letters and underscores. Avoid reserved words.
2. Table names should express business meaning and should not use vague names.
3. Every table should have a primary key, preferably a numeric or string business-safe identifier according to repository convention.
4. Fields that represent booleans should use clear positive names.
5. Choose field types precisely. Do not use overly broad types when a narrower type is enough.
6. Monetary values should not use floating-point types.
7. Timestamps should follow the repository convention and preserve timezone semantics.
8. Character set and collation must be consistent within the application.

### Recommended

9. Tables should contain creation and update metadata such as `gmt_create` and `gmt_modified` if the repository convention uses them.
10. Use comments for tables and columns when the database is a shared integration surface.

## Index Rules

### Mandatory

1. Unique business constraints must be enforced with unique indexes.
2. Add indexes for high-frequency query conditions and join keys.
3. Do not create redundant indexes whose left-prefix columns are already covered.
4. Do not index very low-cardinality columns alone unless combined with selective columns.
5. Long string indexes should use prefix indexes only when selectivity has been evaluated.

### Recommended

6. Composite indexes should place high-selectivity and commonly filtered columns first, while respecting query patterns.
7. Review execution plans for slow or high-traffic SQL.
8. Avoid excessive indexes because they slow writes and increase storage cost.

## SQL Rules

### Mandatory

1. Do not use `SELECT *`; select only required columns.
2. Do not concatenate user input into SQL. Use parameters or a metadata-constrained builder.
3. Avoid functions or calculations on indexed columns in `WHERE` clauses when they prevent index usage.
4. Avoid implicit type conversions in predicates.
5. Pagination for large datasets must not rely on deep `OFFSET` scans. Prefer keyset/seek pagination or repository cache/index paths.
6. Do not perform unbounded full-table updates or deletes. Include clear conditions and verify affected rows.
7. Do not issue SQL in loops when batching or set-based operations are possible.

### Recommended

8. Keep SQL readable and aligned with repository formatter conventions.
9. Use batch inserts/updates for bulk operations.
10. Keep transaction scope as small as possible.

## ORM And MyBatis Rules

### Mandatory

1. Mapper XML and Java mapper interfaces must stay synchronized.
2. Dynamic SQL must validate optional conditions carefully and must not generate unsafe or malformed statements.
3. Result mappings must be explicit when column names do not match property names.
4. Do not hide N+1 queries behind service loops.
5. Repository methods should express business intent instead of exposing arbitrary SQL assembly.

### Recommended

6. Prefer typed query objects when there are more than two conditions.
7. Avoid using raw `Map` for complex query parameters.
8. Keep SQL fragments reusable only when reuse is real and does not obscure the query.

## Spring Transaction Rules

### Mandatory

1. Transaction annotations should be placed on service-layer methods that define a business transaction boundary.
2. Rollback rules must match the exception semantics. Checked exceptions need explicit rollback configuration when required.
3. Do not put long-running network calls inside database transactions unless the business explicitly requires it.
4. Avoid self-invocation traps where `@Transactional` is bypassed.
5. Do not catch and swallow exceptions inside transactional methods in a way that prevents rollback.

### Recommended

6. Keep transaction isolation explicit when the default is not sufficient.
7. Write tests or integration checks for important rollback behavior.
8. For create paths, avoid wasteful insert-then-select flows when the lower layer can return the created object or when a precise existence check is enough.
