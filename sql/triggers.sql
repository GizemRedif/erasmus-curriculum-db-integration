-- =============================================================
-- triggers.sql
-- Erasmus Curriculum Database Integration
-- Description: All trigger functions and trigger definitions
-- =============================================================

-- -------------------------------------------------------------
-- TRIGGER 1: Section member validation
-- Table   : SECTION
-- Event   : BEFORE INSERT OR UPDATE
-- Purpose : Validates that CoordinatorId belongs to an instructor
--           with IsCoordinator = TRUE, and AssistantId belongs
--           to an assistant (MemberType = 'AS').
-- -------------------------------------------------------------
CREATE OR REPLACE FUNCTION trg_section_validate_members()
RETURNS TRIGGER AS $$
BEGIN
    -- Validate coordinator
    IF NEW.CoordinatorId IS NOT NULL THEN
        IF NOT EXISTS (
            SELECT 1
            FROM FACULTY_MEMBER
            WHERE MemberId     = NEW.CoordinatorId
              AND MemberType   = 'IN'
              AND IsCoordinator = TRUE
        ) THEN
            RAISE EXCEPTION
                'CoordinatorId % is not a valid Coordinator.', NEW.CoordinatorId;
        END IF;
    END IF;

    -- Validate assistant
    IF NEW.AssistantId IS NOT NULL THEN
        IF NOT EXISTS (
            SELECT 1
            FROM FACULTY_MEMBER
            WHERE MemberId   = NEW.AssistantId
              AND MemberType = 'AS'
        ) THEN
            RAISE EXCEPTION
                'AssistantId % is not a valid Assistant.', NEW.AssistantId;
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_section_member_check
BEFORE INSERT OR UPDATE ON SECTION
FOR EACH ROW
EXECUTE FUNCTION trg_section_validate_members();


-- -------------------------------------------------------------
-- TRIGGER 2: Curriculum item router
-- Table   : CURRICULUM_ITEM
-- Event   : AFTER INSERT
-- Purpose : Automatically inserts the new row into the correct
--           sub-table (COMPULSORY_ITEM, ELECTIVE_SEMESTER_ITEM,
--           or ELECTIVE_POOL_ITEM) based on CurriculumItemType
--           and the GroupType of the referenced ELECTIVE_GROUP.
-- -------------------------------------------------------------
CREATE OR REPLACE FUNCTION trg_curriculum_item_router()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.CurriculumItemType = 'EL-POOL'
       AND (SELECT GroupType FROM ELECTIVE_GROUP
            WHERE GroupCode = NEW.GroupOrCourseCode) = 'POOL_ELECT_GR'
    THEN
        INSERT INTO ELECTIVE_POOL_ITEM (DeptCode, ItemCode, ElectiveCode)
        VALUES (NEW.DeptCode, NEW.ItemCode, NEW.GroupOrCourseCode);

    ELSIF NEW.CurriculumItemType = 'EL-SEM'
       AND (SELECT GroupType FROM ELECTIVE_GROUP
            WHERE GroupCode = NEW.GroupOrCourseCode) = 'SEM_ELECT_GR'
    THEN
        INSERT INTO ELECTIVE_SEMESTER_ITEM (DeptCode, ItemCode, ElectiveCode)
        VALUES (NEW.DeptCode, NEW.ItemCode, NEW.GroupOrCourseCode);

    ELSE
        INSERT INTO COMPULSORY_ITEM (DeptCode, ItemCode, CompulsoryCode)
        VALUES (NEW.DeptCode, NEW.ItemCode, NEW.GroupOrCourseCode);
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER curriculum_item_after_insert
AFTER INSERT ON CURRICULUM_ITEM
FOR EACH ROW
EXECUTE FUNCTION trg_curriculum_item_router();


-- -------------------------------------------------------------
-- TRIGGER 3: Block direct inserts into sub-item tables
-- Tables  : COMPULSORY_ITEM, ELECTIVE_SEMESTER_ITEM,
--           ELECTIVE_POOL_ITEM
-- Event   : BEFORE INSERT
-- Purpose : Prevents users from inserting directly into sub-tables,
--           enforcing that all inserts go through CURRICULUM_ITEM.
--           Inserts originating from the router trigger (depth > 0)
--           are allowed through.
-- -------------------------------------------------------------
CREATE OR REPLACE FUNCTION block_item_manual_insert()
RETURNS TRIGGER AS $$
BEGIN
    IF pg_trigger_depth() > 0 THEN
        RETURN NEW;
    END IF;

    RAISE EXCEPTION
        'Direct inserts are not allowed. Use CURRICULUM_ITEM instead.';
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_block_pool_item_insert
BEFORE INSERT ON ELECTIVE_POOL_ITEM
FOR EACH ROW
EXECUTE FUNCTION block_item_manual_insert();

CREATE TRIGGER trg_block_semester_item_insert
BEFORE INSERT ON ELECTIVE_SEMESTER_ITEM
FOR EACH ROW
EXECUTE FUNCTION block_item_manual_insert();

CREATE TRIGGER trg_block_compulsory_item_insert
BEFORE INSERT ON COMPULSORY_ITEM
FOR EACH ROW
EXECUTE FUNCTION block_item_manual_insert();


-- -------------------------------------------------------------
-- TRIGGER 4: Elective group type consistency check on COURSE
-- Table   : COURSE
-- Event   : BEFORE INSERT OR UPDATE
-- Purpose : Ensures that a Pool Elective course is linked to a
--           POOL_ELECT_GR group, and a Semester Elective course
--           is linked to a SEM_ELECT_GR group.
-- -------------------------------------------------------------
CREATE OR REPLACE FUNCTION trg_course_elective_group_type_check()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.CourseType = 'Elective'
       AND NEW.ElectiveType = 'Pool Elective'
       AND (SELECT GroupType FROM ELECTIVE_GROUP
            WHERE GroupCode = NEW.ElectiveGroup) <> 'POOL_ELECT_GR'
    THEN
        RAISE EXCEPTION
            'Pool Elective courses must be linked to a POOL_ELECT_GR group.';
    END IF;

    IF NEW.CourseType = 'Elective'
       AND NEW.ElectiveType = 'Semester Elective'
       AND (SELECT GroupType FROM ELECTIVE_GROUP
            WHERE GroupCode = NEW.ElectiveGroup) <> 'SEM_ELECT_GR'
    THEN
        RAISE EXCEPTION
            'Semester Elective courses must be linked to a SEM_ELECT_GR group.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_course_elective_group_type_check
BEFORE INSERT OR UPDATE ON COURSE
FOR EACH ROW
EXECUTE FUNCTION trg_course_elective_group_type_check();
