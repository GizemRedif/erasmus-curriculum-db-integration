-- =============================================================
-- queries_core.sql
-- Erasmus Curriculum Database Integration
-- Description: 5 core SELECT statements
--   Q1-Q2 use a minimum of 2 tables
--   Q3-Q5 use a minimum of 3 tables
-- =============================================================

-- -------------------------------------------------------------
-- Q1: Full curriculum view for a department (2 tables)
--     Shows all curriculum slots for all departments with
--     resolved course/group names and ECTS values.
-- -------------------------------------------------------------
CREATE VIEW DEPT_CURRICULUM AS
SELECT
    ci.DeptCode,
    ci.ItemCode,
    ci.Semester,
    ci.CurriculumItemType,
    ci.GroupOrCourseCode                        AS Code,
    CASE
        WHEN ci.CurriculumItemType = 'COMPUL'  THEN c.Name
        WHEN ci.CurriculumItemType = 'EL-SEM'  THEN eg.GroupName
        WHEN ci.CurriculumItemType = 'EL-POOL' THEN eg.GroupName
        ELSE 'Unknown'
    END                                         AS ItemName,
    CASE
        WHEN ci.CurriculumItemType = 'COMPUL'  THEN c.ECTS
        ELSE eg.GroupECTSTarget
    END                                         AS ECTS
FROM CURRICULUM_ITEM ci
LEFT JOIN COURSE        c  ON ci.GroupOrCourseCode = c.Code
LEFT JOIN ELECTIVE_GROUP eg ON ci.GroupOrCourseCode = eg.GroupCode
ORDER BY ci.DeptCode, ci.Semester;

-- -------------------------------------------------------------
-- Q2: Cross-university matches for a given department/semester
--     (2 tables — uses the DEPT_CURRICULUM view + COURSE)
--     Shows Yaşar Semester 1 curriculum slots alongside
--     their matched courses from other universities.
-- -------------------------------------------------------------
SELECT
    ci.DeptCode,
    ci.Semester,
    ci.CurriculumItemType,
    ci.Code         AS TargetCode,
    ci.ItemName     AS TargetName,
    ci.ECTS         AS TargetECTS,
    m.CourseCode    AS MatchedCourseCode,
    c.Name          AS MatchedCourseName,
    c.ECTS          AS MatchedECTS
FROM MATCHES        m
RIGHT JOIN DEPT_CURRICULUM ci
       ON  ci.ItemCode = m.ItemCode
       AND ci.DeptCode = m.DeptCode
JOIN  COURSE c
       ON  m.CourseCode = c.Code
WHERE ci.DeptCode = 'YAUN-SOFT-ENG'
  AND ci.Semester = 1;

-- -------------------------------------------------------------
-- Q3: Full curriculum detail for Hacettepe (3 tables)
--     Includes workload (T+A+L) and course content.
-- -------------------------------------------------------------
SELECT
    ci.Semester,
    ci.CurriculumItemType,
    COALESCE(c.Name,  eg.GroupName)       AS ItemName,
    COALESCE(c.ECTS,  eg.GroupECTSTarget) AS ECTS,
    c.Theoric,
    c.Application,
    c.Laboratory,
    c.Content
FROM CURRICULUM_ITEM  ci
LEFT JOIN COURSE        c  ON ci.GroupOrCourseCode = c.Code
LEFT JOIN ELECTIVE_GROUP eg ON ci.GroupOrCourseCode = eg.GroupCode
WHERE ci.DeptCode = 'HAUN-AI-ENG'
ORDER BY ci.Semester;

-- -------------------------------------------------------------
-- Q4: Instructor education records for a specific course (3 tables)
--     Returns degree information for instructors who teach SE 1105.
-- -------------------------------------------------------------
SELECT
    fm.Lname,
    me.DegreeType,
    me.University,
    me.Field
FROM SECTION          s
JOIN TEACHES          t  ON s.SectionCode = t.SectionCode
JOIN MEMBER_EDUCATION me ON t.InstructorId = me.MemberId
JOIN FACULTY_MEMBER   fm ON me.MemberId    = fm.MemberId
WHERE s.CourseCode = 'SE 1105';

-- -------------------------------------------------------------
-- Q5: All elective courses with their group details (3 tables)
--     Lists distinct elective courses linked to curriculum items,
--     showing group membership and course content.
-- -------------------------------------------------------------
SELECT DISTINCT
    ci.GroupOrCourseCode    AS GroupCode,
    c.Name                  AS CourseName,
    c.ECTS,
    c.Content
FROM CURRICULUM_ITEM  ci
JOIN ELECTIVE_GROUP   eg ON ci.GroupOrCourseCode = eg.GroupCode
JOIN COURSE           c  ON c.ElectiveGroup      = eg.GroupCode
WHERE ci.CurriculumItemType <> 'COMPUL';
