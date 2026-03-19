-- =============================================================
-- queries_insights.sql
-- Erasmus Curriculum Database Integration
-- Description: 5 original SELECT statements providing
--              meaningful academic insights
-- =============================================================

-- -------------------------------------------------------------
-- INSIGHT 1: Compulsory vs elective course balance per department
--            How flexible is each department's curriculum?
-- -------------------------------------------------------------
SELECT
    d.DeptCode,
    d.Name                                                          AS DepartmentName,
    SUM(CASE WHEN ci.CurriculumItemType = 'COMPUL'  THEN 1 ELSE 0 END) AS CompulsoryCount,
    SUM(CASE WHEN ci.CurriculumItemType LIKE 'EL-%' THEN 1 ELSE 0 END) AS ElectiveCount,
    ROUND(
        SUM(CASE WHEN ci.CurriculumItemType LIKE 'EL-%' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*), 1
    )                                                               AS ElectiveRatioPct
FROM CURRICULUM_ITEM ci
JOIN DEPARTMENT      d  ON d.DeptCode = ci.DeptCode
GROUP BY d.DeptCode, d.Name
ORDER BY ElectiveRatioPct DESC;

-- -------------------------------------------------------------
-- INSIGHT 2: Prerequisite chain depth per course
--            Which courses put students in the most constrained path?
-- -------------------------------------------------------------
SELECT
    c.Code          AS CourseCode,
    c.Name,
    c.DeptCode,
    COUNT(p.PrerequisiteCode) AS PrerequisiteCount
FROM COURSE       c
LEFT JOIN PREREQUISITE p ON c.Code = p.CourseCode
GROUP BY c.Code, c.Name, c.DeptCode
ORDER BY PrerequisiteCount DESC;

-- -------------------------------------------------------------
-- INSIGHT 3: Courses with missing weekly subject plans
--            Curriculum quality review — which courses have
--            fewer than 14 weeks of defined content?
-- -------------------------------------------------------------
SELECT
    c.Code,
    c.Name,
    c.DeptCode,
    COUNT(s.Week) AS DefinedWeeks
FROM COURSE    c
LEFT JOIN SUBJECTS s ON s.CourseCode = c.Code
GROUP BY c.Code, c.Name, c.DeptCode
HAVING COUNT(s.Week) < 14
ORDER BY DefinedWeeks ASC;

-- -------------------------------------------------------------
-- INSIGHT 4: Courses without any listed resources
--            Curriculum quality review — which courses lack
--            reference materials?
-- -------------------------------------------------------------
SELECT
    c.Code,
    c.Name,
    c.DeptCode
FROM COURSE     c
LEFT JOIN RESOURCES r ON r.CourseCode = c.Code
WHERE r.ResourceId IS NULL
ORDER BY c.DeptCode, c.Name;

-- -------------------------------------------------------------
-- INSIGHT 5: Cross-university course equivalency summary
--            For each department curriculum slot, how many
--            courses from other universities are matched?
--            Useful for identifying well-covered and
--            under-matched slots in the Erasmus context.
-- -------------------------------------------------------------
SELECT
    ci.DeptCode,
    ci.ItemCode,
    ci.Semester,
    ci.CurriculumItemType,
    COALESCE(c.Name, eg.GroupName)  AS SlotName,
    COUNT(m.CourseCode)             AS MatchCount
FROM CURRICULUM_ITEM  ci
LEFT JOIN COURSE        c  ON ci.GroupOrCourseCode = c.Code
LEFT JOIN ELECTIVE_GROUP eg ON ci.GroupOrCourseCode = eg.GroupCode
LEFT JOIN MATCHES        m  ON m.DeptCode = ci.DeptCode
                            AND m.ItemCode = ci.ItemCode
GROUP BY ci.DeptCode, ci.ItemCode, ci.Semester,
         ci.CurriculumItemType, SlotName
ORDER BY ci.DeptCode, ci.Semester, MatchCount DESC;
