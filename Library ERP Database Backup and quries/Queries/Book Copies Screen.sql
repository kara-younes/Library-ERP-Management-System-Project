-- =============================================
-- Screen 6 — Book Copies / Inventory
-- =============================================


-- 91. Display all physical book copies.
SELECT *
FROM BookCopies;


-- 92. Display copies with their book titles.
SELECT
    BC.CopyID,
    BC.BookID,
    B.Title,
    BC.Barcode,
    BC.AvailabilityStatus
FROM BookCopies BC
JOIN Books B
    ON BC.BookID = B.BookID;


-- 93. Display available copies.
SELECT *
FROM BookCopies
WHERE AvailabilityStatus = 'Available';


-- 94. Display borrowed copies.
SELECT *
FROM BookCopies
WHERE AvailabilityStatus = 'Borrowed';


-- 95. Display reserved copies.
SELECT *
FROM BookCopies
WHERE AvailabilityStatus = 'Reserved';


-- 96. Display damaged copies.
SELECT *
FROM BookCopies
WHERE AvailabilityStatus = 'Damaged';


-- 97. Search a copy by barcode.
SELECT *
FROM BookCopies
WHERE Barcode LIKE '%123%';


-- 98. Find all copies belonging to a specific book.
SELECT
    BC.CopyID,
    BC.BookID,
    B.Title,
    BC.Barcode,
    BC.AvailabilityStatus
FROM BookCopies BC
JOIN Books B
    ON BC.BookID = B.BookID
WHERE BC.BookID = 1;


-- 99. Count copies for every book.
SELECT
    B.BookID,
    B.Title,
    COUNT(BC.CopyID) AS TotalCopies
FROM Books B
LEFT JOIN BookCopies BC
    ON B.BookID = BC.BookID
GROUP BY
    B.BookID,
    B.Title;


-- 100. Count available copies for every book.
SELECT
    B.BookID,
    B.Title,
    COUNT(
        CASE
            WHEN BC.AvailabilityStatus = 'Available'
            THEN 1
        END
    ) AS AvailableCopies
FROM Books B
LEFT JOIN BookCopies BC
    ON B.BookID = BC.BookID
GROUP BY
    B.BookID,
    B.Title;


-- 101. Count borrowed copies for every book.
SELECT
    B.BookID,
    B.Title,
    COUNT(
        CASE
            WHEN BC.AvailabilityStatus = 'Borrowed'
            THEN 1
        END
    ) AS BorrowedCopies
FROM Books B
LEFT JOIN BookCopies BC
    ON B.BookID = BC.BookID
GROUP BY
    B.BookID,
    B.Title;


-- 102. Find books where all copies are currently unavailable.
SELECT
    B.BookID,
    B.Title
FROM Books B
JOIN BookCopies BC
    ON B.BookID = BC.BookID
GROUP BY
    B.BookID,
    B.Title
HAVING COUNT(BC.CopyID) =
       COUNT(
           CASE
               WHEN BC.AvailabilityStatus <> 'Available'
               THEN 1
           END
       );


-- 103. Find books with exactly one available copy.
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
        WHEN BC.AvailabilityStatus = 'Available'
        THEN 1
    END
) = 1;


-- 104. Find books with more than one available copy.
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
        WHEN BC.AvailabilityStatus = 'Available'
        THEN 1
    END
) > 1;


-- 105. Display inventory statistics per book:
--      total copies, available copies,
--      borrowed copies and damaged copies.
SELECT
    B.BookID,
    B.Title,

    COUNT(BC.CopyID) AS TotalCopies,

    COUNT(
        CASE
            WHEN BC.AvailabilityStatus = 'Available'
            THEN 1
        END
    ) AS AvailableCopies,

    COUNT(
        CASE
            WHEN BC.AvailabilityStatus = 'Borrowed'
            THEN 1
        END
    ) AS BorrowedCopies,

    COUNT(
        CASE
            WHEN BC.AvailabilityStatus = 'Damaged'
            THEN 1
        END
    ) AS DamagedCopies

FROM Books B
LEFT JOIN BookCopies BC
    ON B.BookID = BC.BookID

GROUP BY
    B.BookID,
    B.Title;