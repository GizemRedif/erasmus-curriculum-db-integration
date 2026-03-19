-- =============================================================
-- ddl.sql
-- Erasmus Curriculum Database Integration
-- Database: PostgreSQL
-- Description: Schema definition for all 20 tables
-- =============================================================

-- -------------------------------------------------------------
-- UNIVERSITY
-- -------------------------------------------------------------
CREATE TABLE UNIVERSITY (
    UniCode VARCHAR(4)   PRIMARY KEY,
    Address VARCHAR(100) NOT NULL,
    Name    VARCHAR(30)  NOT NULL UNIQUE,
    Phone   VARCHAR(13)  UNIQUE,
    CHECK (Phone IS NULL OR Phone ~ '^(0[0-9]{10}|\+90[0-9]{10})$')
);

-- -------------------------------------------------------------
-- FACULTY_MEMBER
-- (created before FACULTY and DEPARTMENT because both reference it)
-- -------------------------------------------------------------
CREATE TABLE FACULTY_MEMBER (
    MemberId      INT          PRIMARY KEY,
    Title         VARCHAR(20),
    Fname         VARCHAR(20)  NOT NULL,
    Lname         VARCHAR(20)  NOT NULL,
    Mail          VARCHAR(30)  UNIQUE,
    UniCode       VARCHAR(4)   NOT NULL
                               REFERENCES UNIVERSITY(UniCode)
                               ON DELETE RESTRICT
                               ON UPDATE RESTRICT,
    MemberType    CHAR(2)      NOT NULL,
    IsCoordinator BOOLEAN      NOT NULL,
    CONSTRAINT chk_member_type
        CHECK (MemberType IN ('IN', 'AS')),
    CONSTRAINT chk_assistant_coordinator
        CHECK (NOT (MemberType = 'AS' AND IsCoordinator = TRUE))
);

-- -------------------------------------------------------------
-- FACULTY
-- -------------------------------------------------------------
CREATE TABLE FACULTY (
    Fcode   VARCHAR(8)  PRIMARY KEY,
    Fname   VARCHAR(30) NOT NULL,
    UniCode VARCHAR(4)  NOT NULL
                        REFERENCES UNIVERSITY(UniCode)
                        ON DELETE RESTRICT
                        ON UPDATE CASCADE,
    DeanId  INT         NOT NULL UNIQUE DEFAULT 0
                        REFERENCES FACULTY_MEMBER(MemberId)
                        ON DELETE SET DEFAULT
                        ON UPDATE CASCADE
);

-- -------------------------------------------------------------
-- DEPARTMENT
-- -------------------------------------------------------------
CREATE TABLE DEPARTMENT (
    DeptCode    VARCHAR(15) PRIMARY KEY,
    Name        VARCHAR(40) NOT NULL,
    Language    VARCHAR(15) NOT NULL,
    FacultyCode VARCHAR(8)  NOT NULL
                            REFERENCES FACULTY(Fcode)
                            ON DELETE RESTRICT
                            ON UPDATE CASCADE,
    ChairId     INT         NOT NULL UNIQUE DEFAULT 0
                            REFERENCES FACULTY_MEMBER(MemberId)
                            ON DELETE SET DEFAULT
                            ON UPDATE CASCADE
);

-- -------------------------------------------------------------
-- MEMBER_EDUCATION
-- -------------------------------------------------------------
CREATE TABLE MEMBER_EDUCATION (
    MemberId   INT          REFERENCES FACULTY_MEMBER(MemberId)
                            ON DELETE CASCADE
                            ON UPDATE CASCADE,
    DegreeType VARCHAR(50),
    University VARCHAR(100),
    Field      VARCHAR(150),
    CONSTRAINT pk_member_education
        PRIMARY KEY (MemberId, DegreeType, University, Field)
);

-- -------------------------------------------------------------
-- ELECTIVE_GROUP
-- -------------------------------------------------------------
CREATE TABLE ELECTIVE_GROUP (
    GroupCode       VARCHAR(20) PRIMARY KEY,
    GroupName       VARCHAR(50) NOT NULL,
    GroupECTSTarget INT,
    GroupType       VARCHAR(13) NOT NULL,
    CONSTRAINT check_elective_group_type
        CHECK (GroupType IN ('SEM_ELECT_GR', 'POOL_ELECT_GR'))
);

-- -------------------------------------------------------------
-- COURSE
-- -------------------------------------------------------------
CREATE TABLE COURSE (
    Code         VARCHAR(10)  PRIMARY KEY,
    Name         VARCHAR(150) NOT NULL,
    ECTS         INT          NOT NULL,
    Theoric      INT,
    Application  INT,
    Laboratory   INT,
    Language     VARCHAR(15),
    DeliveryMode VARCHAR(8)   DEFAULT 'On-Site',
    LabCode      VARCHAR(10)
                              REFERENCES COURSE(Code),
    DeptCode     VARCHAR(15)
                              REFERENCES DEPARTMENT(DeptCode)
                              ON DELETE RESTRICT
                              ON UPDATE CASCADE,
    CourseType   VARCHAR(11)  NOT NULL,
    Content      TEXT,
    ElectiveType VARCHAR(20),
    ElectiveGroup VARCHAR(30)
                              REFERENCES ELECTIVE_GROUP(GroupCode)
                              ON DELETE CASCADE
                              ON UPDATE CASCADE,
    CONSTRAINT chk_elective_type
        CHECK (ElectiveType IN ('Pool Elective', 'Semester Elective')),
    CONSTRAINT chk_course_type
        CHECK (CourseType IN ('Elective', 'Compulsory'))
);

ALTER TABLE COURSE
    ADD CONSTRAINT chk_course_total_hours
    CHECK (
        COALESCE(Theoric, 0) + COALESCE(Application, 0) + COALESCE(Laboratory, 0) > 0
    );

ALTER TABLE COURSE
    ADD CONSTRAINT chk_course_elective_logic
    CHECK (
        (CourseType = 'Compulsory'
            AND ElectiveType  IS NULL
            AND ElectiveGroup IS NULL)
        OR
        (CourseType = 'Elective'
            AND ElectiveType = 'Pool Elective'
            AND ElectiveGroup IS NOT NULL)
        OR
        (CourseType = 'Elective'
            AND ElectiveType = 'Semester Elective'
            AND ElectiveGroup IS NOT NULL)
    );

-- -------------------------------------------------------------
-- SECTION
-- -------------------------------------------------------------
CREATE TABLE SECTION (
    SectionCode   VARCHAR(15) PRIMARY KEY,
    SemPeriod     VARCHAR(6)  NOT NULL,
    Year          SMALLINT    NOT NULL,
    CourseCode    VARCHAR(10)
                              REFERENCES COURSE(Code)
                              ON DELETE CASCADE
                              ON UPDATE CASCADE,
    CoordinatorId INT
                              REFERENCES FACULTY_MEMBER(MemberId)
                              ON DELETE SET NULL
                              ON UPDATE CASCADE,
    AssistantId   INT
                              REFERENCES FACULTY_MEMBER(MemberId)
                              ON DELETE SET NULL
                              ON UPDATE CASCADE,
    CONSTRAINT chk_sem_period
        CHECK (SemPeriod IN ('FALL', 'SPRING')),
    CONSTRAINT uniq_section_course_term
        UNIQUE (CourseCode, Year, SemPeriod)
);

-- -------------------------------------------------------------
-- TEACHES
-- -------------------------------------------------------------
CREATE TABLE TEACHES (
    SectionCode  VARCHAR(15) REFERENCES SECTION(SectionCode)
                             ON DELETE CASCADE
                             ON UPDATE CASCADE,
    InstructorId INT         REFERENCES FACULTY_MEMBER(MemberId)
                             ON DELETE CASCADE
                             ON UPDATE CASCADE,
    PRIMARY KEY (SectionCode, InstructorId)
);

-- -------------------------------------------------------------
-- CURRICULUM_ITEM  (weak entity)
-- -------------------------------------------------------------
CREATE TABLE CURRICULUM_ITEM (
    ItemCode           SERIAL,
    DeptCode           VARCHAR(15)
                                   REFERENCES DEPARTMENT(DeptCode)
                                   ON DELETE RESTRICT
                                   ON UPDATE RESTRICT,
    Semester           SMALLINT    NOT NULL,
    CurriculumItemType VARCHAR(7)  NOT NULL,
    GroupOrCourseCode  VARCHAR(15) NOT NULL,
    PRIMARY KEY (DeptCode, ItemCode),
    CONSTRAINT chk_semester
        CHECK (Semester IN (1, 2, 3, 4, 5, 6, 7, 8)),
    CONSTRAINT chk_curriculum_item_type
        CHECK (CurriculumItemType IN ('EL-POOL', 'EL-SEM', 'COMPUL'))
);

-- -------------------------------------------------------------
-- COMPULSORY_ITEM
-- -------------------------------------------------------------
CREATE TABLE COMPULSORY_ITEM (
    DeptCode       VARCHAR(15),
    ItemCode       INT,
    CompulsoryCode VARCHAR(15) UNIQUE
                               REFERENCES COURSE(Code)
                               ON DELETE RESTRICT
                               ON UPDATE CASCADE,
    PRIMARY KEY (DeptCode, ItemCode),
    FOREIGN KEY (DeptCode, ItemCode)
        REFERENCES CURRICULUM_ITEM(DeptCode, ItemCode)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- -------------------------------------------------------------
-- ELECTIVE_SEMESTER_ITEM
-- -------------------------------------------------------------
CREATE TABLE ELECTIVE_SEMESTER_ITEM (
    DeptCode     VARCHAR(15),
    ItemCode     INT,
    ElectiveCode VARCHAR(15) UNIQUE
                             REFERENCES ELECTIVE_GROUP(GroupCode)
                             ON DELETE RESTRICT
                             ON UPDATE CASCADE,
    PRIMARY KEY (DeptCode, ItemCode),
    FOREIGN KEY (DeptCode, ItemCode)
        REFERENCES CURRICULUM_ITEM(DeptCode, ItemCode)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- -------------------------------------------------------------
-- ELECTIVE_POOL_ITEM
-- -------------------------------------------------------------
CREATE TABLE ELECTIVE_POOL_ITEM (
    DeptCode     VARCHAR(15),
    ItemCode     INT,
    ElectiveCode VARCHAR(15)
                             REFERENCES ELECTIVE_GROUP(GroupCode)
                             ON DELETE RESTRICT
                             ON UPDATE CASCADE,
    PRIMARY KEY (DeptCode, ItemCode),
    FOREIGN KEY (DeptCode, ItemCode)
        REFERENCES CURRICULUM_ITEM(DeptCode, ItemCode)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- -------------------------------------------------------------
-- MATCHES
-- -------------------------------------------------------------
CREATE TABLE MATCHES (
    DeptCode   VARCHAR(15),
    ItemCode   INT,
    CourseCode VARCHAR(10),
    PRIMARY KEY (DeptCode, ItemCode, CourseCode),
    FOREIGN KEY (DeptCode, ItemCode)
        REFERENCES CURRICULUM_ITEM(DeptCode, ItemCode)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (CourseCode)
        REFERENCES COURSE(Code)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- -------------------------------------------------------------
-- PREREQUISITE
-- -------------------------------------------------------------
CREATE TABLE PREREQUISITE (
    CourseCode       VARCHAR(10) REFERENCES COURSE(Code)
                                 ON DELETE CASCADE
                                 ON UPDATE CASCADE,
    PrerequisiteCode VARCHAR(10) REFERENCES COURSE(Code)
                                 ON DELETE CASCADE
                                 ON UPDATE CASCADE,
    CONSTRAINT pk_prerequisite
        PRIMARY KEY (CourseCode, PrerequisiteCode)
);

-- -------------------------------------------------------------
-- RESOURCES
-- -------------------------------------------------------------
CREATE TABLE RESOURCES (
    ResourceId SERIAL      PRIMARY KEY,
    CourseCode VARCHAR(10) REFERENCES COURSE(Code)
                           ON DELETE CASCADE
                           ON UPDATE CASCADE,
    Resource   VARCHAR(300)
);

-- -------------------------------------------------------------
-- CATEGORY
-- -------------------------------------------------------------
CREATE TABLE CATEGORY (
    CategoryId SERIAL      PRIMARY KEY,
    CourseCode VARCHAR(10) REFERENCES COURSE(Code)
                           ON DELETE CASCADE
                           ON UPDATE CASCADE,
    Name       VARCHAR(40),
    Percentage INT
);

-- -------------------------------------------------------------
-- LEARNING_OUTCOMES
-- -------------------------------------------------------------
CREATE TABLE LEARNING_OUTCOMES (
    OutcomeId  SERIAL      PRIMARY KEY,
    CourseCode VARCHAR(10) REFERENCES COURSE(Code)
                           ON DELETE CASCADE
                           ON UPDATE CASCADE,
    Outcome    TEXT
);

-- -------------------------------------------------------------
-- SUBJECTS
-- -------------------------------------------------------------
CREATE TABLE SUBJECTS (
    CourseCode VARCHAR(10) REFERENCES COURSE(Code)
                           ON DELETE CASCADE
                           ON UPDATE CASCADE,
    Week       INT,
    Subjects   TEXT,
    CONSTRAINT pk_subjects
        PRIMARY KEY (CourseCode, Week)
);

-- -------------------------------------------------------------
-- EVALUATION_CRITERIA
-- -------------------------------------------------------------
CREATE TABLE EVALUATION_CRITERIA (
    EvalCriteriaId SERIAL      PRIMARY KEY,
    CourseCode     VARCHAR(10) REFERENCES COURSE(Code)
                               ON DELETE CASCADE
                               ON UPDATE CASCADE,
    SemesterStudies VARCHAR(50),
    Number          INT        DEFAULT 1,
    Contribution    INT
);
