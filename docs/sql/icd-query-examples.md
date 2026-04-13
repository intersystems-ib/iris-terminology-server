# ICD SQL Examples

This document collects runnable SQL snippets for the `Terminology.ICD.*` tables in this repository.

These examples assume:

- you have loaded at least one ICD release
- `HierarchyEdge` has already been built
- `Version = 10`
- `CodeType = 'DIAGNOSIS'`

Before running the examples, find the loaded ICD releases:

```sql
SELECT
    ReleaseId,
    SystemUri,
    EffectiveDate,
    IsActive
FROM Terminology_Core.VersionRelease
WHERE SystemUri = 'http://id.who.int/icd/release/10'
ORDER BY IsActive DESC, EffectiveDate DESC, ReleaseId;
```

The examples below use:

- `ReleaseId = 'ICD-10-ES 2026'`
- `Version = 10`
- `CodeType = 'DIAGNOSIS'`
- `Code = 'A01.0'`
- `ParentCode = 'A01'`
- `FamilyCode = 'A00-A09'`

## 1. Get an ICD Code by Code

Returns the core row from `Terminology_ICD.Code`.

```sql
SELECT
    c.Code,
    c.Description,
    c.Version,
    c.CodeType,
    c.ParentCode,
    c.ChapterCode,
    c.FamilyCode,
    c.HierarchyLevel,
    c.NodeFinal,
    c.Active
FROM Terminology_ICD.Code c
WHERE c.ReleaseId = 'ICD-10-ES 2026'
  AND c.Version = 10
  AND c.CodeType = 'DIAGNOSIS'
  AND c.Code = 'A01.0';
```

## 2. Search Codes by Description

Uses the normalized description field directly.

```sql
SELECT TOP 25
    c.Code,
    c.Description,
    c.ParentCode,
    c.FamilyCode,
    c.ChapterCode,
    c.HierarchyLevel
FROM Terminology_ICD.Code c
WHERE c.ReleaseId = 'ICD-10-ES 2026'
  AND c.Version = 10
  AND c.CodeType = 'DIAGNOSIS'
  AND %SQLUPPER(c.DescriptionNorm) %STARTSWITH 'FIEBRE'
ORDER BY c.Code;
```

If you want to match the runtime search path more closely, use the iFind index:

```sql
SELECT TOP 25
    c.Code,
    c.Description,
    c.ParentCode,
    c.FamilyCode
FROM Terminology_ICD.Code c
WHERE c.ReleaseId = 'ICD-10-ES 2026'
  AND c.Version = 10
  AND c.CodeType = 'DIAGNOSIS'
  AND %ID %FIND search_index(IXDescriptionNormICDCode, 'fiebre')
ORDER BY c.Code;
```

## 3. Get Direct Children

Returns direct child codes for `A01`.

```sql
SELECT
    c.Code,
    c.Description,
    c.ParentCode,
    c.FamilyCode,
    c.HierarchyLevel
FROM Terminology_ICD.Code c
WHERE c.ReleaseId = 'ICD-10-ES 2026'
  AND c.Version = 10
  AND c.CodeType = 'DIAGNOSIS'
  AND c.ParentCode = 'A01'
ORDER BY c.Code;
```

## 4. Get Ancestors from `HierarchyEdge`

Returns ancestors of `A01.0`.

```sql
SELECT
    h.ParentCode AS Code,
    h.ChildCode AS DescendantCode,
    h.Depth,
    c.Description
FROM Terminology_ICD.HierarchyEdge h
INNER JOIN Terminology_ICD.Code c
    ON c.ReleaseId = h.ReleaseId
   AND c.Version = h.Version
   AND c.CodeType = h.CodeType
   AND c.Code = h.ParentCode
WHERE h.ReleaseId = 'ICD-10-ES 2026'
  AND h.Version = 10
  AND h.CodeType = 'DIAGNOSIS'
  AND h.HierarchyType = 'CODE'
  AND h.ChildCode = 'A01.0'
ORDER BY h.Depth, h.ParentCode;
```

## 5. Get Descendants from `HierarchyEdge`

Returns descendants of `A01`.

```sql
SELECT
    h.ParentCode AS AncestorCode,
    h.ChildCode AS Code,
    h.Depth,
    c.Description
FROM Terminology_ICD.HierarchyEdge h
INNER JOIN Terminology_ICD.Code c
    ON c.ReleaseId = h.ReleaseId
   AND c.Version = h.Version
   AND c.CodeType = h.CodeType
   AND c.Code = h.ChildCode
WHERE h.ReleaseId = 'ICD-10-ES 2026'
  AND h.Version = 10
  AND h.CodeType = 'DIAGNOSIS'
  AND h.HierarchyType = 'CODE'
  AND h.ParentCode = 'A01'
ORDER BY h.Depth, h.ChildCode;
```

## 6. Test Subsumption

Checks whether `A01` subsumes `A01.0`.

Expected result: `subsumes`.

```sql
SELECT
    CASE
        WHEN 'A01' = 'A01.0' THEN 'equivalent'
        WHEN EXISTS (
            SELECT 1
            FROM Terminology_ICD.HierarchyEdge h
            WHERE h.ReleaseId = 'ICD-10-ES 2026'
              AND h.Version = 10
              AND h.CodeType = 'DIAGNOSIS'
              AND h.HierarchyType = 'CODE'
              AND h.ParentCode = 'A01'
              AND h.ChildCode = 'A01.0'
        ) THEN 'subsumes'
        WHEN EXISTS (
            SELECT 1
            FROM Terminology_ICD.HierarchyEdge h
            WHERE h.ReleaseId = 'ICD-10-ES 2026'
              AND h.Version = 10
              AND h.CodeType = 'DIAGNOSIS'
              AND h.HierarchyType = 'CODE'
              AND h.ParentCode = 'A01.0'
              AND h.ChildCode = 'A01'
        ) THEN 'subsumed-by'
        ELSE 'not-subsumed'
    END AS Relationship;
```

## 7. List Families

Returns ICD families for the selected release.

```sql
SELECT TOP 50
    f.FamilyCode,
    f.Description,
    f.ChapterCode,
    f.RangeStart,
    f.RangeEnd
FROM Terminology_ICD.Family f
WHERE f.ReleaseId = 'ICD-10-ES 2026'
  AND f.Version = 10
  AND f.CodeType = 'DIAGNOSIS'
ORDER BY f.FamilyCode;
```

## 8. Expand a Family to its Member Codes

Returns all codes assigned to one family-backed FHIR `ValueSet`.

```sql
SELECT
    c.FamilyCode,
    c.Code,
    c.Description,
    c.ParentCode,
    c.HierarchyLevel
FROM Terminology_ICD.Code c
WHERE c.ReleaseId = 'ICD-10-ES 2026'
  AND c.Version = 10
  AND c.CodeType = 'DIAGNOSIS'
  AND c.FamilyCode = 'A00-A09'
ORDER BY c.Code;
```

## 9. List Chapters

Returns the loaded ICD chapters.

```sql
SELECT
    ch.ChapterCode,
    ch.Description,
    ch.RangeText
FROM Terminology_ICD.Chapter ch
WHERE ch.ReleaseId = 'ICD-10-ES 2026'
  AND ch.Version = 10
  AND ch.CodeType = 'DIAGNOSIS'
ORDER BY ch.ChapterCode;
```
