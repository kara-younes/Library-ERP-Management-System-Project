-- =============================================
-- Screen 7 — Borrowing / Circulation
-- =============================================

-- 106. Display all borrowing records.
SELECT *
FROM BorrowingRecords;


-- 107. Display borrowing records with member names.
SELECT
    BR.BorrowingRecordID,
    BR.MemberID,
    P.FirstName,
    P.LastName,
    BR.BorrowingDate,
    BR.DueDate,
    BR.ActualReturnDate
FROM BorrowingRecords BR
JOIN Members M
    ON BR.MemberID = M.MemberID
JOIN People P
    ON M.PersonID = P.PersonID;


-- 108. Display borrowing records with book titles.
SELECT
    BR.BorrowingRecordID,
    B.Title,
    BR.BorrowingDate,
    BR.DueDate,
    BR.ActualReturnDate
FROM BorrowingRecords BR
JOIN BookCopies BC
    ON BR.CopyID = BC.CopyID
JOIN Books B
    ON BC.BookID = B.BookID;


-- 109. Display borrowing records with copy barcodes.
SELECT
    BR.BorrowingRecordID,
    B.Title,
    BC.Barcode,
    BR.BorrowingDate,
    BR.DueDate,
    BR.ActualReturnDate
FROM BorrowingRecords BR
JOIN BookCopies BC
    ON BR.CopyID = BC.CopyID
JOIN Books B
    ON BC.BookID = B.BookID;


-- 110. Display borrowing records with librarian/user names.
SELECT
    BR.BorrowingRecordID,
    BR.UserID,
    P.FirstName,
    P.LastName,
    BR.BorrowingDate,
    BR.DueDate,
    BR.ActualReturnDate
FROM BorrowingRecords BR
JOIN Users U
    ON BR.UserID = U.UserID
JOIN People P
    ON U.PersonID = P.PersonID;


-- 111. Find currently borrowed books.
SELECT *
FROM BorrowingRecords
WHERE ActualReturnDate IS NULL;


-- 112. Find returned books.
SELECT *
FROM BorrowingRecords
WHERE ActualReturnDate IS NOT NULL;


-- 113. Find overdue books.
SELECT *
FROM BorrowingRecords
WHERE ActualReturnDate IS NULL
  AND DueDate < GETDATE();


-- 114. Find books due today.
SELECT *
FROM BorrowingRecords
WHERE ActualReturnDate IS NULL
  AND CAST(DueDate AS DATE) = CAST(GETDATE() AS DATE);


-- 115. Find books due within the next 7 days.
SELECT *
FROM BorrowingRecords
WHERE ActualReturnDate IS NULL
  AND DueDate BETWEEN GETDATE() AND DATEADD(DAY, 7, GETDATE());


-- 116. Find borrowing records for a specific member.
SELECT *
FROM BorrowingRecords
WHERE MemberID = 1;


-- 117. Find borrowing history for a specific book.
SELECT
    BR.*
FROM BorrowingRecords BR
JOIN BookCopies BC
    ON BR.CopyID = BC.CopyID
WHERE BC.BookID = 1
ORDER BY BR.BorrowingDate;


-- 118. Find borrowing history for a specific copy.
SELECT *
FROM BorrowingRecords
WHERE CopyID = 13
ORDER BY BorrowingDate;


-- 119. Find borrowing history handled by a specific librarian.
SELECT *
FROM BorrowingRecords
WHERE UserID = 1
ORDER BY BorrowingDate;


-- 120. Count books borrowed by each member.
SELECT
    MemberID,
    COUNT(*) AS Borrowings
FROM BorrowingRecords
GROUP BY MemberID;


-- 121. Count books borrowed by each librarian.
SELECT
    UserID,
    COUNT(*) AS Borrowings
FROM BorrowingRecords
GROUP BY UserID;


-- 122. Count borrowings by month.
SELECT
    YEAR(BorrowingDate) AS BorrowingYear,
    MONTH(BorrowingDate) AS BorrowingMonth,
    COUNT(*) AS Borrowings
FROM BorrowingRecords
GROUP BY
    YEAR(BorrowingDate),
    MONTH(BorrowingDate)
ORDER BY
    BorrowingYear,
    BorrowingMonth;


-- 123. Count borrowings by year.
SELECT
    YEAR(BorrowingDate) AS BorrowingYear,
    COUNT(*) AS Borrowings
FROM BorrowingRecords
GROUP BY YEAR(BorrowingDate)
ORDER BY BorrowingYear;


-- 124. Find the most borrowed books.
SELECT
    B.BookID,
    B.Title,
    COUNT(*) AS BorrowingCount
FROM BorrowingRecords BR
JOIN BookCopies BC
    ON BR.CopyID = BC.CopyID
JOIN Books B
    ON B.BookID = BC.BookID
GROUP BY
    B.BookID,
    B.Title
ORDER BY BorrowingCount DESC;


-- 125. Find the most active members.
SELECT
    M.MemberID,
    P.FirstName,
    P.LastName,
    COUNT(*) AS BorrowingCount
FROM BorrowingRecords BR
JOIN Members M
    ON BR.MemberID = M.MemberID
JOIN People P
    ON M.PersonID = P.PersonID
GROUP BY
    M.MemberID,
    P.FirstName,
    P.LastName
ORDER BY BorrowingCount DESC;


-- 126. Find members who have never borrowed a book.
SELECT
    M.MemberID,
    P.FirstName,
    P.LastName
FROM Members M
JOIN People P
    ON M.PersonID = P.PersonID
LEFT JOIN BorrowingRecords BR
    ON M.MemberID = BR.MemberID
WHERE BR.MemberID IS NULL;


-- 127. Find members who borrowed more than 5 books.
SELECT
    MemberID,
    COUNT(*) AS Borrowings
FROM BorrowingRecords
GROUP BY MemberID
HAVING COUNT(*) > 5;


-- 128. Calculate average borrowing duration.
SELECT
    AVG(
        CAST(
            DATEDIFF(DAY, BorrowingDate, DueDate)
            AS DECIMAL(10,2)
        )
    ) AS AvgBorrowingDuration
FROM BorrowingRecords;


-- 129. Calculate the number of currently borrowed books.
SELECT
    COUNT(*) AS CurrentlyBorrowedBooks
FROM BorrowingRecords
WHERE ActualReturnDate IS NULL;


-- 130. Display a complete circulation report with member,
--      book, barcode, borrowing date, due date and return date.
SELECT
    P.FirstName,
    P.LastName,
    B.Title,
    BC.Barcode,
    BR.BorrowingDate,
    BR.DueDate,
    BR.ActualReturnDate
FROM BorrowingRecords BR
JOIN Members M
    ON BR.MemberID = M.MemberID
JOIN People P
    ON M.PersonID = P.PersonID
JOIN BookCopies BC
    ON BR.CopyID = BC.CopyID
JOIN Books B
    ON BC.BookID = B.BookID
ORDER BY BR.BorrowingDate DESC;