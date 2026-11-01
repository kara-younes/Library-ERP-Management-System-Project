/* ============================================================
   LIBRARY ERP
   SCREEN 1 - DASHBOARD / HOME
   20 SQL QUERIES
   ============================================================ */


/* ============================================================
   1. Count the total number of books
   ============================================================ */

SELECT 
    COUNT(*) AS TotalBooks
FROM Books;


/* ============================================================
   2. Count the total number of physical book copies
   ============================================================ */

SELECT 
    COUNT(*) AS TotalCopies
FROM BookCopies;


/* ============================================================
   3. Count available book copies
   ============================================================ */

SELECT 
    COUNT(*) AS AvailableCopies
FROM BookCopies
WHERE AvailabilityStatus = 'Available';


/* ============================================================
   4. Count currently borrowed copies
   ============================================================ */

SELECT 
    COUNT(*) AS BorrowedCopies
FROM BookCopies
WHERE AvailabilityStatus = 'Borrowed';


/* ============================================================
   5. Count reserved copies
   ============================================================ */

SELECT 
    COUNT(*) AS ReservedCopies
FROM BookCopies
WHERE AvailabilityStatus = 'Reserved';


/* ============================================================
   6. Count damaged copies
   ============================================================ */

SELECT 
    COUNT(*) AS DamagedCopies
FROM BookCopies
WHERE AvailabilityStatus = 'Damaged';


/* ============================================================
   7. Count total active members
   ============================================================ */

SELECT 
    COUNT(*) AS ActiveMembers
FROM Members
WHERE IsActive = 1;


/* ============================================================
   8. Count members by membership type
   ============================================================ */

SELECT 
    MembershipTypes.TypeName AS MembershipType,
    COUNT(*) AS MembersCount
FROM Members
INNER JOIN MembershipTypes
    ON Members.MembershipTypeID = MembershipTypes.MembershipTypeID
GROUP BY MembershipTypes.TypeName;


/* ============================================================
   9. Count active library users by role
   ============================================================ */

SELECT 
    Roles.RoleName,
    COUNT(*) AS UsersCount
FROM Users
INNER JOIN Roles
    ON Users.RoleID = Roles.RoleID
WHERE Users.IsActive = 1
GROUP BY Roles.RoleName;


/* ============================================================
   10. Count books by category
   ============================================================ */

SELECT 
    Categories.CategoryName,
    COUNT(*) AS BooksCount
FROM Books
INNER JOIN Categories
    ON Categories.CategoryID = Books.CategoryID
GROUP BY Categories.CategoryName;


/* ============================================================
   11. Count books by language
   ============================================================ */

SELECT 
    Languages.LanguageName,
    COUNT(*) AS BooksCount
FROM Books
INNER JOIN Languages
    ON Languages.LanguageID = Books.LanguageID
GROUP BY Languages.LanguageName;


/* ============================================================
   12. Count authors in the system
   ============================================================ */

SELECT 
    COUNT(*) AS AuthorsCount
FROM Authors;


/* ============================================================
   13. Count suppliers
   ============================================================ */

SELECT 
    COUNT(*) AS SuppliersCount
FROM Suppliers;


/* ============================================================
   14. Calculate total purchase orders
   ============================================================ */

SELECT 
    COUNT(*) AS TotalPurchaseOrders
FROM PurchaseOrders;


/* ============================================================
   15. Calculate pending purchase orders
   ============================================================ */

SELECT 
    COUNT(*) AS PendingPurchaseOrders
FROM PurchaseOrders
WHERE Status = 'Pending';


/* ============================================================
   16. Calculate total value of all purchase orders
   ============================================================ */

SELECT 
    COALESCE(SUM(Quantity * UnitPrice), 0) AS TotalPurchaseValue
FROM PurchaseDetails;


/* ============================================================
   17. Calculate total unpaid fines
   ============================================================ */

SELECT 
    COALESCE(SUM(FineAmount), 0) AS TotalUnpaidFines
FROM Fines
WHERE PaymentStatus = 'Unpaid';


/* ============================================================
   18. Count currently active borrowing records
   ============================================================ */

SELECT 
    COUNT(*) AS ActiveBorrowingRecords
FROM BorrowingRecords
WHERE ActualReturnDate IS NULL;


/* ============================================================
   19. Count overdue borrowing records
   ============================================================ */

SELECT 
    COUNT(*) AS OverdueBorrowingRecords
FROM BorrowingRecords
WHERE DueDate < CAST(GETDATE() AS DATE)
  AND ActualReturnDate IS NULL;


/* ============================================================
   20. Return a complete dashboard summary
   ============================================================ */

SELECT

    /* Books */
    (SELECT COUNT(*)
     FROM Books) AS TotalBooks,

    /* Physical Copies */
    (SELECT COUNT(*)
     FROM BookCopies) AS TotalCopies,

    /* Available Copies */
    (SELECT COUNT(*)
     FROM BookCopies
     WHERE AvailabilityStatus = 'Available') AS AvailableCopies,

    /* Borrowed Copies */
    (SELECT COUNT(*)
     FROM BookCopies
     WHERE AvailabilityStatus = 'Borrowed') AS BorrowedCopies,

    /* Reserved Copies */
    (SELECT COUNT(*)
     FROM BookCopies
     WHERE AvailabilityStatus = 'Reserved') AS ReservedCopies,

    /* Damaged Copies */
    (SELECT COUNT(*)
     FROM BookCopies
     WHERE AvailabilityStatus = 'Damaged') AS DamagedCopies,

    /* Active Members */
    (SELECT COUNT(*)
     FROM Members
     WHERE IsActive = 1) AS ActiveMembers,

    /* Active Borrowings */
    (SELECT COUNT(*)
     FROM BorrowingRecords
     WHERE ActualReturnDate IS NULL) AS ActiveBorrowings,

    /* Overdue Books */
    (SELECT COUNT(*)
     FROM BorrowingRecords
     WHERE ActualReturnDate IS NULL
       AND DueDate < CAST(GETDATE() AS DATE)) AS OverdueBooks,

    /* Active Reservations */
    (SELECT COUNT(*)
     FROM Reservations
     WHERE Status = 'Pending') AS ActiveReservations,

    /* Unpaid Fines */
    (SELECT COALESCE(SUM(FineAmount), 0)
     FROM Fines
     WHERE PaymentStatus = 'Unpaid') AS TotalUnpaidFines;