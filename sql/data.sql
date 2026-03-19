-- =============================================================
-- data.sql
-- Erasmus Curriculum Database Integration
-- Description: Sample data population for all three universities
-- Order follows FK dependencies
-- =============================================================

-- -------------------------------------------------------------
-- UNIVERSITY
-- -------------------------------------------------------------
INSERT INTO UNIVERSITY (UniCode, Address, Name, Phone)
VALUES
    ('YAUN', 'Selçuk Yaşar Kampüsü, Kazımdirik, Üniversite Cd. Ağaçlı Yol No: 37-39, 35100 Bornova/İzmir',
             'YASAR UNIVERSITY',    '02325707070'),
    ('HAUN', 'Hacettepe Üniversitesi Sıhhiye, 06100, Ankara',
             'HACETTEPE UNIVERSITY','03123052141'),
    ('CUUN', 'Balcalı Kampüsü, 01330 Sarıçam/ADANA',
             'CUKUROVA UNIVERSITY', '+903223386623'),
    ('UNKN', 'Unknown', 'Unknown', NULL);

-- -------------------------------------------------------------
-- FACULTY_MEMBER  (placeholder record must be inserted first)
-- -------------------------------------------------------------
INSERT INTO FACULTY_MEMBER (MemberId, Title, Fname, Lname, Mail, UniCode, MemberType, IsCoordinator)
VALUES
    -- Placeholder
    (0,  'Unknown',              'Unknown',       'Unknown',          ' ',                              'UNKN', 'IN', FALSE),
    -- Yaşar University
    (1,  'Assistant Professor',  'Dindar',        'Öz',               'dindar.oz@yasar.edu.tr',         'YAUN', 'IN', TRUE),
    (2,  'Research Assist',      'Tolga Buğra',   'Altuntaş',         NULL,                             'YAUN', 'AS', FALSE),
    (3,  'Associate Professor',  'Mete',          'Eminağaoğlu',      'mete.eminagaoglu@yasar.edu.tr',  'YAUN', 'IN', FALSE),
    (4,  'Assistant Professor',  'Umut',          'Avcı',             'umut.avci@yasar.edu.tr',         'YAUN', 'IN', TRUE),
    (5,  'Research Assist',      'Atabarış',      'Ayaydın',          'atabaris.ayaydin@yasar.edu.tr',  'YAUN', 'AS', FALSE),
    (6,  'Assistant Professor',  'Cansu Aksu',    'Raffard',          'cansu.aksu@yasar.edu.tr',        'YAUN', 'IN', TRUE),
    (7,  'Lecturer',             'Nejla',         'Gündoğar',         'nejla.gundogar@yasar.edu.tr',    'YAUN', 'IN', FALSE),
    (8,  'Associate Professor',  'Burhan',        'Gülbahar',         'burhan.gulbahar@yasar.edu.tr',   'YAUN', 'IN', TRUE),
    (9,  'Associate Professor',  'Nalan',         'Özkurt',           'nalan.ozkurt@yasar.edu.tr',      'YAUN', 'IN', FALSE),
    (19, 'Professor',            'Ayhan Özgür',   'Toy',              'ozgur.toy@yasar.edu.tr',         'YAUN', 'IN', FALSE),
    (20, 'Associate Professor',  'Korhan',        'Karabulut',        'korhan.karabulut@yasar.edu.tr',  'YAUN', 'IN', FALSE),
    (31, 'Assistant Professor',  'Arman',         'Savran',           'arman.savran@yasar.edu.tr',      'YAUN', 'IN', TRUE),
    (32, 'Assistant Professor',  'Kazım',         'Erdoğdu',          'kazim.erdogdu@yasar.edu.tr',     'YAUN', 'IN', FALSE),
    (33, 'Assistant Professor',  'Barış',         'Yıldız',           'baris.yildiz@yasar.edu.tr',      'YAUN', 'IN', TRUE),
    (34, 'Assistant Professor',  'Deniz',         'Özsoyeller',       'deniz.ozsoyeller@yasar.edu.tr',  'YAUN', 'IN', TRUE),
    (35, 'Assistant Professor',  'Uras',          'Tos',              'uras.tos@yasar.edu.tr',          'YAUN', 'IN', FALSE),
    (36, 'Lecturer',             'Asadul',        'Islam',            'asadul.islam@yasar.edu.tr',      'YAUN', 'IN', TRUE),
    (37, 'Lecturer',             'Filiz Pars',    'Uçağı',            'filiz.ucagi@yasar.edu.tr',       'YAUN', 'IN', TRUE),
    (38, 'Lecturer',             'Elvira',        'Korukcu',          'elvira.korukcu@yasar.edu.tr',    'YAUN', 'IN', FALSE),
    (39, 'Lecturer',             'Cenk',          'Erdem',            'cenk.erdem@yasar.edu.tr',        'YAUN', 'IN', FALSE),
    (40, 'Professor',            'Ahmet Hasan',   'Koltuksuz',        'ahmet.koltuksuz@yasar.edu.tr',   'YAUN', 'IN', TRUE),
    -- Hacettepe University
    (10, 'Assistant Professor',  'Fuat',          'Akal',             'akal@hacettepe.edu.tr',          'HAUN', 'IN', FALSE),
    (11, 'Professor',            'Mehmet Erkut',  'Erdem',            'erkut@hacettepe.edu.tr',         'HAUN', 'IN', FALSE),
    (12, 'Professor',            'Suat',          'Özdemir',          'suatozdemir@hacettepe.edu.tr',   'HAUN', 'IN', FALSE),
    (13, 'Associate Professor',  'Harun',         'Artuner',          'artuner@hacettepe.edu.tr',       'HAUN', 'IN', FALSE),
    (21, 'Professor',            'Halil',         'Vural',            'ghalil@hacettepe.edu.tr',        'HAUN', 'IN', FALSE),
    (25, 'Professor',            'Sevil',         'Şen',              'sevilsen@hacettepe.edu.tr',      'HAUN', 'IN', FALSE),
    (26, 'Associate Professor',  'Cemil',         'Zalluhoğlu',       'cemil@cs.hacettepe.edu.tr',      'HAUN', 'IN', FALSE),
    (27, 'Professor',            'Tunca',         'Doğan',            'tuncadogan@hacettepe.edu.tr',    'HAUN', 'IN', FALSE),
    (28, 'Professor',            'İlyas',         'Çilekli',          NULL,                             'HAUN', 'IN', FALSE),
    (29, 'Professor',            'Pınar Duygulu', 'Şahin',            'pinar.duygulu@hacettepe.edu.tr', 'HAUN', 'IN', FALSE),
    (30, 'Professor',            'Ayça',          'Kolukısa',         'ayca.tarhan@hacettepe.edu.tr',   'HAUN', 'IN', FALSE),
    -- Çukurova University
    (14, 'Professor',            'Zekeriya',      'Tüfekçi',          'ztufekci@cu.edu.tr',             'CUUN', 'IN', TRUE),
    (15, 'Associate Professor',  'Fatih',         'Abut',             'fabut@cu.edu.tr',                'CUUN', 'IN', TRUE),
    (16, 'Assistant Professor',  'Elif Emel',     'Fırat',            'eefirat@cu.edu.tr',              'CUUN', 'IN', TRUE),
    (17, 'Lecturer',             'Yunus Emre',    'Çoğurcu',          'ycogurcu@cu.edu.tr',             'CUUN', 'IN', FALSE),
    (18, 'Lecturer',             'Murat',         'Kara',             'mkara@cu.edu.tr',                'CUUN', 'IN', TRUE),
    (22, 'Professor',            'Ali',           'Keskin',           'akeskin@cu.edu.tr',              'CUUN', 'IN', FALSE),
    (24, 'Professor',            'Umut',          'Orhan',            'uorhan@cu.edu.tr',               'CUUN', 'IN', TRUE),
    (41, 'Assistant Professor',  'Barış',         'Ata',              'bata@cu.edu.tr',                 'CUUN', 'IN', TRUE),
    (42, 'Professor',            'Selma Ayşe',    'Özel',             'saozel@cu.edu.tr',               'CUUN', 'IN', TRUE),
    (43, 'Professor',            'Ramazan',       'Çoban',            'rcoban@cu.edu.tr',               'CUUN', 'IN', TRUE),
    (44, 'Associate Professor',  'Emine',         'Ayan',             'enacak@cu.edu.tr',               'CUUN', 'IN', TRUE),
    (45, 'Associate Professor',  'Mustafa',       'Akyıldız',         'akyildizm@cu.edu.tr',            'CUUN', 'IN', TRUE),
    (46, 'Professor',            'Refika',        'Altıkulaç Demirdağ','raltikulac@cu.edu.tr',          'CUUN', 'IN', TRUE);

-- -------------------------------------------------------------
-- FACULTY
-- -------------------------------------------------------------
INSERT INTO FACULTY (Fcode, Fname, UniCode, DeanId)
VALUES
    ('YAUN-ENG', 'Faculty of Engineering', 'YAUN', 19),
    ('HAUN-ENG', 'Faculty of Engineering', 'HAUN', 21),
    ('CUUN-ENG', 'Faculty of Engineering', 'CUUN', 22);

-- -------------------------------------------------------------
-- DEPARTMENT
-- -------------------------------------------------------------
INSERT INTO DEPARTMENT (DeptCode, Name, Language, FacultyCode, ChairId)
VALUES
    ('YAUN-SOFT-ENG',  'Software Engineering',                'English', 'YAUN-ENG', 20),
    ('HAUN-AI-ENG',    'Artificial Intelligence Engineering',  'English', 'HAUN-ENG', 0),
    ('CUUN-COMP-ENG',  'Computer Engineering',                 'English', 'CUUN-ENG', 24);

-- -------------------------------------------------------------
-- ELECTIVE_GROUP
-- -------------------------------------------------------------
INSERT INTO ELECTIVE_GROUP (GroupCode, GroupName, GroupECTSTarget, GroupType)
VALUES
    ('UNV ELECT SE',  'University Elective Course SE',    5, 'POOL_ELECT_GR'),
    ('ELECT SE A',    'Department Elective Course A',     6, 'POOL_ELECT_GR'),
    ('ELECT SE B',    'Department Elective Course B',     6, 'POOL_ELECT_GR'),
    ('AIN NO LAB',    'AIN Technical Elective',           6, 'POOL_ELECT_GR'),
    ('AIN WITH LAB',  'AIN Technical Elective',           6, 'POOL_ELECT_GR'),
    ('AIN LAB',       'AIN Technical Elective Lab',       4, 'POOL_ELECT_GR'),
    ('BBM',           'BBM Technical Elective',           6, 'POOL_ELECT_GR'),
    ('NON TEC',       'Nontechnical Elective',             4, 'POOL_ELECT_GR'),
    ('NFE',           'Non-Field Elective Courses',        3, 'POOL_ELECT_GR'),
    ('TECH ELEC 1',   'Technical Elective 1',              5, 'SEM_ELECT_GR'),
    ('TECH ELEC 2',   'Technical Elective 2',              5, 'SEM_ELECT_GR'),
    ('TECH ELEC 3',   'Technical Elective 3',             24, 'SEM_ELECT_GR');

-- -------------------------------------------------------------
-- COURSE
-- -------------------------------------------------------------
INSERT INTO COURSE (Code, Name, ECTS, Theoric, Application, Laboratory,
                    Language, DeliveryMode, LabCode, DeptCode,
                    CourseType, Content, ElectiveType, ElectiveGroup)
VALUES
    -- Yaşar University — Compulsory
    ('SE 1105',  'PROGRAMMING AND PROBLEM SOLVING I',    6, 3, 2, 0, 'English', 'On-Site', NULL,     'YAUN-SOFT-ENG', 'Compulsory',
     'Introduction to programming with emphasis on problem solving, algorithm design and introductory programming principles.', NULL, NULL),
    ('SE 1108',  'PROGRAMMING AND PROBLEM SOLVING II',   5, 3, 2, 0, 'English', 'On-Site', NULL,     'YAUN-SOFT-ENG', 'Compulsory',
     'Classes, Methods, Inheritance, Polymorphism, Interfaces, Exceptions, Simple File Processing.', NULL, NULL),
    ('COMP 1202','DISCRETE COMPUTATIONAL STRUCTURES',    6, 2, 2, 0, 'English', 'On-Site', NULL,     'YAUN-SOFT-ENG', 'Compulsory',
     'Set theory, functions, relations, graphs, trees.', NULL, NULL),
    ('COMP 3330','AUTOMATA THEORY',                       6, 3, 0, 0, 'English', 'On-Site', NULL,     'YAUN-SOFT-ENG', 'Compulsory',
     'Finite automata, regular expressions, regular languages, pushdown automata, context-free grammars, Turing machines, decidability.', NULL, NULL),
    ('SE 3317',  'SOFTWARE DESIGN AND ARCHITECTURE',     6, 2, 2, 0, 'English', 'On-Site', NULL,     'YAUN-SOFT-ENG', 'Compulsory',
     'Principals behind software design patterns and architectures, and their application in constructing software components.', NULL, NULL),
    ('SE 2230',  'DATABASE SYSTEMS',                      6, 2, 2, 0, 'English', 'On-Site', NULL,     'YAUN-SOFT-ENG', 'Compulsory',
     'Relational model, entity-relationship model, normalization, basic and advanced SQL, constraints, views, triggers, indexes, ACID properties.', NULL, NULL),
    -- Yaşar University — Elective (Pool)
    ('ANE 0301',  'BASIC VISUAL EFFECT I',               5, 2, 2, 0, 'English', 'On-Site', NULL,     'YAUN-SOFT-ENG', 'Elective',
     'Visual effects and compositing techniques demonstrated from class projects.', 'Pool Elective', 'UNV ELECT SE'),
    ('SOFL 1611', 'GERMAN I',                             4, 4, 0, 0, 'English', 'On-Site', NULL,     'YAUN-SOFT-ENG', 'Elective',
     'A1-level German communication skills.', 'Pool Elective', 'UNV ELECT SE'),
    ('UFND 5020', 'ETHIC CULTURE',                        2, 2, 0, 0, 'English', 'On-Site', NULL,     'YAUN-SOFT-ENG', 'Elective',
     'Ethics awareness and behavioral skills for a quality lifestyle.', 'Pool Elective', 'UNV ELECT SE'),
    ('COMP 4312', 'THEORY OF COMPUTATION',                6, 3, 0, 0, 'English', 'On-Site', NULL,     'YAUN-SOFT-ENG', 'Elective',
     'Abstract automata, finite state machines, push-down automata, Turing machines, formal languages, computability.', 'Pool Elective', 'ELECT SE A'),
    ('EEE 4515',  'BIOMEDICAL IMAGING',                   6, 3, 0, 0, 'English', 'On-Site', NULL,     'YAUN-SOFT-ENG', 'Elective',
     'Fundamentals of medical imaging: projection radiography, CT, nuclear medicine, ultrasound, MRI.', 'Pool Elective', 'ELECT SE B'),
    -- Hacettepe University — Compulsory
    ('BBM101', 'INTRODUCTION TO PROGRAMMING I',          6, 3, 0, 0, 'English', 'On-Site', 'BBM103', 'HAUN-AI-ENG',   'Compulsory',
     'Control flow, functions, lists, file operations, basic data structures, recursion, memory management.', NULL, NULL),
    ('BBM103', 'INTRODUCTION TO PROGRAMMING LAB I',      4, 0, 2, 0, 'English', 'On-Site', NULL,     'HAUN-AI-ENG',   'Compulsory',
     'Practical reinforcement of BBM101 programming topics.', NULL, NULL),
    ('BBM102', 'INTRODUCTION TO PROGRAMMING II',         8, 3, 0, 0, 'English', 'On-Site', 'BBM104', 'HAUN-AI-ENG',   'Compulsory',
     'Fundamentals of object-oriented programming.', NULL, NULL),
    ('BBM104', 'INTRODUCTION TO PROGRAMMING LAB II',     4, 0, 2, 0, 'English', 'On-Site', NULL,     'HAUN-AI-ENG',   'Compulsory',
     'Practical reinforcement of BBM102 OOP topics.', NULL, NULL),
    ('AIN312', 'FORMAL LANGUAGES AND AUTOMATA THEORY',  6, 3, 0, 0, 'English', 'On-Site', NULL,     'HAUN-AI-ENG',   'Compulsory',
     'Automata theory, deterministic and nondeterministic finite automata, regular languages.', NULL, NULL),
    ('AIN211', 'PRINCIPLES OF ARTIFICIAL INTELLIGENCE',  6, 3, 2, 0, 'English', 'On-Site', NULL,     'HAUN-AI-ENG',   'Compulsory',
     'Problem-solving agents, search algorithms, constraint satisfaction, logic, inference.', NULL, NULL),
    -- Hacettepe University — Elective (Pool)
    ('EKO115',  'GENERAL ECONOMY',                       4, 3, 0, 0, 'English',  NULL,      NULL,     'HAUN-AI-ENG',   'Elective',
     NULL, 'Pool Elective', 'NON TEC'),
    ('AIN422',  'DEEP LEARNING LABORATORY',              4, 0, 2, 0, 'English', 'On-Site', NULL,     'HAUN-AI-ENG',   'Elective',
     'Neural networks, backpropagation, CNN, RNN, reinforcement learning, GANs.', 'Pool Elective', 'AIN LAB'),
    ('AIN411',  'INTRODUCTION TO BIOINFORMATICS',        6, 3, 0, 0, 'English', 'On-Site', NULL,     'HAUN-AI-ENG',   'Elective',
     'Molecular biology fundamentals, DNA/protein sequence analysis, phylogenetics, gene expression.', 'Pool Elective', 'AIN NO LAB'),
    ('AIN420',  'INTRODUCTION TO DEEP LEARNING',         6, 3, 0, 0, 'English', 'On-Site', 'AIN422', 'HAUN-AI-ENG',   'Elective',
     'Neural networks, supervised/unsupervised deep learning, CNN, RNN, reinforcement learning.', 'Pool Elective', 'AIN WITH LAB'),
    ('BBM486',  'DESIGN PATTERNS',                       3, 3, 0, 0, 'English', 'On-Site', NULL,     'HAUN-AI-ENG',   'Elective',
     'Software design patterns in an applicable way.', 'Pool Elective', 'BBM'),
    -- Çukurova University — Compulsory
    ('CEN111', 'ALGORITHMS AND PROGRAMMING I',           4, 4, 0, 0, 'English', 'On-Site', 'CEN113', 'CUUN-COMP-ENG', 'Compulsory',
     'Problem solving fundamentals, algorithm design, programming basics, control structures, modular programming.', NULL, NULL),
    ('CEN113', 'ALGORITHMS AND PROGRAMMING LAB I',       2, 0, 2, 0, 'English', 'On-Site', NULL,     'CUUN-COMP-ENG', 'Compulsory',
     'Implementation of software from CEN111.', NULL, NULL),
    ('CEN116', 'ALGORITHMS AND PROGRAMMING II',          4, 3, 0, 0, 'English', 'On-Site', 'CEN118', 'CUUN-COMP-ENG', 'Compulsory',
     'C programming, data types, arrays, recursion, sorting, searching, dynamic variables, linked lists.', NULL, NULL),
    ('CEN118', 'ALGORITHMS AND PROGRAMMING LAB II',      2, 0, 2, 0, 'English', 'On-Site', NULL,     'CUUN-COMP-ENG', 'Compulsory',
     'Implementation of software from CEN116.', NULL, NULL),
    ('CEN343', 'THEORY OF COMPUTATION',                   5, 3, 0, 0, 'English', 'On-Site', NULL,     'CUUN-COMP-ENG', 'Compulsory',
     'Chomsky hierarchy, regular languages, context-free languages, Turing machines, decidability, P and NP.', NULL, NULL),
    ('CEN202', 'PROGRAMMING LANGUAGES',                   6, 3, 0, 0, 'English', 'On-Site', NULL,     'CUUN-COMP-ENG', 'Compulsory',
     'Basic programming knowledge and language paradigms.', NULL, NULL),
    ('CEN301', 'DATA MANAGEMENT AND FILE STRUCTURES',    6, 3, 0, 0, 'English', 'On-Site', NULL,     'CUUN-COMP-ENG', 'Compulsory',
     'Data storage, indexing methods, B+ trees, hash indexes, external sorting, ER model, big data concepts.', NULL, NULL),
    -- Çukurova University — Elective (Semester)
    ('CEN311', 'LINEAR SYSTEMS',                          5, 3, 0, 0, 'English', 'On-Site', NULL,     'CUUN-COMP-ENG', 'Elective',
     'Fourier series/transforms, transfer functions, transient/steady-state response, stability, convolution.', 'Semester Elective', 'TECH ELEC 1'),
    ('CEN312', 'COMPUTER GRAPHICS',                       5, 3, 0, 0, 'English', 'On-Site', NULL,     'CUUN-COMP-ENG', 'Elective',
     '2D/3D graphics techniques, OpenGL, modelling, illumination, shading, texture mapping.', 'Semester Elective', 'TECH ELEC 2'),
    ('CEN405', 'INTRODUCTION TO ROBOTICS',                6, 3, 0, 0, 'English', 'On-Site', NULL,     'CUUN-COMP-ENG', 'Elective',
     'General concepts, transformations, kinematics, Jacobian, orbit planning.', 'Semester Elective', 'TECH ELEC 3'),
    -- Çukurova University — Elective (Pool)
    ('SD0367', 'EXAMINATIONS ON MODERN TURKISH LITERATURE I', 3, 2, 0, 0, 'Turkish', 'On-Site', NULL, 'CUUN-COMP-ENG', 'Elective',
     'Modern Turkish poetry from Tanzimat to the Republican period.', 'Pool Elective', 'NFE'),
    ('SD0499', 'IMPORTANCE OF INDUSTRIAL RAW MATERIALS IN OUR LIFE', 3, 2, 0, 0, 'Turkish', 'On-Site', NULL, 'CUUN-COMP-ENG', 'Elective',
     'Mineral deposits, geological and chemical events, alterations.', 'Pool Elective', 'NFE'),
    ('SD0534', 'CREATIVE WRITING',                        3, 2, 0, 0, 'Turkish', 'On-Site', NULL,     'CUUN-COMP-ENG', 'Elective',
     'Personal essay, academic essay, fiction, free writing, grammar, poem.', 'Pool Elective', 'NFE');

-- -------------------------------------------------------------
-- SECTION
-- -------------------------------------------------------------
INSERT INTO SECTION (SectionCode, SemPeriod, Year, CourseCode, CoordinatorId, AssistantId)
VALUES
    -- Çukurova
    ('CEN111 S',     'FALL',   2025, 'CEN111',  41, NULL),
    ('CEN113 S',     'FALL',   2025, 'CEN113',  41, NULL),
    ('CEN116 S',     'SPRING', 2025, 'CEN116',  41, NULL),
    ('CEN118 S',     'SPRING', 2025, 'CEN118',  41, NULL),
    ('CEN343 S',     'FALL',   2025, 'CEN343',  24, NULL),
    ('CEN202 S',     'SPRING', 2025, 'CEN202',  16, NULL),
    ('CEN301 S',     'FALL',   2025, 'CEN301',  42, NULL),
    ('CEN311 S',     'FALL',   2025, 'CEN311',  43, NULL),
    ('CEN312 S',     'SPRING', 2025, 'CEN312',  16, NULL),
    ('CEN405 S',     'FALL',   2025, 'CEN405',  43, NULL),
    ('SD0367 S',     'FALL',   2025, 'SD0367',  44, NULL),
    ('SD0499 SF',    'FALL',   2025, 'SD0499',  45, NULL),
    ('SD0499 SS',    'SPRING', 2025, 'SD0499',  45, NULL),
    ('SD0534 S',     'SPRING', 2025, 'SD0534',  46, NULL),
    -- Hacettepe
    ('BBM101 S',     'FALL',   2025, 'BBM101',  NULL, NULL),
    ('BBM103 S',     'FALL',   2025, 'BBM103',  NULL, NULL),
    ('BBM102 S',     'FALL',   2025, 'BBM102',  NULL, NULL),
    ('BBM104 S',     'FALL',   2025, 'BBM104',  NULL, NULL),
    ('EKO115 SF',    'FALL',   2025, 'EKO115',  NULL, NULL),
    ('EKO115 SS',    'SPRING', 2025, 'EKO115',  NULL, NULL),
    ('AIN422 SF',    'FALL',   2025, 'AIN422',  NULL, NULL),
    ('AIN422 SS',    'SPRING', 2025, 'AIN422',  NULL, NULL),
    ('AIN411 S',     'FALL',   2025, 'AIN411',  NULL, NULL),
    ('AIN420 SF',    'FALL',   2025, 'AIN420',  NULL, NULL),
    ('AIN420 SS',    'SPRING', 2025, 'AIN420',  NULL, NULL),
    ('BBM486 S',     'FALL',   2025, 'BBM486',  NULL, NULL),
    ('AIN312 S',     'SPRING', 2025, 'AIN312',  NULL, NULL),
    ('AIN211 S',     'SPRING', 2025, 'AIN211',  NULL, NULL),
    -- Yaşar
    ('SE 1105 S',    'FALL',   2025, 'SE 1105',   1, 2),
    ('SE 1108 S',    'SPRING', 2025, 'SE 1108',   1, NULL),
    ('COMP 1202 S',  'FALL',   2025, 'COMP 1202', 31, NULL),
    ('COMP 3330 S',  'FALL',   2025, 'COMP 3330', NULL, NULL),
    ('SE 3317 S',    'FALL',   2025, 'SE 3317',   34, NULL),
    ('SE 2230 S',    'FALL',   2025, 'SE 2230',   33, NULL),
    ('ANE 0301 SF',  'FALL',   2025, 'ANE 0301',  36, NULL),
    ('ANE 0301 SS',  'SPRING', 2025, 'ANE 0301',  36, NULL),
    ('SOFL 1611 SF', 'FALL',   2025, 'SOFL 1611', 37, NULL),
    ('SOFL 1611 SS', 'SPRING', 2025, 'SOFL 1611', 37, NULL),
    ('UFND 5020 SF', 'FALL',   2025, 'UFND 5020',  6, NULL),
    ('UFND 5020 SS', 'SPRING', 2025, 'UFND 5020',  6, NULL),
    ('COMP 4312 SF', 'FALL',   2025, 'COMP 4312', 40, NULL),
    ('COMP 4312 SS', 'SPRING', 2025, 'COMP 4312', 40, NULL),
    ('EEE 4515 S',   'SPRING', 2025, 'EEE 4515',   8, NULL);

-- -------------------------------------------------------------
-- TEACHES
-- -------------------------------------------------------------
INSERT INTO TEACHES (SectionCode, InstructorId)
VALUES
    ('CEN111 S',     14), ('CEN113 S',     15), ('CEN116 S',     16),
    ('CEN118 S',     17), ('CEN343 S',     18), ('CEN202 S',     41),
    ('CEN301 S',     42), ('CEN311 S',     43), ('CEN312 S',     44),
    ('CEN405 S',     45), ('SD0367 S',     46), ('SD0499 SF',    44),
    ('SD0499 SS',    44), ('SD0534 S',     46),
    ('BBM101 S',     10), ('BBM103 S',     10), ('BBM102 S',     11),
    ('BBM104 S',     11), ('EKO115 SF',    12), ('EKO115 SS',    12),
    ('AIN422 SF',    13), ('AIN422 SS',    13), ('AIN411 S',     25),
    ('AIN420 SF',    26), ('AIN420 SS',    26), ('BBM486 S',     27),
    ('AIN312 S',     28), ('AIN211 S',     29),
    ('SE 1105 S',     3), ('SE 1108 S',    4),  ('COMP 1202 S',  8),
    ('COMP 3330 S',   9), ('SE 3317 S',    31), ('SE 2230 S',    32),
    ('ANE 0301 SF',  36), ('ANE 0301 SS',  36), ('SOFL 1611 SF', 37),
    ('SOFL 1611 SS', 37), ('UFND 5020 SF',  6), ('UFND 5020 SS',  6),
    ('COMP 4312 SF', 40), ('COMP 4312 SS', 40), ('EEE 4515 S',   8);

-- -------------------------------------------------------------
-- CURRICULUM_ITEM
-- (sub-tables populated automatically via trigger)
-- -------------------------------------------------------------
INSERT INTO CURRICULUM_ITEM (DeptCode, Semester, CurriculumItemType, GroupOrCourseCode)
VALUES
    -- Yaşar
    ('YAUN-SOFT-ENG', 1, 'COMPUL',  'SE 1105'),
    ('YAUN-SOFT-ENG', 2, 'COMPUL',  'SE 1108'),
    ('YAUN-SOFT-ENG', 3, 'COMPUL',  'COMP 1202'),
    ('YAUN-SOFT-ENG', 5, 'COMPUL',  'COMP 3330'),
    ('YAUN-SOFT-ENG', 5, 'COMPUL',  'SE 3317'),
    ('YAUN-SOFT-ENG', 4, 'COMPUL',  'SE 2230'),
    ('YAUN-SOFT-ENG', 5, 'EL-POOL', 'UNV ELECT SE'),
    ('YAUN-SOFT-ENG', 8, 'EL-POOL', 'UNV ELECT SE'),
    ('YAUN-SOFT-ENG', 6, 'EL-POOL', 'ELECT SE A'),
    ('YAUN-SOFT-ENG', 7, 'EL-POOL', 'ELECT SE A'),
    ('YAUN-SOFT-ENG', 7, 'EL-POOL', 'ELECT SE A'),
    ('YAUN-SOFT-ENG', 6, 'EL-POOL', 'ELECT SE A'),
    ('YAUN-SOFT-ENG', 8, 'EL-POOL', 'ELECT SE B'),
    ('YAUN-SOFT-ENG', 8, 'EL-POOL', 'ELECT SE B'),
    -- Çukurova
    ('CUUN-COMP-ENG', 1, 'COMPUL',  'CEN111'),
    ('CUUN-COMP-ENG', 1, 'COMPUL',  'CEN113'),
    ('CUUN-COMP-ENG', 2, 'COMPUL',  'CEN116'),
    ('CUUN-COMP-ENG', 2, 'COMPUL',  'CEN118'),
    ('CUUN-COMP-ENG', 5, 'COMPUL',  'CEN343'),
    ('CUUN-COMP-ENG', 4, 'COMPUL',  'CEN202'),
    ('CUUN-COMP-ENG', 5, 'COMPUL',  'CEN301'),
    ('CUUN-COMP-ENG', 5, 'EL-SEM',  'TECH ELEC 1'),
    ('CUUN-COMP-ENG', 6, 'EL-SEM',  'TECH ELEC 2'),
    ('CUUN-COMP-ENG', 7, 'EL-SEM',  'TECH ELEC 3'),
    ('CUUN-COMP-ENG', 5, 'EL-POOL', 'NFE'),
    ('CUUN-COMP-ENG', 6, 'EL-POOL', 'NFE'),
    ('CUUN-COMP-ENG', 7, 'EL-POOL', 'NFE'),
    ('CUUN-COMP-ENG', 8, 'EL-POOL', 'NFE'),
    -- Hacettepe
    ('HAUN-AI-ENG', 1, 'COMPUL',  'BBM101'),
    ('HAUN-AI-ENG', 1, 'COMPUL',  'BBM103'),
    ('HAUN-AI-ENG', 2, 'COMPUL',  'BBM102'),
    ('HAUN-AI-ENG', 2, 'COMPUL',  'BBM104'),
    ('HAUN-AI-ENG', 6, 'COMPUL',  'AIN312'),
    ('HAUN-AI-ENG', 4, 'COMPUL',  'AIN211'),
    ('HAUN-AI-ENG', 4, 'EL-POOL', 'NON TEC'),
    ('HAUN-AI-ENG', 5, 'EL-POOL', 'NON TEC'),
    ('HAUN-AI-ENG', 6, 'EL-POOL', 'NON TEC'),
    ('HAUN-AI-ENG', 7, 'EL-POOL', 'NON TEC'),
    ('HAUN-AI-ENG', 8, 'EL-POOL', 'NON TEC'),
    ('HAUN-AI-ENG', 5, 'EL-POOL', 'AIN NO LAB'),
    ('HAUN-AI-ENG', 7, 'EL-POOL', 'AIN NO LAB'),
    ('HAUN-AI-ENG', 6, 'EL-POOL', 'AIN WITH LAB'),
    ('HAUN-AI-ENG', 6, 'EL-POOL', 'AIN WITH LAB'),
    ('HAUN-AI-ENG', 7, 'EL-POOL', 'AIN WITH LAB'),
    ('HAUN-AI-ENG', 8, 'EL-POOL', 'AIN WITH LAB'),
    ('HAUN-AI-ENG', 8, 'EL-POOL', 'AIN WITH LAB'),
    ('HAUN-AI-ENG', 6, 'EL-POOL', 'AIN LAB'),
    ('HAUN-AI-ENG', 6, 'EL-POOL', 'AIN LAB'),
    ('HAUN-AI-ENG', 7, 'EL-POOL', 'AIN LAB'),
    ('HAUN-AI-ENG', 8, 'EL-POOL', 'AIN LAB'),
    ('HAUN-AI-ENG', 8, 'EL-POOL', 'AIN LAB'),
    ('HAUN-AI-ENG', 5, 'EL-POOL', 'BBM');

-- -------------------------------------------------------------
-- PREREQUISITE
-- -------------------------------------------------------------
INSERT INTO PREREQUISITE (CourseCode, PrerequisiteCode)
VALUES
    ('SE 1108',  'SE 1105'),
    ('COMP 3330','COMP 1202'),
    ('SE 3317',  'SE 1108'),
    ('BBM101',   'BBM103'),
    ('BBM103',   'BBM101'),
    ('BBM102',   'BBM104'),
    ('BBM102',   'BBM103'),
    ('BBM102',   'BBM101'),
    ('BBM104',   'BBM102'),
    ('BBM104',   'BBM103'),
    ('BBM104',   'BBM101'),
    ('AIN422',   'BBM102'),
    ('AIN422',   'BBM104'),
    ('AIN422',   'AIN420'),
    ('AIN411',   'BBM102'),
    ('AIN411',   'BBM104'),
    ('AIN420',   'BBM102'),
    ('AIN420',   'BBM104'),
    ('AIN420',   'AIN422'),
    ('AIN211',   'BBM101'),
    ('AIN211',   'BBM103'),
    ('BBM486',   'BBM102'),
    ('BBM486',   'BBM104');

-- -------------------------------------------------------------
-- MATCHES
-- -------------------------------------------------------------
INSERT INTO MATCHES (DeptCode, ItemCode, CourseCode)
VALUES
    -- Yaşar Sem 1 matches
    ('YAUN-SOFT-ENG', 1, 'CEN111'), ('YAUN-SOFT-ENG', 1, 'BBM101'),
    -- Yaşar Sem 2 matches
    ('YAUN-SOFT-ENG', 2, 'CEN116'), ('YAUN-SOFT-ENG', 2, 'BBM102'),
    -- Yaşar Sem 4 matches (Automata)
    ('YAUN-SOFT-ENG', 4, 'CEN343'), ('YAUN-SOFT-ENG', 4, 'AIN312'),
    -- Yaşar DB match
    ('YAUN-SOFT-ENG', 6, 'CEN301'),
    -- Yaşar elective pool matches
    ('YAUN-SOFT-ENG', 7, 'SD0367'), ('YAUN-SOFT-ENG', 7, 'SD0499'),
    ('YAUN-SOFT-ENG', 7, 'SD0534'), ('YAUN-SOFT-ENG', 7, 'EKO115'),
    ('YAUN-SOFT-ENG', 8, 'SD0367'), ('YAUN-SOFT-ENG', 8, 'SD0499'),
    ('YAUN-SOFT-ENG', 8, 'SD0534'), ('YAUN-SOFT-ENG', 8, 'EKO115'),
    -- Çukurova Sem 1 matches
    ('CUUN-COMP-ENG', 15, 'BBM101'), ('CUUN-COMP-ENG', 15, 'SE 1105'),
    -- Çukurova Sem 2 matches
    ('CUUN-COMP-ENG', 17, 'BBM102'), ('CUUN-COMP-ENG', 17, 'SE 1108'),
    -- Çukurova Automata match
    ('CUUN-COMP-ENG', 19, 'AIN312'), ('CUUN-COMP-ENG', 19, 'COMP 3330'),
    -- Çukurova DB match
    ('CUUN-COMP-ENG', 21, 'SE 2230'),
    -- Hacettepe Sem 1 matches
    ('HAUN-AI-ENG', 29, 'SE 1105'), ('HAUN-AI-ENG', 29, 'CEN111'),
    -- Hacettepe Sem 2 matches
    ('HAUN-AI-ENG', 31, 'SE 1108'), ('HAUN-AI-ENG', 31, 'CEN116'),
    -- Hacettepe Automata match
    ('HAUN-AI-ENG', 33, 'COMP 3330'), ('HAUN-AI-ENG', 33, 'CEN343');
