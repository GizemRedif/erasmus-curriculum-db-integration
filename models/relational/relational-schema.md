# Relational Schema

Pure reference for all 20 tables in the integrated database. For mapping decisions and normalization rationale, see [`logical-model.md`](../logical/logical-model.md).

**Notation:** Primary keys are **bold**. Composite PKs are marked **(PK)**. All FK behaviors are listed per column.

---

## Tables

| # | Table | Description |
|---|---|---|
| 1 | [UNIVERSITY](#1-university) | Top-level institution |
| 2 | [FACULTY](#2-faculty) | Faculty within a university |
| 3 | [DEPARTMENT](#3-department) | Department within a faculty |
| 4 | [FACULTY_MEMBER](#4-faculty_member) | All academic staff (instructors + assistants) |
| 5 | [MEMBER_EDUCATION](#5-member_education) | Education records of a faculty member |
| 6 | [ELECTIVE_GROUP](#6-elective_group) | Named group of elective courses |
| 7 | [COURSE](#7-course) | All courses across all universities |
| 8 | [SECTION](#8-section) | A course offering in a specific term |
| 9 | [TEACHES](#9-teaches) | Which instructor teaches which section |
| 10 | [CURRICULUM_ITEM](#10-curriculum_item) | A slot in a department's curriculum |
| 11 | [COMPULSORY_ITEM](#11-compulsory_item) | Curriculum slot for a compulsory course |
| 12 | [ELECTIVE_SEMESTER_ITEM](#12-elective_semester_item) | Curriculum slot for a semester elective group |
| 13 | [ELECTIVE_POOL_ITEM](#13-elective_pool_item) | Curriculum slot for a pool elective group |
| 14 | [MATCHES](#14-matches) | Cross-university course equivalencies |
| 15 | [PREREQUISITE](#15-prerequisite) | Prerequisite relationships between courses |
| 16 | [RESOURCES](#16-resources) | Course resources / references |
| 17 | [CATEGORY](#17-category) | Course category classifications |
| 18 | [LEARNING_OUTCOMES](#18-learning_outcomes) | Learning outcomes of a course |
| 19 | [SUBJECTS](#19-subjects) | Weekly subject plan of a course |
| 20 | [EVALUATION_CRITERIA](#20-evaluation_criteria) | Assessment breakdown of a course |

---

## 1. UNIVERSITY

```
UNIVERSITY(UniCode, Address, Name, Phone)
```

| Column | Type | Constraints |
|---|---|---|
| **UniCode** | VARCHAR(4) | PK |
| Address | VARCHAR(100) | NOT NULL |
| Name | VARCHAR(30) | NOT NULL, UNIQUE |
| Phone | VARCHAR(13) | UNIQUE; must match `^(0[0-9]{10}\|+90[0-9]{10})$` |

---

## 2. FACULTY

```
FACULTY(Fcode, Fname, UniCode, DeanId)
```

| Column | Type | Constraints |
|---|---|---|
| **Fcode** | VARCHAR(8) | PK |
| Fname | VARCHAR(30) | NOT NULL |
| UniCode | VARCHAR(4) | NOT NULL, FK → `UNIVERSITY(UniCode)` ON DELETE RESTRICT ON UPDATE CASCADE |
| DeanId | INT | NOT NULL, UNIQUE, DEFAULT 0, FK → `FACULTY_MEMBER(MemberId)` ON DELETE SET DEFAULT ON UPDATE CASCADE |

---

## 3. DEPARTMENT

```
DEPARTMENT(DeptCode, Name, Language, FacultyCode, ChairId)
```

| Column | Type | Constraints |
|---|---|---|
| **DeptCode** | VARCHAR(15) | PK |
| Name | VARCHAR(40) | NOT NULL |
| Language | VARCHAR(15) | NOT NULL |
| FacultyCode | VARCHAR(8) | NOT NULL, FK → `FACULTY(Fcode)` ON DELETE RESTRICT ON UPDATE CASCADE |
| ChairId | INT | NOT NULL, UNIQUE, DEFAULT 0, FK → `FACULTY_MEMBER(MemberId)` ON DELETE SET DEFAULT ON UPDATE CASCADE |

---

## 4. FACULTY_MEMBER

```
FACULTY_MEMBER(MemberId, Title, Fname, Lname, Mail, UniCode, MemberType, IsCoordinator)
```

| Column | Type | Constraints |
|---|---|---|
| **MemberId** | INT | PK |
| Title | VARCHAR(20) | |
| Fname | VARCHAR(20) | NOT NULL |
| Lname | VARCHAR(20) | NOT NULL |
| Mail | VARCHAR(30) | UNIQUE |
| UniCode | VARCHAR(4) | NOT NULL, FK → `UNIVERSITY(UniCode)` ON DELETE RESTRICT ON UPDATE RESTRICT |
| MemberType | CHAR(2) | NOT NULL; ∈ `{'IN', 'AS'}` |
| IsCoordinator | BOOLEAN | NOT NULL |

**Check constraints:**
```
MemberType IN ('IN', 'AS')
NOT (MemberType = 'AS' AND IsCoordinator = TRUE)
```

---

## 5. MEMBER_EDUCATION

```
MEMBER_EDUCATION(MemberId, DegreeType, University, Field)
```

| Column | Type | Constraints |
|---|---|---|
| **MemberId** **(PK)** | INT | FK → `FACULTY_MEMBER(MemberId)` ON DELETE CASCADE ON UPDATE CASCADE |
| **DegreeType** **(PK)** | VARCHAR(50) | |
| **University** **(PK)** | VARCHAR(100) | |
| **Field** **(PK)** | VARCHAR(150) | |

---

## 6. ELECTIVE_GROUP

```
ELECTIVE_GROUP(GroupCode, GroupName, GroupECTSTarget, GroupType)
```

| Column | Type | Constraints |
|---|---|---|
| **GroupCode** | VARCHAR(20) | PK |
| GroupName | VARCHAR(50) | NOT NULL |
| GroupECTSTarget | INT | Minimum ECTS to be completed from this group |
| GroupType | VARCHAR(13) | NOT NULL; ∈ `{'SEM_ELECT_GR', 'POOL_ELECT_GR'}` |

---

## 7. COURSE

```
COURSE(Code, Name, ECTS, Theoric, Application, Laboratory,
       Language, DeliveryMode, LabCode, DeptCode,
       CourseType, Content, ElectiveType, ElectiveGroup)
```

| Column | Type | Constraints |
|---|---|---|
| **Code** | VARCHAR(10) | PK |
| Name | VARCHAR(150) | NOT NULL |
| ECTS | INT | NOT NULL |
| Theoric | INT | |
| Application | INT | |
| Laboratory | INT | |
| Language | VARCHAR(15) | |
| DeliveryMode | VARCHAR(8) | DEFAULT `'On-Site'` |
| LabCode | VARCHAR(10) | FK → `COURSE(Code)` (self-ref, LAB_FOR) |
| DeptCode | VARCHAR(15) | FK → `DEPARTMENT(DeptCode)` ON DELETE RESTRICT ON UPDATE CASCADE |
| CourseType | VARCHAR(11) | NOT NULL; ∈ `{'Compulsory', 'Elective'}` |
| Content | TEXT | |
| ElectiveType | VARCHAR(20) | ∈ `{'Pool Elective', 'Semester Elective'}` |
| ElectiveGroup | VARCHAR(30) | FK → `ELECTIVE_GROUP(GroupCode)` ON DELETE CASCADE ON UPDATE CASCADE |

**Check constraints:**
```
Theoric + Application + Laboratory > 0

CourseType = 'Compulsory'
  → ElectiveType IS NULL AND ElectiveGroup IS NULL

CourseType = 'Elective' AND ElectiveType = 'Pool Elective'
  → ElectiveGroup IS NOT NULL

CourseType = 'Elective' AND ElectiveType = 'Semester Elective'
  → ElectiveGroup IS NOT NULL
```

---

## 8. SECTION

```
SECTION(SectionCode, SemPeriod, Year, CourseCode, CoordinatorId, AssistantId)
```

| Column | Type | Constraints |
|---|---|---|
| **SectionCode** | VARCHAR(15) | PK |
| SemPeriod | VARCHAR(6) | NOT NULL; ∈ `{'FALL', 'SPRING'}` |
| Year | SMALLINT | NOT NULL |
| CourseCode | VARCHAR(10) | FK → `COURSE(Code)` ON DELETE CASCADE ON UPDATE CASCADE |
| CoordinatorId | INT | FK → `FACULTY_MEMBER(MemberId)` ON DELETE SET NULL ON UPDATE CASCADE |
| AssistantId | INT | FK → `FACULTY_MEMBER(MemberId)` ON DELETE SET NULL ON UPDATE CASCADE |

**Unique constraint:** `(CourseCode, Year, SemPeriod)`

---

## 9. TEACHES

```
TEACHES(SectionCode, InstructorId)
```

| Column | Type | Constraints |
|---|---|---|
| **SectionCode** **(PK)** | VARCHAR(15) | FK → `SECTION(SectionCode)` ON DELETE CASCADE ON UPDATE CASCADE |
| **InstructorId** **(PK)** | INT | FK → `FACULTY_MEMBER(MemberId)` ON DELETE CASCADE ON UPDATE CASCADE |

---

## 10. CURRICULUM_ITEM

```
CURRICULUM_ITEM(ItemCode, DeptCode, Semester, CurriculumItemType, GroupOrCourseCode)
```

| Column | Type | Constraints |
|---|---|---|
| **ItemCode** **(PK)** | SERIAL | Auto-increment |
| **DeptCode** **(PK)** | VARCHAR(15) | FK → `DEPARTMENT(DeptCode)` ON DELETE RESTRICT ON UPDATE RESTRICT |
| Semester | SMALLINT | NOT NULL; ∈ `{1, 2, 3, 4, 5, 6, 7, 8}` |
| CurriculumItemType | VARCHAR(7) | NOT NULL; ∈ `{'COMPUL', 'EL-SEM', 'EL-POOL'}` |
| GroupOrCourseCode | VARCHAR(15) | NOT NULL |

> After insert, a trigger automatically populates the correct sub-table. Direct inserts into sub-tables are blocked.

---

## 11. COMPULSORY_ITEM

```
COMPULSORY_ITEM(DeptCode, ItemCode, CompulsoryCode)
```

| Column | Type | Constraints |
|---|---|---|
| **DeptCode** **(PK)** | VARCHAR(15) | FK → `CURRICULUM_ITEM(DeptCode, ItemCode)` ON DELETE RESTRICT ON UPDATE CASCADE |
| **ItemCode** **(PK)** | INT | |
| CompulsoryCode | VARCHAR(15) | UNIQUE, FK → `COURSE(Code)` ON DELETE RESTRICT ON UPDATE CASCADE |

---

## 12. ELECTIVE_SEMESTER_ITEM

```
ELECTIVE_SEMESTER_ITEM(DeptCode, ItemCode, ElectiveCode)
```

| Column | Type | Constraints |
|---|---|---|
| **DeptCode** **(PK)** | VARCHAR(15) | FK → `CURRICULUM_ITEM(DeptCode, ItemCode)` ON DELETE RESTRICT ON UPDATE CASCADE |
| **ItemCode** **(PK)** | INT | |
| ElectiveCode | VARCHAR(15) | UNIQUE, FK → `ELECTIVE_GROUP(GroupCode)` ON DELETE RESTRICT ON UPDATE CASCADE |

> `ElectiveCode` is UNIQUE — a semester elective group can occupy only one curriculum slot.

---

## 13. ELECTIVE_POOL_ITEM

```
ELECTIVE_POOL_ITEM(DeptCode, ItemCode, ElectiveCode)
```

| Column | Type | Constraints |
|---|---|---|
| **DeptCode** **(PK)** | VARCHAR(15) | FK → `CURRICULUM_ITEM(DeptCode, ItemCode)` ON DELETE RESTRICT ON UPDATE CASCADE |
| **ItemCode** **(PK)** | INT | |
| ElectiveCode | VARCHAR(15) | FK → `ELECTIVE_GROUP(GroupCode)` ON DELETE RESTRICT ON UPDATE CASCADE |

> `ElectiveCode` is **not** UNIQUE — the same pool group can appear across multiple semesters.

---

## 14. MATCHES

```
MATCHES(DeptCode, ItemCode, CourseCode)
```

| Column | Type | Constraints |
|---|---|---|
| **DeptCode** **(PK)** | VARCHAR(15) | FK → `CURRICULUM_ITEM(DeptCode, ItemCode)` ON DELETE CASCADE ON UPDATE CASCADE |
| **ItemCode** **(PK)** | INT | |
| **CourseCode** **(PK)** | VARCHAR(10) | FK → `COURSE(Code)` ON DELETE CASCADE ON UPDATE CASCADE |

> Cross-university equivalency. One curriculum slot can match courses from multiple universities.

---

## 15. PREREQUISITE

```
PREREQUISITE(CourseCode, PrerequisiteCode)
```

| Column | Type | Constraints |
|---|---|---|
| **CourseCode** **(PK)** | VARCHAR(10) | FK → `COURSE(Code)` ON DELETE CASCADE ON UPDATE CASCADE |
| **PrerequisiteCode** **(PK)** | VARCHAR(10) | FK → `COURSE(Code)` ON DELETE CASCADE ON UPDATE CASCADE |

> Self-referential M:N. Row `(A, B)` means "A requires B".

---

## 16. RESOURCES

```
RESOURCES(ResourceId, CourseCode, Resource)
```

| Column | Type | Constraints |
|---|---|---|
| **ResourceId** | SERIAL | PK |
| CourseCode | VARCHAR(10) | FK → `COURSE(Code)` ON DELETE CASCADE ON UPDATE CASCADE |
| Resource | VARCHAR(300) | |

---

## 17. CATEGORY

```
CATEGORY(CategoryId, CourseCode, Name, Percentage)
```

| Column | Type | Constraints |
|---|---|---|
| **CategoryId** | SERIAL | PK |
| CourseCode | VARCHAR(10) | FK → `COURSE(Code)` ON DELETE CASCADE ON UPDATE CASCADE |
| Name | VARCHAR(40) | |
| Percentage | INT | |

---

## 18. LEARNING_OUTCOMES

```
LEARNING_OUTCOMES(OutcomeId, CourseCode, Outcome)
```

| Column | Type | Constraints |
|---|---|---|
| **OutcomeId** | SERIAL | PK |
| CourseCode | VARCHAR(10) | FK → `COURSE(Code)` ON DELETE CASCADE ON UPDATE CASCADE |
| Outcome | TEXT | |

---

## 19. SUBJECTS

```
SUBJECTS(CourseCode, Week, Subject)
```

| Column | Type | Constraints |
|---|---|---|
| **CourseCode** **(PK)** | VARCHAR(10) | FK → `COURSE(Code)` ON DELETE CASCADE ON UPDATE CASCADE |
| **Week** **(PK)** | INT | |
| Subject | TEXT | |

---

## 20. EVALUATION_CRITERIA

```
EVALUATION_CRITERIA(EvalCriteriaId, CourseCode, SemesterStudies, Number, Contribution)
```

| Column | Type | Constraints |
|---|---|---|
| **EvalCriteriaId** | SERIAL | PK |
| CourseCode | VARCHAR(10) | FK → `COURSE(Code)` ON DELETE CASCADE ON UPDATE CASCADE |
| SemesterStudies | VARCHAR(50) | Assessment type (e.g. Midterm, Final, Quiz) |
| Number | INT | DEFAULT 1 |
| Contribution | INT | Percentage contribution to final grade |

---

## Foreign Key Reference Map

```
UNIVERSITY
  ├── FACULTY              .UniCode
  └── FACULTY_MEMBER       .UniCode

FACULTY
  ├── DEPARTMENT           .FacultyCode
  └── .DeanId           → FACULTY_MEMBER

DEPARTMENT
  ├── CURRICULUM_ITEM      .DeptCode
  ├── COURSE               .DeptCode
  └── .ChairId          → FACULTY_MEMBER

FACULTY_MEMBER
  ├── MEMBER_EDUCATION     .MemberId
  ├── SECTION              .CoordinatorId
  ├── SECTION              .AssistantId
  └── TEACHES              .InstructorId

ELECTIVE_GROUP
  ├── COURSE               .ElectiveGroup
  ├── ELECTIVE_POOL_ITEM   .ElectiveCode
  └── ELECTIVE_SEMESTER_ITEM .ElectiveCode

COURSE
  ├── COURSE               .LabCode          (self)
  ├── SECTION              .CourseCode
  ├── COMPULSORY_ITEM      .CompulsoryCode
  ├── PREREQUISITE         .CourseCode       (self)
  ├── PREREQUISITE         .PrerequisiteCode (self)
  ├── MATCHES              .CourseCode
  ├── RESOURCES            .CourseCode
  ├── CATEGORY             .CourseCode
  ├── LEARNING_OUTCOMES    .CourseCode
  ├── SUBJECTS             .CourseCode
  └── EVALUATION_CRITERIA  .CourseCode

SECTION
  └── TEACHES              .SectionCode

CURRICULUM_ITEM
  ├── COMPULSORY_ITEM      .(DeptCode, ItemCode)
  ├── ELECTIVE_SEMESTER_ITEM .(DeptCode, ItemCode)
  ├── ELECTIVE_POOL_ITEM   .(DeptCode, ItemCode)
  └── MATCHES              .(DeptCode, ItemCode)
```
