--CREATE DATABASE LibraryERP;
--GO

USE LibraryERP;
GO


/* =========================================================
   1. PEOPLE
   ========================================================= */

CREATE TABLE People
(
    PersonID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Gender CHAR(1) NOT NULL,
    DateOfBirth DATE NOT NULL,
    ImagePath NVARCHAR(255),
    Country NVARCHAR(50) NOT NULL,
    Address NVARCHAR(200) NOT NULL,
    PhoneNumber NVARCHAR(20),
    Email NVARCHAR(100)
);
GO


/* =========================================================
   2. ROLES
   ========================================================= */

CREATE TABLE Roles
(
    RoleID INT IDENTITY(1,1) PRIMARY KEY,
    RoleName NVARCHAR(50) NOT NULL UNIQUE
);
GO


/* =========================================================
   3. USERS
   ========================================================= */

CREATE TABLE Users
(
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    PersonID INT NOT NULL UNIQUE,
    RoleID INT NOT NULL,
    PasswordHash NVARCHAR(255) NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1,

    FOREIGN KEY (PersonID)
        REFERENCES People(PersonID),

    FOREIGN KEY (RoleID)
        REFERENCES Roles(RoleID)
);
GO


/* =========================================================
   4. AUTHORS
   ========================================================= */

CREATE TABLE Authors
(
    AuthorID INT IDENTITY(1,1) PRIMARY KEY,
    PersonID INT NOT NULL UNIQUE,
    Biography NVARCHAR(300),
    Website NVARCHAR(100),

    FOREIGN KEY (PersonID)
        REFERENCES People(PersonID)
);
GO


/* =========================================================
   5. CATEGORIES
   ========================================================= */

CREATE TABLE Categories
(
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(50) NOT NULL UNIQUE,
    Description NVARCHAR(255)
);
GO


/* =========================================================
   6. LANGUAGES
   ========================================================= */

CREATE TABLE Languages
(
    LanguageID INT IDENTITY(1,1) PRIMARY KEY,
    LanguageName NVARCHAR(50) NOT NULL UNIQUE,
    LanguageCode NVARCHAR(10) UNIQUE
);
GO


/* =========================================================
   7. BOOKS
   ========================================================= */

CREATE TABLE Books
(
    BookID INT IDENTITY(1,1) PRIMARY KEY,
    LanguageID INT NOT NULL,
    CategoryID INT NOT NULL,
    Title NVARCHAR(200) NOT NULL,
    ISBN NVARCHAR(50) UNIQUE,
    ImagePath NVARCHAR(255),
    PublicationDate DATE NOT NULL,
    AdditionalDetails NVARCHAR(1000),

    FOREIGN KEY (LanguageID)
        REFERENCES Languages(LanguageID),

    FOREIGN KEY (CategoryID)
        REFERENCES Categories(CategoryID)
);
GO


/* =========================================================
   8. BOOK AUTHORS
   ========================================================= */

CREATE TABLE BookAuthors
(
    BookID INT NOT NULL,
    AuthorID INT NOT NULL,

    PRIMARY KEY (BookID, AuthorID),

    FOREIGN KEY (BookID)
        REFERENCES Books(BookID),

    FOREIGN KEY (AuthorID)
        REFERENCES Authors(AuthorID)
);
GO


/* =========================================================
   9. BOOK COPIES
   ========================================================= */

CREATE TABLE BookCopies
(
    CopyID INT IDENTITY(1,1) PRIMARY KEY,
    BookID INT NOT NULL,
    Barcode NVARCHAR(50) NOT NULL UNIQUE,
    AvailabilityStatus NVARCHAR(50) NOT NULL DEFAULT 'Available',

    FOREIGN KEY (BookID)
        REFERENCES Books(BookID)
);
GO


/* =========================================================
   10. SUPPLIERS
   ========================================================= */

CREATE TABLE Suppliers
(
    SupplierID INT IDENTITY(1,1) PRIMARY KEY,
    SupplierName NVARCHAR(150) NOT NULL,
    ContactPerson NVARCHAR(100),
    Email NVARCHAR(100),
    PhoneNumber NVARCHAR(20),
    Address NVARCHAR(200),
    Website NVARCHAR(100),
    IsActive BIT NOT NULL DEFAULT 1
);
GO


/* =========================================================
   11. PURCHASE ORDERS
   ========================================================= */

CREATE TABLE PurchaseOrders
(
    PurchaseOrderID INT IDENTITY(1,1) PRIMARY KEY,
    SupplierID INT NOT NULL,
    OrderDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    ExpectedDate DATETIME2,
    Status NVARCHAR(50) NOT NULL DEFAULT 'Pending',

    FOREIGN KEY (SupplierID)
        REFERENCES Suppliers(SupplierID)
);
GO


/* =========================================================
   12. PURCHASE DETAILS
   ========================================================= */

CREATE TABLE PurchaseDetails
(
    PurchaseDetailsID INT IDENTITY(1,1) PRIMARY KEY,
    PurchaseOrderID INT NOT NULL,
    BookID INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    UnitPrice DECIMAL(10,2) NOT NULL CHECK (UnitPrice >= 0),
    TotalAmount DECIMAL(10,2) NOT NULL CHECK (TotalAmount >= 0),

    FOREIGN KEY (PurchaseOrderID)
        REFERENCES PurchaseOrders(PurchaseOrderID),

    FOREIGN KEY (BookID)
        REFERENCES Books(BookID)
);
GO


/* =========================================================
   13. MEMBERSHIP TYPES
   ========================================================= */

CREATE TABLE MembershipTypes
(
    MembershipTypeID INT IDENTITY(1,1) PRIMARY KEY,
    TypeName NVARCHAR(50) NOT NULL UNIQUE,
    LoanDurationDays INT NOT NULL CHECK (LoanDurationDays > 0),
    AnnualFee DECIMAL(10,2) NOT NULL CHECK (AnnualFee >= 0),
    IsActive BIT NOT NULL DEFAULT 1,
    Description NVARCHAR(255)
);
GO


/* =========================================================
   14. MEMBERS
   ========================================================= */

CREATE TABLE Members
(
    MemberID INT IDENTITY(1,1) PRIMARY KEY,
    PersonID INT NOT NULL UNIQUE,
    MembershipTypeID INT NOT NULL,
    LibraryCardNumber NVARCHAR(50) NOT NULL UNIQUE,
    RegistrationDate DATE NOT NULL,
    ExpirationDate DATE NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    Notes NVARCHAR(255),

    FOREIGN KEY (PersonID)
        REFERENCES People(PersonID),

    FOREIGN KEY (MembershipTypeID)
        REFERENCES MembershipTypes(MembershipTypeID),

    CHECK (ExpirationDate >= RegistrationDate)
);
GO


/* =========================================================
   15. BORROWING RECORDS
   ========================================================= */

CREATE TABLE BorrowingRecords
(
    BorrowingRecordID INT IDENTITY(1,1) PRIMARY KEY,
    MemberID INT NOT NULL,
    UserID INT NOT NULL,
    CopyID INT NOT NULL,
    BorrowingDate DATE NOT NULL,
    DueDate DATE NOT NULL,
    ActualReturnDate DATE NULL,

    FOREIGN KEY (MemberID)
        REFERENCES Members(MemberID),

    FOREIGN KEY (UserID)
        REFERENCES Users(UserID),

    FOREIGN KEY (CopyID)
        REFERENCES BookCopies(CopyID)
);
GO


/* =========================================================
   16. BOOK REQUESTS
   ========================================================= */

CREATE TABLE BookRequests
(
    BookRequestID INT IDENTITY(1,1) PRIMARY KEY,
    MemberID INT NOT NULL,
    RequestDate DATE NOT NULL DEFAULT GETDATE(),
    Reason NVARCHAR(255),
    RequestStatus NVARCHAR(50) NOT NULL DEFAULT 'Pending',
    RequestedTitle NVARCHAR(200) NOT NULL,
    RequestedAuthor NVARCHAR(100),
    ISBN NVARCHAR(50),

    FOREIGN KEY (MemberID)
        REFERENCES Members(MemberID)
);
GO


/* =========================================================
   17. LOST / DAMAGED BOOKS
   ========================================================= */

CREATE TABLE LostDamagedBooks
(
    IncidentID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    CopyID INT NOT NULL,
    BorrowingRecordID INT NOT NULL,
    IncidentType NVARCHAR(50) NOT NULL,
    IncidentDate DATE NOT NULL DEFAULT GETDATE(),
    Status NVARCHAR(50) NOT NULL DEFAULT 'Open',
    EstimatedCost DECIMAL(10,2) NOT NULL,
    ResolutionDate DATE NULL,

    FOREIGN KEY (CopyID)
        REFERENCES BookCopies(CopyID),

    FOREIGN KEY (UserID)
        REFERENCES Users(UserID),

    FOREIGN KEY (BorrowingRecordID)
        REFERENCES BorrowingRecords(BorrowingRecordID)
);
GO


/* =========================================================
   18. RESERVATIONS
   ========================================================= */

CREATE TABLE Reservations
(
    ReservationID INT IDENTITY(1,1) PRIMARY KEY,
    MemberID INT NOT NULL,
    BookID INT NOT NULL,
    ReservationDate DATE NOT NULL DEFAULT GETDATE(),
    ExpiryDate DATE NOT NULL,
    Status NVARCHAR(50) NOT NULL DEFAULT 'Pending',

    FOREIGN KEY (MemberID)
        REFERENCES Members(MemberID),

    FOREIGN KEY (BookID)
        REFERENCES Books(BookID)
);
GO


/* =========================================================
   19. FINES
   ========================================================= */

CREATE TABLE Fines
(
    FineID INT IDENTITY(1,1) PRIMARY KEY,
    MemberID INT NOT NULL,
    BorrowingRecordID INT NOT NULL,
    NumberOfLateDays INT NOT NULL CHECK (NumberOfLateDays > 0),
    FineAmount DECIMAL(10,2) NOT NULL CHECK (FineAmount >= 0),
    PaymentStatus NVARCHAR(50) NOT NULL DEFAULT 'Unpaid',

    FOREIGN KEY (MemberID)
        REFERENCES Members(MemberID),

    FOREIGN KEY (BorrowingRecordID)
        REFERENCES BorrowingRecords(BorrowingRecordID)
);
GO


/* =========================================================
   20. AUDIT LOGS
   ========================================================= */

CREATE TABLE AuditLogs
(
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    ActionType NVARCHAR(50) NOT NULL,
    TableName NVARCHAR(50) NOT NULL,
    RecordID INT NOT NULL,
    ActionDate DATETIME2 NOT NULL DEFAULT GETDATE(),

    FOREIGN KEY (UserID)
        REFERENCES Users(UserID)
);
GO


/* =========================================================
   21. SETTINGS
   ========================================================= */

CREATE TABLE Settings
(
    SettingID INT IDENTITY(1,1) PRIMARY KEY,
    DefaultBorrowDays INT NOT NULL,
    DefaultFinePerDay DECIMAL(10,2) NOT NULL
);
GO


INSERT INTO Roles (RoleName)
VALUES
('Administrator'),
('Library Manager'),
('Librarian'),
('Assistant Librarian'),
('Catalog Manager'),
('Inventory Manager'),
('IT Support');

INSERT INTO Users
(
    PersonID,
    RoleID,
    PasswordHash,
    IsActive
)
VALUES
(1, 1, '$2a$12$DemoHashForJamesWilson000000000000000000000000', 1),
(2, 3, '$2a$12$DemoHashForEmmaBrown000000000000000000000000', 1),
(3, 3, '$2a$12$DemoHashForLucasMartin000000000000000000000000', 1),
(4, 4, '$2a$12$DemoHashForSophiaTaylor00000000000000000000000', 1),
(5, 2, '$2a$12$DemoHashForDanielMiller00000000000000000000000', 1),
(6, 5, '$2a$12$DemoHashForOliviaAnderson000000000000000000000', 1),
(7, 6, '$2a$12$DemoHashForEthanGarcia000000000000000000000000', 1),
(8, 3, '$2a$12$DemoHashForCharlotteRossi0000000000000000000000', 1),
(9, 7, '$2a$12$DemoHashForMichaelKim00000000000000000000000000', 1),
(10, 4, '$2a$12$DemoHashForIsabellaSilva0000000000000000000000', 1);

INSERT INTO People
(
    FirstName,
    LastName,
    Gender,
    DateOfBirth,
    ImagePath,
    Country,
    Address,
    PhoneNumber,
    Email
)
VALUES
('James', 'Anderson', 'M', '1998-04-15', ' ', 'United States', '125 Oak Street, Boston', '+16175550101', 'james.anderson@example.com'),

('Emma', 'Williams', 'F', '2000-07-22', ' ', 'United Kingdom', '48 Baker Street, London', '+44205550102', 'emma.williams@example.com'),

('Lucas', 'Martin', 'M', '1997-11-08', ' ', 'France', '21 Rue Victor Hugo, Paris', '+3315550103', 'lucas.martin@example.com'),

('Sofia', 'Garcia', 'F', '1999-02-17', ' ', 'Spain', '35 Calle Mayor, Madrid', '+34915550104', 'sofia.garcia@example.com'),

('Liam', 'Murphy', 'M', '1996-09-30', ' ', 'Ireland', '12 River Road, Dublin', '+35315550105', 'liam.murphy@example.com'),

('Olivia', 'Taylor', 'F', '2001-01-12', ' ', 'Canada', '76 Maple Avenue, Toronto', '+14165550106', 'olivia.taylor@example.com'),

('Noah', 'Schmidt', 'M', '1995-06-25', ' ', 'Germany', '19 Berlin Street, Berlin', '+49305550107', 'noah.schmidt@example.com'),

('Mia', 'Rossi', 'F', '1998-12-03', ' ', 'Italy', '44 Via Roma, Milan', '+39025550108', 'mia.rossi@example.com'),

('Ethan', 'Johnson', 'M', '1999-05-19', ' ', 'Australia', '83 George Street, Sydney', '+6125550109', 'ethan.johnson@example.com'),

('Ava', 'Brown', 'F', '2000-10-27', ' ', 'New Zealand', '17 Queen Street, Auckland', '+6495550110', 'ava.brown@example.com'),

('Daniel', 'Silva', 'M', '1997-03-11', ' ', 'Brazil', '52 Avenida Paulista, Sao Paulo', '+55115550111', 'daniel.silva@example.com'),

('Isabella', 'Santos', 'F', '1999-08-14', ' ', 'Portugal', '28 Rua Augusta, Lisbon', '+351215550112', 'isabella.santos@example.com'),

('Alexander', 'Petrov', 'M', '1996-01-29', ' ', 'Russia', '15 Nevsky Avenue, Moscow', '+7495550113', 'alexander.petrov@example.com'),

('Anna', 'Kowalski', 'F', '2001-04-06', ' ', 'Poland', '63 Warsaw Road, Warsaw', '+48225550114', 'anna.kowalski@example.com'),

('William', 'Lee', 'M', '1998-06-18', ' ', 'South Korea', '91 Gangnam Road, Seoul', '+8225550115', 'william.lee@example.com'),

('Yuki', 'Tanaka', 'F', '2000-09-21', ' ', 'Japan', '37 Sakura Street, Tokyo', '+8135550116', 'yuki.tanaka@example.com'),

('Mateo', 'Hernandez', 'M', '1997-12-10', ' ', 'Mexico', '24 Reforma Avenue, Mexico City', '+5255550117', 'mateo.hernandez@example.com'),

('Amelia', 'Wilson', 'F', '1999-03-28', ' ', 'United Kingdom', '72 Oxford Road, Manchester', '+441615550118', 'amelia.wilson@example.com'),

('Benjamin', 'Miller', 'M', '1996-07-05', ' ', 'United States', '38 Pine Street, Chicago', '+13125550119', 'benjamin.miller@example.com'),

('Charlotte', 'Dubois', 'F', '2001-11-16', ' ', 'France', '16 Avenue de Lyon, Lyon', '+33478550120', 'charlotte.dubois@example.com'),

('Sebastian', 'Weber', 'M', '1998-02-09', ' ', 'Germany', '55 Munich Street, Munich', '+4989550121', 'sebastian.weber@example.com'),

('Emily', 'Clark', 'F', '2000-05-23', ' ', 'Canada', '41 King Street, Vancouver', '+16045550122', 'emily.clark@example.com'),

('Henry', 'Evans', 'M', '1997-10-02', ' ', 'Australia', '29 Collins Street, Melbourne', '+6135550123', 'henry.evans@example.com'),

('Sophie', 'Bennett', 'F', '1999-01-31', ' ', 'Ireland', '64 College Road, Cork', '+353215550124', 'sophie.bennett@example.com'),

('Gabriel', 'Costa', 'M', '1996-05-12', ' ', 'Brazil', '88 Copacabana Avenue, Rio de Janeiro', '+55215550125', 'gabriel.costa@example.com'),

('Marie', 'Laurent', 'F', '2001-08-07', ' ', 'France', '23 Rue Lafayette, Marseille', '+33491550126', 'marie.laurent@example.com'),

('David', 'Fischer', 'M', '1998-10-19', ' ', 'Switzerland', '47 Bahnhofstrasse, Zurich', '+41445550127', 'david.fischer@example.com'),

('Nora', 'Eriksson', 'F', '2000-03-15', ' ', 'Sweden', '31 Stockholm Road, Stockholm', '+4685550128', 'nora.eriksson@example.com'),

('Thomas', 'Nielsen', 'M', '1997-06-29', ' ', 'Denmark', '18 Copenhagen Street, Copenhagen', '+45325550129', 'thomas.nielsen@example.com'),

('Elena', 'Popescu', 'F', '1999-12-24', ' ', 'Romania', '42 Bucharest Avenue, Bucharest', '+40215550130', 'elena.popescu@example.com');
('James', 'Wilson', 'M', '1998-04-12', ' ', 'United States', '125 Main Street', '+12025550101', 'james.wilson@example.com'),

('Emma', 'Brown', 'F', '2000-08-25', ' ', 'United Kingdom', '42 Oxford Road', '+44205550102', 'emma.brown@example.com'),

('Lucas', 'Martin', 'M', '1997-11-03', ' ', 'France', '18 Rue Victor Hugo', '+3315550103', 'lucas.martin@example.com'),

('Sophia', 'Taylor', 'F', '1999-02-17', ' ', 'Canada', '75 King Street', '+14165550104', 'sophia.taylor@example.com'),

('Daniel', 'Miller', 'M', '1996-06-29', ' ', 'Germany', '31 Berlin Street', '+49305550105', 'daniel.miller@example.com'),

('Olivia', 'Anderson', 'F', '2001-09-14', ' ', 'Australia', '88 Sydney Road', '+6125550106', 'olivia.anderson@example.com'),

('Ethan', 'Garcia', 'M', '1995-12-08', ' ', 'Spain', '24 Madrid Avenue', '+34915550107', 'ethan.garcia@example.com'),

('Charlotte', 'Rossi', 'F', '1998-03-21', ' ', 'Italy', '16 Rome Street', '+39065550108', 'charlotte.rossi@example.com'),

('Michael', 'Kim', 'M', '2000-07-05', ' ', 'South Korea', '53 Seoul Avenue', '+8225550109', 'michael.kim@example.com'),

('Isabella', 'Silva', 'F', '1997-10-30', ' ', 'Portugal', '67 Lisbon Road', '+35121550110', 'isabella.silva@example.com');

INSERT INTO Authors
(
    PersonID,
    Biography,
    Website
)
VALUES
(1, 'American author known for writing contemporary fiction and technology-related essays.', 'https://jamesanderson.example.com'),

(2, 'British writer specializing in modern literature, short stories, and social commentary.', 'https://emmawilliams.example.com'),

(3, 'French novelist and essayist with a focus on philosophy, society, and contemporary life.', 'https://lucasmartin.example.com'),

(4, 'Spanish writer whose work explores family, culture, and modern European society.', 'https://sofiagarcia.example.com'),

(5, 'Irish writer and novelist known for contemporary fiction and historical storytelling.', 'https://liammurphy.example.com'),

(6, 'Canadian author specializing in educational books, science, and popular nonfiction.', 'https://oliviataylor.example.com'),

(7, 'German writer focused on history, technology, and European culture.', 'https://noahschmidt.example.com'),

(8, 'Italian novelist and literary writer inspired by European history and everyday life.', 'https://miarossi.example.com'),

(9, 'Australian author writing fiction and environmental literature inspired by nature.', 'https://ethanjohnson.example.com'),

(10, 'New Zealand writer specializing in adventure stories and young adult fiction.', 'https://avabrown.example.com'),

(11, 'Brazilian author interested in technology, business, and contemporary society.', 'https://danielsilva.example.com'),

(12, 'Portuguese writer known for historical fiction and cultural literature.', 'https://isabellasantos.example.com'),

(13, 'Russian novelist and essayist interested in history, philosophy, and human relationships.', 'https://alexanderpetrov.example.com'),

(14, 'Polish author specializing in mystery novels and contemporary fiction.', 'https://annakowalski.example.com'),

(15, 'South Korean writer focusing on technology, education, and modern Asian society.', 'https://williamlee.example.com'),

(16, 'Japanese author writing contemporary fiction influenced by Japanese culture and traditions.', 'https://yukitanaka.example.com'),

(17, 'Mexican writer specializing in cultural fiction, history, and Latin American literature.', 'https://mateohernandez.example.com'),

(18, 'British novelist interested in science fiction, technology, and future societies.', 'https://ameliawilson.example.com'),

(19, 'American nonfiction author specializing in business, leadership, and personal development.', 'https://benjaminmiller.example.com'),

(20, 'French writer specializing in romance, contemporary fiction, and European culture.', 'https://marielaurent.example.com');


INSERT INTO Categories
(
    CategoryName,
    Description
)
VALUES
('Fiction', 'Imaginary stories and novels created from the authors imagination.'),

('Science Fiction', 'Stories involving advanced science, technology, space, or futuristic societies.'),

('Fantasy', 'Stories involving magic, mythical creatures, and imaginary worlds.'),

('Mystery', 'Stories focused on solving crimes, mysteries, or unexplained events.'),

('Thriller', 'Suspenseful stories involving danger, tension, and unexpected events.'),

('Romance', 'Stories primarily focused on romantic relationships and emotional connections.'),

('Historical Fiction', 'Fictional stories set during real historical periods and events.'),

('Biography', 'Books describing the life and experiences of real people.'),

('Autobiography', 'Books in which authors describe their own lives and experiences.'),

('History', 'Books covering historical events, civilizations, people, and periods.'),

('Science', 'Books covering scientific concepts, discoveries, research, and theories.'),

('Technology', 'Books about computers, software, engineering, and modern technology.'),

('Programming', 'Books focused on programming languages, algorithms, and software development.'),

('Business', 'Books about business, entrepreneurship, management, and organizations.'),

('Economics', 'Books covering economic theories, markets, finance, and economic systems.'),

('Psychology', 'Books about human behavior, cognition, emotions, and mental processes.'),

('Philosophy', 'Books exploring knowledge, existence, ethics, logic, and philosophical ideas.'),

('Education', 'Books related to teaching, learning, academic subjects, and educational methods.'),

('Self-Development', 'Books focused on personal growth, productivity, habits, and life skills.'),

('Children', 'Books written primarily for children and young readers.');


INSERT INTO Languages
(
    LanguageName,
    LanguageCode
)
VALUES
('English', 'EN'),
('French', 'FR'),
('Spanish', 'ES'),
('German', 'DE'),
('Italian', 'IT'),
('Portuguese', 'PT'),
('Arabic', 'AR'),
('Japanese', 'JA'),
('Chinese', 'ZH'),
('Korean', 'KO'),
('Russian', 'RU'),
('Dutch', 'NL'),
('Turkish', 'TR'),
('Swedish', 'SV'),
('Norwegian', 'NO'),
('Danish', 'DA'),
('Polish', 'PL'),
('Greek', 'EL'),
('Hindi', 'HI'),
('Ukrainian', 'UK');


INSERT INTO Books
(
    LanguageID,
    CategoryID,
    Title,
    ISBN,
    ImagePath,
    PublicationDate,
    AdditionalDetails
)
VALUES
(1, 13, 'Mastering Modern Programming', '9780000000001', ' ', '2020-03-15',
 'A practical introduction to modern programming concepts and software development.'),

(2, 1, 'The Silent Garden', '9780000000002', ' ', '2019-06-20',
 'A contemporary fiction novel about family, friendship, and difficult choices.'),

(3, 2, 'Beyond the Red Planet', '9780000000003', ' ', '2021-09-10',
 'A science fiction adventure following a mission to establish a human colony on Mars.'),

(4, 3, 'The Kingdom of Shadows', '9780000000004', ' ', '2018-11-05',
 'A fantasy novel about an ancient kingdom, magical powers, and a young hero.'),

(5, 4, 'The Missing Letter', '9780000000005', ' ', '2022-01-18',
 'A mystery novel centered around a missing letter and an unexplained disappearance.'),

(6, 5, 'The Last Witness', '9780000000006', ' ', '2020-08-12',
 'A suspenseful thriller involving an investigation and a dangerous secret.'),

(7, 6, 'Letters Across Berlin', '9780000000007', ' ', '2017-04-22',
 'A romantic story about two people separated by distance and reunited years later.'),

(8, 7, 'The Roman Merchant', '9780000000008', ' ', '2016-10-14',
 'Historical fiction following a merchant during the final years of the Roman Empire.'),

(9, 8, 'The Life of a Pioneer', '9780000000009', ' ', '2015-05-30',
 'The biography of an influential pioneer whose work changed modern society.'),

(10, 9, 'My Journey Through Japan', '9780000000010', ' ', '2021-02-11',
 'An autobiography describing personal experiences, challenges, and achievements.'),

(11, 10, 'A History of Modern Civilizations', '9780000000011', ' ', '2014-09-25',
 'An overview of major civilizations and important historical developments.'),

(12, 11, 'Understanding the Universe', '9780000000012', ' ', '2023-03-07',
 'An accessible introduction to astronomy, physics, and the structure of the universe.'),

(13, 12, 'The Future of Technology', '9780000000013', ' ', '2022-07-19',
 'An exploration of emerging technologies and their impact on modern society.'),

(14, 13, 'Algorithms and Problem Solving', '9780000000014', ' ', '2021-11-03',
 'A practical guide to algorithms, data structures, and computational problem solving.'),

(15, 14, 'Building a Successful Business', '9780000000015', ' ', '2019-10-16',
 'Principles of entrepreneurship, business strategy, and organizational management.'),

(16, 15, 'Markets and Economic Systems', '9780000000016', ' ', '2018-03-21',
 'An introduction to markets, economic systems, supply, demand, and international trade.'),

(17, 16, 'The Psychology of Human Behavior', '9780000000017', ' ', '2020-12-01',
 'An introduction to human behavior, cognition, emotions, and decision making.'),

(18, 17, 'Questions About Existence', '9780000000018', ' ', '2016-06-13',
 'A philosophical exploration of knowledge, existence, ethics, and human purpose.'),

(19, 18, 'Modern Learning Methods', '9780000000019', ' ', '2022-09-28',
 'A study of modern education, learning techniques, and effective teaching methods.'),

(20, 19, 'Develop Better Habits', '9780000000020', ' ', '2023-01-15',
 'A practical guide to productivity, personal growth, and developing positive habits.'),

(1, 20, 'Adventures of Little Daniel', '9780000000021', ' ', '2019-04-09',
 'An illustrated adventure story designed for children and young readers.'),

(2, 11, 'Discovering Modern Science', '9780000000022', ' ', '2021-05-17',
 'A general introduction to important scientific discoveries and concepts.'),

(3, 12, 'Digital Worlds', '9780000000023', ' ', '2020-10-30',
 'An exploration of digital transformation, computing, and the future of connected technology.'),

(4, 14, 'The Entrepreneurial Mind', '9780000000024', ' ', '2023-06-08',
 'Ideas and strategies for entrepreneurs who want to build and grow successful businesses.'),

(5, 1, 'Memories of a Distant Summer', '9780000000025', ' ', '2018-08-26',
 'A fictional story about childhood memories, family relationships, and returning home.');



 INSERT INTO BookAuthors
(
    BookID,
    AuthorID
)
VALUES
(1,  1),
(2,  2),
(3,  3),
(4,  4),
(5,  5),
(6,  6),
(7,  7),
(8,  8),
(9,  9),
(10, 10),
(11, 11),
(12, 12),
(13, 13),
(14, 14),
(15, 15),
(16, 16),
(17, 17),
(18, 18),
(19, 19),
(20, 20),

(21, 1),
(22, 2),
(23, 3),
(24, 4),
(25, 5),

(3,  13),
(6,  18),
(12, 7),
(14, 1),
(15, 19);

INSERT INTO BookCopies
(
    BookID,
    Barcode,
    AvailabilityStatus
)
VALUES
-- Book 1: 2 copies
(1, 'LIB-00001', 'Available'),
(1, 'LIB-00002', 'Borrowed'),

-- Book 2: 2 copies
(2, 'LIB-00003', 'Available'),
(2, 'LIB-00004', 'Available'),

-- Book 3: 2 copies
(3, 'LIB-00005', 'Borrowed'),
(3, 'LIB-00006', 'Available'),

-- Book 4: 2 copies
(4, 'LIB-00007', 'Available'),
(4, 'LIB-00008', 'Reserved'),

-- Book 5: 2 copies
(5, 'LIB-00009', 'Available'),
(5, 'LIB-00010', 'Borrowed'),

-- Book 6: 2 copies
(6, 'LIB-00011', 'Available'),
(6, 'LIB-00012', 'Available'),

-- Book 7: 2 copies
(7, 'LIB-00013', 'Borrowed'),
(7, 'LIB-00014', 'Available'),

-- Book 8: 2 copies
(8, 'LIB-00015', 'Available'),
(8, 'LIB-00016', 'Damaged'),

-- Book 9: 2 copies
(9, 'LIB-00017', 'Available'),
(9, 'LIB-00018', 'Available'),

-- Book 10: 2 copies
(10, 'LIB-00019', 'Borrowed'),
(10, 'LIB-00020', 'Available'),

-- Book 11: 2 copies
(11, 'LIB-00021', 'Available'),
(11, 'LIB-00022', 'Reserved'),

-- Book 12: 2 copies
(12, 'LIB-00023', 'Available'),
(12, 'LIB-00024', 'Borrowed'),

-- Book 13: 2 copies
(13, 'LIB-00025', 'Available'),
(13, 'LIB-00026', 'Available'),

-- Book 14: 2 copies
(14, 'LIB-00027', 'Borrowed'),
(14, 'LIB-00028', 'Available'),

-- Book 15: 2 copies
(15, 'LIB-00029', 'Available'),
(15, 'LIB-00030', 'Available'),

-- Book 16: 2 copies
(16, 'LIB-00031', 'Reserved'),
(16, 'LIB-00032', 'Available'),

-- Book 17: 2 copies
(17, 'LIB-00033', 'Borrowed'),
(17, 'LIB-00034', 'Available'),

-- Book 18: 2 copies
(18, 'LIB-00035', 'Available'),
(18, 'LIB-00036', 'Available'),

-- Book 19: 2 copies
(19, 'LIB-00037', 'Borrowed'),
(19, 'LIB-00038', 'Available'),

-- Book 20: 2 copies
(20, 'LIB-00039', 'Available'),
(20, 'LIB-00040', 'Available');


INSERT INTO Suppliers
(
    SupplierName,
    ContactPerson,
    Email,
    PhoneNumber,
    Address,
    Website,
    IsActive
)
VALUES
('Global Book Distribution', 'Michael Carter', 'michael.carter@globalbook.example.com', '+1-617-555-2101', '120 Main Street, Boston, USA', 'https://globalbook.example.com', 1),

('European Academic Books', 'Sophie Laurent', 'sophie.laurent@euroacademic.example.com', '+33-1-555-2102', '18 Rue de Lyon, Paris, France', 'https://euroacademic.example.com', 1),

('London Book Supply', 'Oliver Bennett', 'oliver.bennett@londonbooks.example.com', '+44-20-555-2103', '45 Oxford Road, London, UK', 'https://londonbooks.example.com', 1),

('Iberia Publishing Supply', 'Carlos Martinez', 'carlos.martinez@iberiabooks.example.com', '+34-91-555-2104', '32 Gran Via, Madrid, Spain', 'https://iberiabooks.example.com', 1),

('German Academic Distribution', 'Hans Weber', 'hans.weber@germanacademic.example.com', '+49-30-555-2105', '27 Berlin Avenue, Berlin, Germany', 'https://germanacademic.example.com', 1),

('Italian Book Partners', 'Marco Rossi', 'marco.rossi@italianbooks.example.com', '+39-02-555-2106', '14 Via Roma, Milan, Italy', 'https://italianbooks.example.com', 1),

('Canadian Library Supply', 'Emily Wilson', 'emily.wilson@canlibrary.example.com', '+1-416-555-2107', '88 Maple Avenue, Toronto, Canada', 'https://canlibrary.example.com', 1),

('Pacific Book Distribution', 'James Taylor', 'james.taylor@pacificbooks.example.com', '+61-2-555-2108', '51 George Street, Sydney, Australia', 'https://pacificbooks.example.com', 1),

('Nordic Academic Books', 'Anna Eriksson', 'anna.eriksson@nordicbooks.example.com', '+46-8-555-2109', '24 Stockholm Road, Stockholm, Sweden', 'https://nordicbooks.example.com', 1),

('Tokyo Publishing Supply', 'Yuki Tanaka', 'yuki.tanaka@tokyobooks.example.com', '+81-3-555-2110', '19 Sakura Street, Tokyo, Japan', 'https://tokyobooks.example.com', 1),

('South American Book Trade', 'Daniel Silva', 'daniel.silva@sabooktrade.example.com', '+55-11-555-2111', '75 Paulista Avenue, Sao Paulo, Brazil', 'https://sabooktrade.example.com', 1),

('Global Academic Resources', 'David Miller', 'david.miller@globalacademic.example.com', '+1-312-555-2112', '63 Lake Street, Chicago, USA', 'https://globalacademic.example.com', 1),

('Central European Books', 'Anna Kowalski', 'anna.kowalski@ceb.example.com', '+48-22-555-2113', '41 Warsaw Street, Warsaw, Poland', 'https://ceb.example.com', 1),

('International Technology Books', 'Robert Johnson', 'robert.johnson@techbooks.example.com', '+1-212-555-2114', '90 Fifth Avenue, New York, USA', 'https://techbooks.example.com', 1),

('World Literature Supply', 'Marie Dubois', 'marie.dubois@worldliterature.example.com', '+33-4-555-2115', '12 Avenue de Marseille, Marseille, France', 'https://worldliterature.example.com', 0);


INSERT INTO PurchaseOrders
(
    SupplierID,
    OrderDate,
    ExpectedDate,
    Status
)
VALUES
(1,  '2026-01-05 09:30:00', '2026-01-15 09:00:00', 'Completed'),
(2,  '2026-01-12 10:15:00', '2026-01-25 09:00:00', 'Completed'),
(3,  '2026-01-20 11:00:00', '2026-02-02 09:30:00', 'Completed'),
(4,  '2026-02-03 09:45:00', '2026-02-15 10:00:00', 'Completed'),
(5,  '2026-02-10 14:20:00', '2026-02-24 09:00:00', 'Completed'),

(6,  '2026-02-18 10:30:00', '2026-03-02 09:00:00', 'Completed'),
(7,  '2026-03-01 09:15:00', '2026-03-12 10:00:00', 'Completed'),
(8,  '2026-03-08 13:00:00', '2026-03-22 09:30:00', 'Completed'),
(9,  '2026-03-15 11:45:00', '2026-03-28 09:00:00', 'Completed'),
(10, '2026-03-25 10:00:00', '2026-04-08 09:00:00', 'Completed'),

(11, '2026-04-02 14:30:00', '2026-04-16 10:00:00', 'Completed'),
(12, '2026-04-15 09:20:00', '2026-04-29 09:30:00', 'Completed'),
(13, '2026-05-01 10:45:00', '2026-05-15 09:00:00', 'Completed'),
(14, '2026-05-12 13:15:00', '2026-05-27 10:00:00', 'Completed'),

(1,  '2026-06-03 09:30:00', '2026-06-17 09:00:00', 'Completed'),
(3,  '2026-06-15 11:10:00', '2026-06-30 10:00:00', 'Completed'),
(5,  '2026-07-01 14:00:00', '2026-07-15 09:30:00', 'Completed'),

(7,  '2026-08-05 10:20:00', '2026-08-20 09:00:00', 'Pending'),
(9,  '2026-08-18 13:30:00', '2026-09-02 10:00:00', 'Pending'),
(14, '2026-09-01 09:45:00', '2026-09-15 09:00:00', 'Pending');


INSERT INTO PurchaseDetails
(
    PurchaseOrderID,
    BookID,
    Quantity,
    UnitPrice,
    TotalAmount
)
VALUES
-- Purchase Order 1 → Supplier 1
(1,  1,  10, 25.00, 250.00),
(1,  13, 8,  32.50, 260.00),

-- Purchase Order 2 → Supplier 2
(2,  2,  12, 18.00, 216.00),
(2,  22, 7,  27.50, 192.50),

-- Purchase Order 3 → Supplier 3
(3,  3,  10, 24.00, 240.00),
(3,  14, 6,  35.00, 210.00),

-- Purchase Order 4 → Supplier 4
(4,  4,  8,  29.00, 232.00),
(4,  7,  10, 21.50, 215.00),

-- Purchase Order 5 → Supplier 5
(5,  5,  15, 19.00, 285.00),
(5,  11, 9,  31.00, 279.00),

-- Purchase Order 6 → Supplier 6
(6,  6,  10, 22.00, 220.00),
(6,  15, 5,  28.50, 142.50),

-- Purchase Order 7 → Supplier 7
(7,  8,  12, 26.00, 312.00),
(7,  16, 8,  30.00, 240.00),

-- Purchase Order 8 → Supplier 8
(8,  9,  10, 20.00, 200.00),
(8,  17, 6,  34.00, 204.00),

-- Purchase Order 9 → Supplier 9
(9,  10, 8,  23.50, 188.00),
(9,  19, 10, 29.00, 290.00),

-- Purchase Order 10 → Supplier 10
(10, 12, 7,  36.00, 252.00),
(10, 16, 5,  30.00, 150.00),

-- Purchase Order 11 → Supplier 11
(11, 18, 10, 24.50, 245.00),
(11, 21, 8,  17.50, 140.00),

-- Purchase Order 12 → Supplier 12
(12, 20, 12, 21.00, 252.00),
(12, 23, 6,  33.00, 198.00),

-- Purchase Order 13 → Supplier 13
(13, 14, 10, 35.00, 350.00),
(13, 24, 7,  26.50, 185.50),

-- Purchase Order 14 → Supplier 14
(14, 13, 8,  32.00, 256.00),
(14, 25, 10, 19.50, 195.00),

-- Purchase Order 15 → Supplier 1
(15, 1,  5,  25.00, 125.00),
(15, 11, 6,  31.00, 186.00),

-- Purchase Order 16 → Supplier 3
(16, 3,  7,  24.00, 168.00),
(16, 22, 5,  27.50, 137.50),

-- Purchase Order 17 → Supplier 5
(17, 5,  10, 19.00, 190.00),
(17, 15, 6,  28.50, 171.00),

-- Purchase Order 18 → Supplier 7
(18, 7,  8,  21.50, 172.00),
(18, 17, 7,  34.00, 238.00),

-- Purchase Order 19 → Supplier 9
(19, 10, 9,  23.50, 211.50),
(19, 19, 5,  29.00, 145.00),

-- Purchase Order 20 → Supplier 14
(20, 24, 10, 26.50, 265.00),
(20, 25, 6,  19.50, 117.00);


INSERT INTO MembershipTypes
(
    TypeName,
    LoanDurationDays,
    AnnualFee,
    IsActive,
    Description
)
VALUES
('Standard', 14, 15.00, 1,
 'Standard membership for regular library users.'),

('Student', 21, 5.00, 1,
 'Discounted membership for students with extended borrowing duration.'),

('Premium', 30, 30.00, 1,
 'Premium membership with a longer borrowing period.'),

('Faculty', 30, 10.00, 1,
 'Membership designed for university faculty and teaching staff.'),

('Researcher', 45, 20.00, 1,
 'Extended borrowing period for researchers and academic projects.'),

('Child', 14, 0.00, 1,
 'Free membership for children and young readers.'),

('Senior', 21, 0.00, 1,
 'Free membership with extended borrowing privileges for senior members.'),

('Guest', 7, 8.00, 0,
 'Temporary membership for visitors and short-term library users.');

INSERT INTO BorrowingRecords
(
    MemberID,
    UserID,
    CopyID,
    BorrowingDate,
    DueDate,
    ActualReturnDate
)
VALUES
(1,  2,  2,  '2026-01-15', '2026-02-05', '2026-02-03'),
(2,  3,  5,  '2026-01-20', '2026-02-03', '2026-02-02'),
(3,  2,  10, '2026-02-01', '2026-03-03', '2026-03-01'),
(4,  5,  13, '2026-02-05', '2026-03-07', '2026-03-05'),
(5,  3,  19, '2026-02-10', '2026-03-27', '2026-03-25'),
(6,  4,  16, '2026-02-15', '2026-03-01', '2026-02-28'),
(7,  2,  27, '2026-03-01', '2026-03-22', '2026-03-20'),
(8,  8,  24, '2026-03-10', '2026-03-31', '2026-03-29'),
(9,  3,  31, '2026-03-15', '2026-03-29', '2026-03-28'),
(10, 5,  33, '2026-04-01', '2026-05-01', '2026-04-29'),
(11, 2,  21, '2026-04-10', '2026-05-10', '2026-05-08'),
(12, 3,  23, '2026-04-15', '2026-05-30', '2026-05-28'),
(13, 4,  26, '2026-05-01', '2026-05-15', '2026-05-14'),
(14, 8,  34, '2026-05-10', '2026-05-31', '2026-05-30'),
(15, 2,  14, '2026-05-15', '2026-06-05', '2026-06-04'),
(16, 3,  28, '2026-06-01', '2026-06-15', '2026-06-14'),
(17, 5,  38, '2026-06-10', '2026-07-10', NULL),
(18, 2,  40, '2026-06-15', '2026-07-30', NULL),
(19, 3,  22, '2026-07-01', '2026-07-22', '2026-07-25'),
(20, 4,  6,  '2026-07-10', '2026-07-24', NULL);

INSERT INTO BookRequests
(
    MemberID,
    RequestDate,
    Reason,
    RequestStatus,
    RequestedTitle,
    RequestedAuthor,
    ISBN
)
VALUES
(1,  '2026-01-12', 'Needed for programming studies.', 'Approved', 'Clean Code', 'Robert C. Martin', '9780132350884'),
(2,  '2026-01-18', 'Requested for university studies.', 'Completed', 'Introduction to Algorithms', 'Thomas H. Cormen', '9780262046305'),
(3,  '2026-02-02', 'Interested in modern software engineering.', 'Approved', 'The Pragmatic Programmer', 'Andrew Hunt', '9780135957059'),
(4,  '2026-02-10', 'Requested for research.', 'Pending', 'Artificial Intelligence', 'Stuart Russell', '9780134610993'),
(5,  '2026-02-18', 'Needed for business studies.', 'Approved', 'Good to Great', 'Jim Collins', '9780066620992'),
(6,  '2026-03-01', 'Requested for science research.', 'Completed', 'A Brief History of Time', 'Stephen Hawking', '9780553380163'),
(7,  '2026-03-12', 'Personal interest.', 'Rejected', 'The Hobbit', 'J.R.R. Tolkien', '9780547928227'),
(8,  '2026-03-20', 'Requested for literature studies.', 'Approved', 'Pride and Prejudice', 'Jane Austen', '9780141439518'),
(9,  '2026-04-01', 'Needed for programming practice.', 'Pending', 'C# in Depth', 'Jon Skeet', '9781617294532'),
(10, '2026-04-08', 'Personal development.', 'Approved', 'Atomic Habits', 'James Clear', '9780735211292'),
(11, '2026-04-15', 'Requested for history research.', 'Completed', 'Sapiens', 'Yuval Noah Harari', '9780062316097'),
(12, '2026-04-22', 'Needed for economics studies.', 'Pending', 'Capital in the Twenty-First Century', 'Thomas Piketty', '9780674979857'),
(13, '2026-05-02', 'Research project.', 'Approved', 'The Silk Roads', 'Peter Frankopan', '9781101912379'),
(14, '2026-05-10', 'Requested for children section.', 'Completed', 'The Little Prince', 'Antoine de Saint-Exupery', '9780156012195'),
(15, '2026-05-18', 'Needed for technology studies.', 'Approved', 'Designing Data-Intensive Applications', 'Martin Kleppmann', '9781449373320'),
(16, '2026-06-01', 'Requested for Japanese literature.', 'Pending', 'Norwegian Wood', 'Haruki Murakami', '9780375704024'),
(17, '2026-06-10', 'Interested in psychology.', 'Approved', 'Thinking, Fast and Slow', 'Daniel Kahneman', '9780374533557'),
(18, '2026-06-20', 'Requested for philosophy studies.', 'Completed', 'Meditations', 'Marcus Aurelius', '9780140449334'),
(19, '2026-07-01', 'Needed for education research.', 'Pending', 'Pedagogy of the Oppressed', 'Paulo Freire', '9781501314131'),
(20, '2026-07-12', 'Personal development.', 'Approved', 'The 7 Habits of Highly Effective People', 'Stephen R. Covey', '9781982137274');

INSERT INTO LostDamagedBooks
(
    UserID,
    CopyID,
    BorrowingRecordID,
    IncidentType,
    IncidentDate,
    Status,
    EstimatedCost,
    ResolutionDate
)
VALUES
(2,  22, 19, 'Damaged', '2026-07-25', 'Resolved', 12.50, '2026-07-30'),
(3,  6,  20, 'Lost',    '2026-07-24', 'Open',     35.00, NULL),
(5,  38, 17, 'Damaged', '2026-07-15', 'Resolved', 18.00, '2026-07-20'),
(2,  14, 15, 'Damaged', '2026-06-04', 'Resolved', 10.00, '2026-06-08'),
(4,  28, 16, 'Lost',    '2026-06-14', 'Open',     40.00, NULL),
(3,  40, 18, 'Damaged', '2026-07-30', 'Resolved', 15.00, '2026-08-02'),
(8,  24, 8,  'Damaged', '2026-05-28', 'Resolved', 20.00, '2026-06-03'),
(2,  33, 10, 'Lost',    '2026-04-29', 'Open',     30.00, NULL),
(5,  19, 5,  'Damaged', '2026-03-25', 'Resolved', 17.50, '2026-03-30'),
(3,  31, 9,  'Damaged', '2026-03-28', 'Resolved', 14.00, '2026-04-02');

INSERT INTO Reservations
(
    MemberID,
    BookID,
    ReservationDate,
    ExpiryDate,
    Status
)
VALUES
(1,  3,  '2026-08-01', '2026-08-08', 'Fulfilled'),
(2,  5,  '2026-08-03', '2026-08-10', 'Cancelled'),
(3,  10, '2026-08-05', '2026-08-12', 'Fulfilled'),
(4,  14, '2026-08-07', '2026-08-14', 'Pending'),
(5,  17, '2026-08-09', '2026-08-16', 'Expired'),
(6,  8,  '2026-08-11', '2026-08-18', 'Fulfilled'),
(7,  11, '2026-08-13', '2026-08-20', 'Pending'),
(8,  16, '2026-08-15', '2026-08-22', 'Cancelled'),
(9,  19, '2026-08-17', '2026-08-24', 'Fulfilled'),
(10, 2,  '2026-08-19', '2026-08-26', 'Pending'),
(11, 12, '2026-08-21', '2026-08-28', 'Fulfilled'),
(12, 13, '2026-08-23', '2026-08-30', 'Pending'),
(13, 4,  '2026-08-25', '2026-09-01', 'Expired'),
(14, 7,  '2026-08-27', '2026-09-03', 'Fulfilled'),
(15, 15, '2026-08-29', '2026-09-05', 'Pending'),
(16, 18, '2026-09-01', '2026-09-08', 'Pending'),
(17, 20, '2026-09-03', '2026-09-10', 'Cancelled'),
(18, 6,  '2026-09-05', '2026-09-12', 'Pending'),
(19, 9,  '2026-09-07', '2026-09-14', 'Fulfilled'),
(20, 1,  '2026-09-10', '2026-09-17', 'Pending');

INSERT INTO Fines
(
    MemberID,
    BorrowingRecordID,
    NumberOfLateDays,
    FineAmount,
    PaymentStatus
)
VALUES
(1, 1, 2, 2.00, 'Paid'),
(2, 2, 1, 1.00, 'Paid'),
(11, 11, 2, 2.00, 'Unpaid'),
(17, 17, 5, 5.00, 'Unpaid'),
(19, 19, 3, 3.00, 'Unpaid');

INSERT INTO AuditLogs
(
    UserID,
    ActionType,
    TableName,
    RecordID,
    ActionDate
)
VALUES
(1,  'INSERT', 'Members',          1,  '2026-01-10 09:15:00'),
(2,  'INSERT', 'Members',          2,  '2026-01-15 10:20:00'),
(3,  'INSERT', 'Books',            1,  '2026-01-16 11:30:00'),
(4,  'INSERT', 'Books',            5,  '2026-01-18 14:10:00'),
(5,  'UPDATE', 'Books',            10, '2026-02-01 09:45:00'),
(6,  'INSERT', 'BookCopies',      21, '2026-02-05 13:20:00'),
(7,  'UPDATE', 'BookCopies',      22, '2026-02-10 15:30:00'),
(2,  'INSERT', 'BorrowingRecords', 1, '2026-01-15 09:05:00'),
(3,  'INSERT', 'BorrowingRecords', 5, '2026-02-10 10:15:00'),
(4,  'UPDATE', 'BorrowingRecords', 5, '2026-03-25 16:40:00'),
(5,  'INSERT', 'BookRequests',    1, '2026-01-12 11:00:00'),
(6,  'UPDATE', 'BookRequests',    4, '2026-02-20 09:30:00'),
(7,  'INSERT', 'Reservations',    1, '2026-08-01 10:00:00'),
(8,  'UPDATE', 'Reservations',    5, '2026-08-16 12:15:00'),
(9,  'INSERT', 'Fines',           1, '2026-02-03 14:30:00'),
(10, 'UPDATE', 'Fines',           3, '2026-04-01 09:20:00'),
(1,  'INSERT', 'PurchaseOrders',  18, '2026-08-05 10:25:00'),
(5,  'UPDATE', 'PurchaseOrders',  19, '2026-08-25 13:45:00'),
(6,  'INSERT', 'LostDamagedBooks', 1, '2026-07-25 15:00:00'),
(9,  'UPDATE', 'LostDamagedBooks', 3, '2026-07-30 11:30:00');

INSERT INTO Settings
(
    DefaultBorrowDays,
    DefaultFinePerDay
)
VALUES
(14, 1.00);

ALTER TABLE BorrowingRecords
ADD CONSTRAINT CK_BorrowingRecords_Dates
CHECK (DueDate >= BorrowingDate);




