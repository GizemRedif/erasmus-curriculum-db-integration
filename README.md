# Erasmus Curriculum Database Integration

A relational database system that unifies the academic curricula of three Turkish universities under the Erasmus+ student exchange framework — enabling cross-university course equivalency lookup, ECTS alignment, and curriculum comparison.

> Ege University — Faculty of Engineering, Computer Engineering Department  
> Introduction to Databases | 2025–2026 Fall Semester  

---

## Overview

This project models and integrates the curriculum structures of three Computer/Informatics-related departments:

| University | Department | 
|---|---|
| Yaşar University | Software Engineering (English) | 
| Hacettepe University | Artificial Intelligence Engineering (English) |
| Çukurova University | Computer Engineering (English) |

Each department's curriculum was analyzed separately, modeled as an EER diagram, and then integrated into a single global schema using the **Binary-Ladder Strategy** (Batini et al., 1986). The final schema is implemented in **PostgreSQL**.

---

## Repository Structure

```
erasmus-curriculum-db-integration/
│
├── README.md
│
├── docs/
│   └── term-project-description.pdf          # Project description
│
├── models/
│   ├── conceptual/
│   │   ├── Yaşar University EER.png             # Yaşar University EER diagram
│   │   ├── Hacettepe University EER.png         # Hacettepe University EER diagram
│   │   ├── Çukurova University EER.png          # Çukurova University EER diagram
│   │   ├── Partial Integrated EER.png           # Partial Integrated Schema (Stage 1)
│   │   └── Integrated EER.png                   # Final Global Integrated EER
│   ├── logical/
│   │   └── logical-model.md             # EER → Relational mapping, specialization strategies, normalization
│   └── relational/
│       └── relational-schema.md         # All 20 tables — columns, types, constraints
│
├── sql/
│   ├── ddl.sql                     # CREATE TABLE statements
│   ├── data.sql                    # Sample data (INSERT statements)
│   ├── triggers.sql                # Trigger functions and definitions
│   ├── queries_core.sql            # 5 core SELECT statements
│   └── queries_insights.sql        # 5 academic insight SELECT statements
│
└── report/
    └── Project_Report.pdf          # Full project report
```

---

## Database

**DBMS:** PostgreSQL  
**Tables:** 20  
**Universities populated:** Yaşar, Hacettepe, Çukurova

### Key tables

| Table | Description |
|---|---|
| `UNIVERSITY` / `FACULTY` / `DEPARTMENT` | Institutional hierarchy |
| `FACULTY_MEMBER` | All academic staff (instructors + assistants) |
| `COURSE` | All courses across all universities |
| `CURRICULUM_ITEM` | A slot in a department's semester plan |
| `COMPULSORY_ITEM` / `ELECTIVE_SEMESTER_ITEM` / `ELECTIVE_POOL_ITEM` | Curriculum item sub-types |
| `MATCHES` | Cross-university course equivalencies |
| `PREREQUISITE` | Prerequisite chains between courses |
| `SECTION` / `TEACHES` | Course offerings and instructor assignments |

---

## Getting Started

### Prerequisites

- PostgreSQL 13 or higher

### Setup

1. **Clone the repository**

```bash
git clone https://github.com/your-username/erasmus-curriculum-db.git
cd erasmus-curriculum-db
```

2. **Create the database**

```bash
psql -U postgres -c "CREATE DATABASE erasmus_db;"
```

3. **Run the scripts in order**

```bash
psql -U postgres -d erasmus_db -f sql/ddl.sql
psql -U postgres -d erasmus_db -f sql/triggers.sql
psql -U postgres -d erasmus_db -f sql/data.sql
```

4. **Run queries**

```bash
psql -U postgres -d erasmus_db -f sql/queries_core.sql
psql -U postgres -d erasmus_db -f sql/queries_insights.sql
```

> **Important:** `ddl.sql` must be run before `triggers.sql`, and both must be run before `data.sql`. The trigger in `triggers.sql` automatically populates `COMPULSORY_ITEM`, `ELECTIVE_SEMESTER_ITEM`, and `ELECTIVE_POOL_ITEM` on every insert into `CURRICULUM_ITEM` — do not insert into these sub-tables directly.

---

## Integration Methodology

Schema integration followed the **View Integration** approach described in Batini & Lenzerini (1984) and Batini, Lenzerini & Navathe (1986).

**Two-stage Binary-Ladder integration:**

```
Stage 1:  Yaşar EER  +  Hacettepe EER  →  Partial Integrated Schema (PIS)
Stage 2:  PIS        +  Çukurova EER   →  Global Integrated Schema
```

Each stage involved three steps:
1. **Comparison** — identifying naming conflicts (synonyms/homonyms) and structural conflicts
2. **Conforming** — resolving conflicts via renaming, syntactic restructuring, and representation selection
3. **Merging & Restructuring** — superimposing compatible schemas and evaluating for completeness, minimality, and understandability

For full details see [`models/logical/logical-model.md`](models/logical/logical-model.md).

---

## Design Highlights

- **`CURRICULUM_ITEM` + three sub-tables** — Compulsory, semester-elective, and pool-elective slots each reference different entities and enforce their own FK constraints. An after-insert trigger routes inserts automatically.
- **`MATCHES` table** — A dedicated M:N relation linking curriculum slots to equivalent courses at other universities, without modifying course definitions.
- **`FACULTY_MEMBER` single-table specialization** — `INSTRUCTOR` and `ASSISTANT` are distinguished via a `MemberType` discriminator. The `COORDINATOR` role is a boolean flag enforced by a check constraint.
- **T+A+L on `COURSE`** — Workload attributes were moved from subtype entities to `COURSE` during integration conforming, eliminating group-level redundancy.

---

## Team

İrem Kurtulmaz, Efe Çiçekdağı, Gizem Redif, Mert Ali Berrak

---

## References

- Batini, C., & Lenzerini, M. (1984). A methodology for data schema integration in the Entity–Relationship model. *IEEE Transactions on Software Engineering*, 10(6), 650–664.
- Batini, C., Lenzerini, M., & Navathe, S. B. (1986). A comparative analysis of methodologies for database schema integration. *ACM Computing Surveys*, 18(4), 323–364.
- Elmasri, R., & Navathe, S. B. (2016). *Fundamentals of Database Systems* (7th ed.). Pearson Education.
