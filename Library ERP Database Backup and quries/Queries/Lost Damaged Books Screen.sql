-- =============================================
-- Lost / Damaged Books Management
-- =============================================


-- 1. Display all lost/damaged incidents.
SELECT *
FROM LostDamagedBooks;


-- 2. Display incidents with book titles.
SELECT
    LDB.*,
    B.Title
FROM LostDamagedBooks LDB
JOIN BookCopies BC
    ON LDB.CopyID = BC.CopyID
JOIN Books B
    ON BC.BookID = B.BookID;


-- 3. Display incidents with member/librarian information.
SELECT
    LDB.IncidentID,
    MP.FirstName AS MemberFirstName,
    MP.LastName AS MemberLastName,
    UP.FirstName AS LibrarianFirstName,
    UP.LastName AS LibrarianLastName,
    LDB.IncidentType,
    LDB.EstimatedCost,
    LDB.Status,
    LDB.ResolutionDate
FROM LostDamagedBooks LDB
JOIN BorrowingRecords BR
    ON LDB.BorrowingRecordID = BR.BorrowingRecordID
JOIN Members M
    ON BR.MemberID = M.MemberID
JOIN People MP
    ON M.PersonID = MP.PersonID
JOIN Users U
    ON LDB.UserID = U.UserID
JOIN People UP
    ON U.PersonID = UP.PersonID;

-- 4. Display lost books.
SELECT
    LDB.*,
    B.Title
FROM LostDamagedBooks LDB
JOIN BookCopies BC
    ON LDB.CopyID = BC.CopyID
JOIN Books B
    ON BC.BookID = B.BookID
WHERE LDB.IncidentType = 'Lost';


-- 5. Display damaged books.
SELECT
    LDB.*,
    B.Title
FROM LostDamagedBooks LDB
JOIN BookCopies BC
    ON LDB.CopyID = BC.CopyID
JOIN Books B
    ON BC.BookID = B.BookID
WHERE LDB.IncidentType = 'Damaged';


-- 6. Display unresolved incidents.
SELECT *
FROM LostDamagedBooks
WHERE Status = 'Unresolved';


-- 7. Display resolved incidents.
SELECT *
FROM LostDamagedBooks
WHERE Status = 'Resolved';


-- 8. Calculate total estimated loss.
SELECT
    SUM(EstimatedCost) AS TotalEstimatedLoss
FROM LostDamagedBooks
WHERE IncidentType = 'Lost';


-- 9. Calculate total estimated damage cost.
SELECT
    SUM(EstimatedCost) AS TotalEstimatedDamageCost
FROM LostDamagedBooks
WHERE IncidentType = 'Damaged';


-- 10. Display complete incident history including
--     book, barcode, incident type, cost, status
--     and resolution date.
SELECT
    LDB.IncidentID,
    B.Title,
    BC.Barcode,
    LDB.IncidentType,
    LDB.EstimatedCost,
    LDB.Status,
    LDB.ResolutionDate
FROM LostDamagedBooks LDB
JOIN BookCopies BC
    ON LDB.CopyID = BC.CopyID
JOIN Books B
    ON BC.BookID = B.BookID
ORDER BY LDB.IncidentID DESC;

