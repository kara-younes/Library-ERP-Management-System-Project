-- =============================================
-- Screen 5 — Books Management
-- =============================================


-- 66. Display all books.
SELECT *
FROM Books;


-- 67. Display book title and ISBN.
SELECT
    Title,
    ISBN
FROM Books;


-- 68. Display books with their categories.
SELECT
    B.BookID,
    B.Title,
    C.CategoryName
FROM Books B
JOIN Categories C
    ON B.CategoryID = C.CategoryID;


-- 69. Display books with their languages.
SELECT
    B.BookID,
    B.Title,
    L.LanguageName,
    L.LanguageCode
FROM Books B
JOIN Languages L
    ON B.LanguageID = L.LanguageID;


-- 70. Display books with their authors.
SELECT
    B.BookID,
    B.Title,
    P.FirstName,
    P.LastName
FROM Books B
JOIN BookAuthors BA
    ON B.BookID = BA.BookID
JOIN Authors A
    ON BA.AuthorID = A.AuthorID
JOIN People P
    ON A.PersonID = P.PersonID;


-- 71. Search books by title.
SELECT *
FROM Books
WHERE Title LIKE '%SQL%';


-- 72. Search books by ISBN.
SELECT *
FROM Books
WHERE ISBN LIKE '%978%';


-- 73. Search books by author.
SELECT
    B.BookID,
    B.Title,
    P.FirstName,
    P.LastName
FROM Books B
JOIN BookAuthors BA
    ON B.BookID = BA.BookID
JOIN Authors A
    ON BA.AuthorID = A.AuthorID
JOIN People P
    ON A.PersonID = P.PersonID
WHERE CONCAT(P.FirstName, ' ', P.LastName) LIKE '%John%';


-- 74. Search books by category.
SELECT
    B.BookID,
    B.Title,
    C.CategoryName
FROM Books B
JOIN Categories C
    ON B.CategoryID = C.CategoryID
WHERE C.CategoryName = 'Programming';


-- 75. Search books by language.
SELECT
    B.BookID,
    B.Title,
    L.LanguageName
FROM Books B
JOIN Languages L
    ON B.LanguageID = L.LanguageID
WHERE L.LanguageName = 'English';


-- 76. Find books published after a specific year.
SELECT *
FROM Books
WHERE PublicationDate >= '2023-01-01';


-- 77. Find books published before a specific year.
SELECT *
FROM Books
WHERE PublicationDate < '2022-01-01';


-- 78. Sort books alphabetically.
SELECT *
FROM Books
ORDER BY Title ASC;


-- 79. Sort books by publication date.
SELECT *
FROM Books
ORDER BY PublicationDate ASC;


-- 80. Count books by category.
SELECT
    C.CategoryName,
    COUNT(B.BookID) AS BooksCount
FROM Categories C
LEFT JOIN Books B
    ON C.CategoryID = B.CategoryID
GROUP BY C.CategoryName;


-- 81. Count books by language.
SELECT
    L.LanguageName,
    COUNT(B.BookID) AS BooksCount
FROM Languages L
LEFT JOIN Books B
    ON L.LanguageID = B.LanguageID
GROUP BY L.LanguageName;


-- 82. Count books by author.
SELECT
    BA.AuthorID,
    P.FirstName,
    P.LastName,
    COUNT(BA.BookID) AS BooksCount
FROM BookAuthors BA
JOIN Authors A
    ON BA.AuthorID = A.AuthorID
JOIN People P
    ON A.PersonID = P.PersonID
GROUP BY
    BA.AuthorID,
    P.FirstName,
    P.LastName;


-- 83. Find books with no assigned author.
SELECT
    B.BookID,
    B.Title
FROM Books B
LEFT JOIN BookAuthors BA
    ON B.BookID = BA.BookID
WHERE BA.BookID IS NULL;


-- 84. Find books with multiple authors.
SELECT
    B.BookID,
    B.Title,
    COUNT(BA.AuthorID) AS AuthorsCount
FROM Books B
JOIN BookAuthors BA
    ON B.BookID = BA.BookID
GROUP BY
    B.BookID,
    B.Title
HAVING COUNT(BA.AuthorID) > 1;


-- 85. Find books with multiple physical copies.
SELECT
    B.BookID,
    B.Title,
    COUNT(BC.CopyID) AS CopyCount
FROM Books B
JOIN BookCopies BC
    ON B.BookID = BC.BookID
GROUP BY
    B.BookID,
    B.Title
HAVING COUNT(BC.CopyID) > 1;


-- 86. Find books with no available copy.
SELECT
    B.BookID,
    B.Title
FROM Books B
LEFT JOIN BookCopies BC
    ON B.BookID = BC.BookID
GROUP BY
    B.BookID,
    B.Title
HAVING COUNT(
    CASE
        WHEN BC.AvailabilityStatus = 'Available' THEN 1
    END
) = 0;


-- 87. Find books that currently have at least one available copy.
SELECT
    B.BookID,
    B.Title
FROM Books B
JOIN BookCopies BC
    ON B.BookID = BC.BookID
GROUP BY
    B.BookID,
    B.Title
HAVING COUNT(
    CASE
        WHEN BC.AvailabilityStatus = 'Available' THEN 1
    END
) > 0;


-- 88. Find the oldest book.
SELECT *
FROM Books
WHERE PublicationDate = (
    SELECT MIN(PublicationDate)
    FROM Books
);


-- 89. Find the newest book.
SELECT *
FROM Books
WHERE PublicationDate = (
    SELECT MAX(PublicationDate)
    FROM Books
);


-- 90. Display complete book information with title,
--     ISBN, author, category, language and publication date.
SELECT
    B.BookID,
    B.Title,
    B.ISBN,
    P.FirstName,
    P.LastName,
    C.CategoryName,
    L.LanguageName,
    B.PublicationDate
FROM Books B
JOIN Categories C
    ON B.CategoryID = C.CategoryID
JOIN Languages L
    ON B.LanguageID = L.LanguageID
JOIN BookAuthors BA
    ON B.BookID = BA.BookID
JOIN Authors A
    ON BA.AuthorID = A.AuthorID
JOIN People P
    ON A.PersonID = P.PersonID;
