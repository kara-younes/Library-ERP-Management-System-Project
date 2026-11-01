/* =========================================================
   21. Display all members with their first and last name
   ========================================================= */

SELECT
    People.FirstName,
    People.LastName
FROM Members
JOIN People
    ON Members.PersonID = People.PersonID
ORDER BY
    People.FirstName,
    People.LastName ASC;


/* =========================================================
   22. Display members with their membership type
   ========================================================= */

SELECT
    People.FirstName,
    People.LastName,
    MembershipTypes.TypeName AS MembershipType
FROM Members
JOIN People
    ON Members.PersonID = People.PersonID
JOIN MembershipTypes
    ON Members.MembershipTypeID = MembershipTypes.MembershipTypeID
ORDER BY
    People.FirstName,
    People.LastName ASC;


/* =========================================================
   23. Display member name, card number,
       registration date and expiration date
   ========================================================= */

SELECT
    People.FirstName,
    People.LastName,
    Members.LibraryCardNumber,
    Members.RegistrationDate,
    Members.ExpirationDate
FROM Members
JOIN People
    ON Members.PersonID = People.PersonID;


/* =========================================================
   24. Find all active members
   ========================================================= */

SELECT
    People.FirstName,
    People.LastName
FROM Members
JOIN People
    ON Members.PersonID = People.PersonID
WHERE Members.IsActive = 1;


/* =========================================================
   25. Find expired memberships
   ========================================================= */

SELECT
    Members.MemberID,
    People.FirstName,
    People.LastName,
    Members.LibraryCardNumber,
    Members.ExpirationDate
FROM Members
JOIN People
    ON Members.PersonID = People.PersonID
WHERE Members.ExpirationDate < CAST(GETDATE() AS DATE);


/* =========================================================
   26. Find memberships expiring within the next 30 days
   ========================================================= */

SELECT
    Members.MemberID,
    People.FirstName,
    People.LastName,
    Members.LibraryCardNumber,
    Members.ExpirationDate
FROM Members
JOIN People
    ON Members.PersonID = People.PersonID
WHERE Members.ExpirationDate
      BETWEEN CAST(GETDATE() AS DATE)
      AND DATEADD(DAY, 30, CAST(GETDATE() AS DATE));


/* =========================================================
   27. Search members by first name
   ========================================================= */

SELECT
    Members.MemberID,
    People.FirstName,
    People.LastName,
    Members.LibraryCardNumber
FROM Members
JOIN People
    ON Members.PersonID = People.PersonID
WHERE People.FirstName = 'James';


/* =========================================================
   28. Search members by last name
   ========================================================= */

SELECT
    Members.MemberID,
    People.FirstName,
    People.LastName,
    Members.LibraryCardNumber
FROM Members
JOIN People
    ON Members.PersonID = People.PersonID
WHERE People.LastName = 'Wilson';


/* =========================================================
   29. Search members by library card number
   ========================================================= */

SELECT
    Members.MemberID,
    People.FirstName,
    People.LastName,
    Members.LibraryCardNumber,
    Members.RegistrationDate,
    Members.ExpirationDate
FROM Members
JOIN People
    ON Members.PersonID = People.PersonID
WHERE Members.LibraryCardNumber = 'LIB-2026-0001';


/* =========================================================
   30. Search members by phone number
   ========================================================= */

SELECT
    Members.MemberID,
    People.FirstName,
    People.LastName,
    People.PhoneNumber,
    Members.LibraryCardNumber
FROM Members
JOIN People
    ON Members.PersonID = People.PersonID
WHERE People.PhoneNumber = '+39025550108';


/* =========================================================
   31. Search members by email
   ========================================================= */

SELECT
    Members.MemberID,
    People.FirstName,
    People.LastName,
    People.Email,
    Members.LibraryCardNumber
FROM Members
JOIN People
    ON Members.PersonID = People.PersonID
WHERE People.Email = 'mia.rossi@example.com';


/* =========================================================
   32. Display members from a specific country
   ========================================================= */

SELECT
    Members.MemberID,
    People.FirstName,
    People.LastName,
    People.Country,
    Members.LibraryCardNumber
FROM Members
JOIN People
    ON Members.PersonID = People.PersonID
WHERE People.Country = 'Italy';


/* =========================================================
   33. Count members by membership type
   ========================================================= */

SELECT
    MembershipTypes.TypeName,
    COUNT(*) AS MembersCount
FROM Members
JOIN MembershipTypes
    ON Members.MembershipTypeID = MembershipTypes.MembershipTypeID
GROUP BY
    MembershipTypes.TypeName;


/* =========================================================
   34. Count members registered during each month
   ========================================================= */

SELECT
    YEAR(RegistrationDate) AS RegistrationYear,
    MONTH(RegistrationDate) AS RegistrationMonth,
    COUNT(*) AS MembersCount
FROM Members
GROUP BY
    YEAR(RegistrationDate),
    MONTH(RegistrationDate)
ORDER BY
    RegistrationYear,
    RegistrationMonth;


/* =========================================================
   35. Find the newest registered members
   ========================================================= */

SELECT
    Members.MemberID,
    People.FirstName,
    People.LastName,
    Members.RegistrationDate
FROM Members
JOIN People
    ON Members.PersonID = People.PersonID
WHERE Members.RegistrationDate =
(
    SELECT MAX(RegistrationDate)
    FROM Members
);


/* =========================================================
   36. Find the oldest registered members
   ========================================================= */

SELECT
    Members.MemberID,
    People.FirstName,
    People.LastName,
    Members.RegistrationDate
FROM Members
JOIN People
    ON Members.PersonID = People.PersonID
WHERE Members.RegistrationDate =
(
    SELECT MIN(RegistrationDate)
    FROM Members
);


/* =========================================================
   37. Find members who have never borrowed a book
   ========================================================= */

SELECT
    Members.MemberID,
    People.FirstName,
    People.LastName
FROM Members
JOIN People
    ON Members.PersonID = People.PersonID
LEFT JOIN BorrowingRecords
    ON Members.MemberID = BorrowingRecords.MemberID
WHERE BorrowingRecords.BorrowingRecordID IS NULL;


/* =========================================================
   38. Find members who currently have borrowed books
   ========================================================= */

SELECT DISTINCT
    Members.MemberID,
    People.FirstName,
    People.LastName
FROM Members
JOIN People
    ON Members.PersonID = People.PersonID
JOIN BorrowingRecords
    ON Members.MemberID = BorrowingRecords.MemberID
WHERE BorrowingRecords.ActualReturnDate IS NULL;


/* =========================================================
   39. Find members with unpaid fines
   ========================================================= */

SELECT DISTINCT
    Members.MemberID,
    People.FirstName,
    People.LastName,
    Fines.FineAmount
FROM Members
JOIN People
    ON Members.PersonID = People.PersonID
JOIN Fines
    ON Members.MemberID = Fines.MemberID
WHERE Fines.PaymentStatus = 'Unpaid';


/* =========================================================
   40. Display complete member information including
       membership type, borrowing count and unpaid fine amount
   ========================================================= */

SELECT
    Members.MemberID,
    People.FirstName,
    People.LastName,
    MembershipTypes.TypeName AS MembershipType,
    Members.LibraryCardNumber,
    Members.RegistrationDate,
    Members.ExpirationDate,

    COUNT(DISTINCT BorrowingRecords.BorrowingRecordID)
        AS BorrowingCount,

    COALESCE(
        SUM(
            CASE
                WHEN Fines.PaymentStatus = 'Unpaid'
                THEN Fines.FineAmount
                ELSE 0
            END
        ),
        0
    ) AS UnpaidFineAmount

FROM Members

JOIN People
    ON Members.PersonID = People.PersonID

JOIN MembershipTypes
    ON Members.MembershipTypeID =
       MembershipTypes.MembershipTypeID

LEFT JOIN BorrowingRecords
    ON Members.MemberID =
       BorrowingRecords.MemberID

LEFT JOIN Fines
    ON Members.MemberID =
       Fines.MemberID

GROUP BY
    Members.MemberID,
    People.FirstName,
    People.LastName,
    MembershipTypes.TypeName,
    Members.LibraryCardNumber,
    Members.RegistrationDate,
    Members.ExpirationDate

ORDER BY
    People.FirstName,
    People.LastName;
