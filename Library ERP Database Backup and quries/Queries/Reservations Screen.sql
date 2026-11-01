-- =============================================
-- Reservations Management
-- =============================================

-- 1. Display all reservations.
SELECT *
FROM Reservations;


-- 2. Display reservations with member names.
SELECT
    R.ReservationID,
    R.MemberID,
    P.FirstName,
    P.LastName,
    R.BookID,
    R.ReservationDate,
    R.ExpiryDate,
    R.Status
FROM Reservations R
JOIN Members M
    ON R.MemberID = M.MemberID
JOIN People P
    ON M.PersonID = P.PersonID;


-- 3. Display reservations with book titles.
SELECT
    R.ReservationID,
    R.MemberID,
    R.BookID,
    B.Title,
    R.ReservationDate,
    R.ExpiryDate,
    R.Status
FROM Reservations R
JOIN Books B
    ON R.BookID = B.BookID;


-- 4. Find pending reservations.
SELECT *
FROM Reservations
WHERE Status = 'Pending';


-- 5. Find fulfilled reservations.
SELECT *
FROM Reservations
WHERE Status = 'Fulfilled';


-- 6. Find expired reservations.
SELECT *
FROM Reservations
WHERE ExpiryDate < GETDATE()
  AND Status <> 'Fulfilled';


-- 7. Find cancelled reservations.
SELECT *
FROM Reservations
WHERE Status = 'Cancelled';


-- 8. Find reservations that expire within 3 days.
SELECT *
FROM Reservations
WHERE ExpiryDate BETWEEN GETDATE()
                     AND DATEADD(DAY, 3, GETDATE());


-- 9. Count reservations by book.
SELECT
    R.BookID,
    B.Title,
    COUNT(*) AS ReservationCount
FROM Reservations R
JOIN Books B
    ON R.BookID = B.BookID
GROUP BY
    R.BookID,
    B.Title
ORDER BY ReservationCount DESC;


-- 10. Display complete reservation information.
SELECT
    R.ReservationID,
    P.FirstName,
    P.LastName,
    B.Title,
    R.ReservationDate,
    R.ExpiryDate,
    R.Status
FROM Reservations R
JOIN Members M
    ON R.MemberID = M.MemberID
JOIN People P
    ON M.PersonID = P.PersonID
JOIN Books B
    ON R.BookID = B.BookID
ORDER BY R.ReservationDate DESC;