# Logical Model

This document describes how the Integrated EER diagram was transformed into a relational schema. It covers the mapping methodology, specialization strategies, self-referential relationships, and normalization analysis.

For the final table definitions (columns, types, constraints), see [`relational-schema.md`](../relational/relational-schema.md).

---

## Table of Contents

1. [Mapping Algorithm](#1-mapping-algorithm)
2. [Mapping Iterations](#2-mapping-iterations)
3. [Specialization Strategies](#3-specialization-strategies)
4. [Self-Referential Relationships](#4-self-referential-relationships)
5. [Normalization Analysis](#5-normalization-analysis)
6. [Design Decisions Summary](#6-design-decisions-summary)

---

## 1. Mapping Algorithm

#### ER-to-Relational Mapping Algorithm

- Step 1: Mapping of Regular Entity Types
- Step 2: Mapping of Weak Entity Types
- Step 3: Mapping of Binary 1:1 Relation Types
- Step 4: Mapping of Binary 1:N Relationship Types
- Step 5: Mapping of Binary M:N Relationship Types
- Step 6: Mapping of Multi-valued attributes
- Step 7: Mapping of N-ary Relationship Types

#### Mapping EER Model Constructs to Relations
- Step 8: Options for Mapping Specialization or Generalization (8A, 8B, 8C, 8D)
- Step 9: Mapping of Union Types (Categories)

> Check each iteration in turn; skip any step if it's not present.

---

## 2. Mapping Iterations

### Iteration 1

**Step 1:**
```
UNIVERSITY(UniCode, Address, Name, Phone)  
FACULTY (Fcode, Fname)  
DEPARTMENT(DeptCode, Name, Language) 
SECTION(SectionCode, SemPeriod, Year) 
```

**Step 2:**
```
CURRICULUM_ITEM(DEPARTMENT.DeptCode, ItemCode,Semester) // via HAS
```
**Step 3:**
```
There isn’t any 1:1 relation in this iteration.
```

**Step 4:**
```
FACULTY(..., UNIVERSITY.UniCode)  // via HAS
DEPARTMENT(..., FACULTY.Fcode) // via ADMINS
```

**Step 5:**
```
There isn’t any M:N relationship for this iteration. 
```

**Step 6:**
```
There isn’t any multivalued attribute for this iteration. 
```

**Step 7:**
```
There isn’t any N-ary relationship. 
```

**Step 8:**
```
8c) COURSE(Code, Name, ECTS, T+A+L.Theoric, T+A+L.Application, T+A+L.Labratory, 
Content, Language, DeliveryMode,CourseType) 
8c) FACULTY_MEMBER(MemberId, Title, Name.Fname, Name.Lname, Mail, 
MemberType) 
8a) 
ELECTIVE_POOL_ITEM(DEPARTMETN.DeptCode, ItemCode) // via 
CURRICULUM_ITEM 
ELECTIVE_SEMESTER _ITEM(DEPARTMETN.DeptCode.CurriculumCode, ItemCode) // 
via CURRICULUM_ITEM 
COMPULSORY_ITEM(DEPARTMETN.DeptCode, ItemCode) // via 
CURRICULUM_ITEM 
8c) ELECTIVE_GROUP(GroupCode, GroupName, GroupECTSTarget,GroupType)
```

**Step 9:**
```
There isn’t any union type. 
```

### Iteration 2

**Step 1:**
```
 There isn’t any regular entity. 
```

**Step 2:**
```
There isn’t any weak entity.
```
**Step 3:**
```
FACULTY(..., FACULTY_MEMBER.MemberId) // via DEAN  
DEPARTMENT(..., FACULTY_MEMBER.MemberId) // via CHAIR  
COURSE(..., COURSE.LabId) // via LAB_FOR  
COMPULSORY_ITEM(...,COURSE.CourseCode) // via OFFERED_IN  
ELECTIVE_SEMESTER_ITEM(..., ELECTIVE_GROUP.GroupCode)// via OFFERED_IN 
```

**Step 4:**
```
FACULTY_MEMBER(..., UNIVERSITY.UniCode) // via EMPLOYS  
SECTION(..., COURSE.CourseCode) // via INSTANCE_OF  
SECTION(..., FACULTY_MEMBER.MemberId) // via ASSIST
COURSE(..., DEPARTMENT.DeptCode) // via OFFERS  
ELECTIVE_POOL_ITEM(...,ELECTIVE_GROUP.Code) // via OFFERED_IN
```

**Step 5:**
```
PREREQUISITE(COURSE.CourseCode, COURSE.PrerequisiteCode) // via PREREQUISITE  
TEACHES(SECTION.SectionCode,FACULTY_MEMBER.InstructorId) // via TEACHES  
MATCHES(DEPARTMENT.DeptCode,CURRICULUM_ITEM.ItemCode,COURSE.Code)//
via MATCHES 
```

**Step 6:**
```
MEMBER_EDUCATION(FACULTY_MEMBER.MemberId, DegreeType, University, 
Field) // via FACULTY_MEMBER 
RESOURCES(COURSE.CourseCode, Resource) // via COURSE 
EVALUATION_CRITERIA(COURSE.CourseCode, SemesterStudies, Number, 
ContributionDuringYear, EndOfYearContributon) // via COURSE 
SUBJECTS(COURSE.CourseCode, Week, Subject) // via COURSE 
LEARNING_OUTCOMES(COURSE.CourseCode, Outcome) // via COURSE 
CATEGORY(COURSE.CourseCode, Name, Percentage) // via COURSE
```

**Step 7:**
```
There isn’t any N-ary relationship. 
```

**Step 8:**
```
8c) COURSE(...,ElectiveType) 
8c) FACULTY_MEMBER(..., IsCoordinator) 
```

**Step 9:**
```
There isn’t any union type.
```


### Iteration 3

**Step 1:**
```
 There isn’t any regular entity. 
```

**Step 2:**
```
There isn’t any weak entity.
```

**Step 3:**
```
There isn’t any 1:1 relationship. 
```

**Step 4:**
```
COURSE(..., ELECTIVE_GROUP.Code) // via CONTAINS 
SECTION(..., FACULTY_MEMBER.MemberId) // via COORDINATES
```

> Mapping is completed.




## 3. Specialization Strategies

### 3.1 FACULTY_MEMBER → INSTRUCTOR / ASSISTANT

**Strategy: Single table + `MemberType` discriminator**

| Option | Trade-off |
|---|---|
| Single table + type attribute | Simple queries across all staff; minor NULL columns |
| Separate INSTRUCTOR / ASSISTANT tables | Cleaner per-subtype constraints; requires UNION for cross-type queries |

**Rationale:** Both subtypes share all attributes (`MemberId`, `Title`, `Fname`, `Lname`, `Mail`, `UniCode`). The only behavioral difference — whether a member can be a coordinator — is enforced with a check constraint. A separate table would add join overhead with no structural benefit.

```
MemberType = 'IN'  →  Instructor  (can teach, coordinate, serve as Dean or Chair)
MemberType = 'AS'  →  Assistant   (can assist sections; IsCoordinator must be FALSE)
```

---

### 3.2 COURSE → COMPULSORY / ELECTIVE

**Strategy: Single table + `CourseType` + `ElectiveType` attributes**

The two subtypes share all workload and content attributes. During the integration conforming stage, `ECTS` and `T+A+L` were moved from subtype-level entities to `COURSE` directly — leaving no subtype-exclusive attributes that would justify separate tables.

A compound check constraint enforces consistency between the attributes:

```
CourseType = 'Compulsory' → ElectiveType IS NULL  AND ElectiveGroup IS NULL
CourseType = 'Elective'   → ElectiveType IS NOT NULL AND ElectiveGroup IS NOT NULL
```

---

### 3.3 CURRICULUM_ITEM → COMPULSORY_ITEM / ELECTIVE_SEMESTER_ITEM / ELECTIVE_POOL_ITEM

**Strategy: Supertype table + three separate sub-tables**

| Sub-type | Table | References |
|---|---|---|
| COMPULSORY_ITEM | `COMPULSORY_ITEM` | A specific `COURSE` |
| ELECTIVE_SEMESTER_ITEM | `ELECTIVE_SEMESTER_ITEM` | An `ELECTIVE_GROUP` of type `SEM_ELECT_GR` |
| ELECTIVE_POOL_ITEM | `ELECTIVE_POOL_ITEM` | An `ELECTIVE_GROUP` of type `POOL_ELECT_GR` |

**Rationale:** Each sub-type references a fundamentally different entity (`COURSE` vs `ELECTIVE_GROUP`). A single nullable FK column on the supertype would be ambiguous and unenforceable. Separate sub-tables allow each sub-type to declare its own precise FK constraint.

An after-insert trigger on `CURRICULUM_ITEM` automatically routes each new row to the correct sub-table. Direct inserts into sub-tables are blocked by a separate trigger.

```
INSERT into CURRICULUM_ITEM
        │
        ├─ CurriculumItemType = 'COMPUL'   →  COMPULSORY_ITEM
        ├─ CurriculumItemType = 'EL-SEM'   →  ELECTIVE_SEMESTER_ITEM
        └─ CurriculumItemType = 'EL-POOL'  →  ELECTIVE_POOL_ITEM
```

---

### 3.4 ELECTIVE_GROUP → SEMESTER_ELECTIVE_GROUP / POOL_ELECTIVE_GROUP

**Strategy: Single table + `GroupType` discriminator**

Both sub-types share the same attributes (`GroupCode`, `GroupName`, `GroupECTSTarget`). The behavioral difference — how students select courses and how the group appears in the curriculum — is fully captured by `GroupType` and enforced via check constraints and a trigger on `COURSE`.

---

## 4. Self-Referential Relationships

### 4.1 PREREQUISITE

The PREREQUISITE relationship is a **M:N self-relationship** on `COURSE`. A course can have multiple prerequisites, and a course can be a prerequisite for multiple other courses.

**Mapping:** New junction table with two FKs both referencing `COURSE(Code)`.

```
PREREQUISITE(CourseCode, PrerequisiteCode)
PK: (CourseCode, PrerequisiteCode)
FK: CourseCode       → COURSE(Code)  ON DELETE CASCADE
FK: PrerequisiteCode → COURSE(Code)  ON DELETE CASCADE
```

The relationship is directed: row `(A, B)` means "A requires B as a prerequisite", not the reverse.

> **Note:** Çukurova University has no prerequisite chains between courses. The PREREQUISITE table was introduced during the integration conforming stage as a schema extension to accommodate Yaşar and Hacettepe models.

---

### 4.2 LAB_FOR

The LAB_FOR relationship is a **1:1 self-relationship** on `COURSE`. A course can have at most one dedicated lab course, and a lab course belongs to at most one main course.

**Mapping:** FK column `LabCode` on `COURSE` pointing back to `COURSE(Code)`.

```
COURSE.LabCode → COURSE(Code)   (nullable; NULL when no separate lab exists)
```

The main course holds the FK and points to its lab. The lab course itself has `LabCode = NULL`.

> **Note:** Yaşar University integrates lab hours within the main course (`T+A+L`), so `LabCode` is NULL for Yaşar courses. Hacettepe and Çukurova model lab components as separate course entries with distinct codes.

---

## 5. Normalization Analysis

### 5.1 First Normal Form (1NF)

All multivalued and composite attributes from the EER were decomposed before mapping:

| EER Construct | Resolution |
|---|---|
| `MemberEducation` (multivalued) | → `MEMBER_EDUCATION` table |
| `Resources` (multivalued) | → `RESOURCES` table |
| `LearningOutcomes` (multivalued) | → `LEARNING_OUTCOMES` table |
| `Subjects` (multivalued + composite) | → `SUBJECTS` table |
| `EvaluationCriteria` (multivalued + composite) | → `EVALUATION_CRITERIA` table |
| `Category` (multivalued + composite) | → `CATEGORY` table |
| `Name` (composite: FName + LName) | → Two atomic columns on `FACULTY_MEMBER` |
| `T+A+L` (composite) | → Three atomic columns: `Theoric`, `Application`, `Laboratory` |

All resulting tables have atomic attributes and unique row identifiers. **1NF satisfied.**

---

### 5.2 Second Normal Form (2NF)

2NF requires that every non-key attribute be fully functionally dependent on the entire primary key. Only relevant for tables with composite PKs.

**`CURRICULUM_ITEM` — PK: `(DeptCode, ItemCode)`**

| Attribute | Fully depends on full PK? |
|---|---|
| `Semester` | ✅ A slot's semester is specific to both the department and the item number |
| `CurriculumItemType` | ✅ |
| `GroupOrCourseCode` | ✅ |

No partial dependencies. **2NF satisfied.**

**`SUBJECTS` — PK: `(CourseCode, Week)`**

`Subject` (the weekly topic) depends on both the course and the specific week — not on either alone. **2NF satisfied.**

**`TEACHES`, `PREREQUISITE`, `MATCHES`** contain only PK columns. **2NF trivially satisfied.**

---

### 5.3 Third Normal Form (3NF)

3NF requires no transitive dependencies between non-key attributes.

**`COURSE` — potential concern: `ElectiveGroup` and `ElectiveType`**

`ElectiveGroup` is a FK to `ELECTIVE_GROUP(GroupCode)`, which carries its own `GroupType`. `ElectiveType` on `COURSE` appears to overlap with `GroupType`. However:

- `ElectiveType` describes the **course's role** in the curriculum (how a student selects it).
- `GroupType` describes the **group's structure** (how the group is defined).

These are semantically distinct and neither is derived from the other — the alignment between them is enforced by a trigger, not by a functional dependency. **No transitive dependency. 3NF satisfied.**

**`FACULTY_MEMBER` — `MemberType` and `IsCoordinator`**

`IsCoordinator` depends solely on `MemberId`. The check constraint `MemberType = 'AS' → IsCoordinator = FALSE` is a restriction, not a functional dependency between non-key attributes. **3NF satisfied.**

**All other tables** have at most one non-key attribute or all non-key attributes depend directly on the PK. **3NF satisfied throughout.**

---

## 6. Design Decisions Summary

| Decision | Alternative Considered | Reason |
|---|---|---|
| `FACULTY_MEMBER` single table + `MemberType` | Separate INSTRUCTOR / ASSISTANT tables | Subtypes share all attributes; a discriminator column with a check constraint is sufficient |
| `COURSE` single table + `CourseType` | Separate COMPULSORY / ELECTIVE tables | No subtype-exclusive attributes remain after moving T+A+L to COURSE during integration |
| `CURRICULUM_ITEM` supertype + 3 sub-tables | Single table with nullable FKs | Each sub-type references a different entity; separate tables allow precise FK enforcement |
| T+A+L on `COURSE` | T+A on COMPULSORY, group-level on ELECTIVE_GROUP | Avoids redundancy; workload is a property of the course itself, not its curriculum role |
| `MATCHES` as a separate relation | Embedding equivalency in COURSE | Preserves each course's original identity; enables M:N cross-university mapping without coupling schemas |
| `DeanId` / `ChairId` DEFAULT 0 | Nullable FKs | Avoids NOT NULL violations during data population while maintaining referential integrity |
| Trigger-based sub-table routing | Application-level insert logic | Enforces architectural consistency at the database level; prevents bypassing via direct inserts |
