-- =============================================
-- Membership Types Queries
-- =============================================

-- 1. Display all membership types.
SELECT *
FROM MembershipTypes;


-- 2. Display only active membership types.
SELECT *
FROM MembershipTypes
WHERE IsActive = 1;


-- 3. Display inactive membership types.
SELECT *
FROM MembershipTypes
WHERE IsActive = 0;


-- 4. Sort membership types by annual fee.
SELECT *
FROM MembershipTypes
ORDER BY AnnualFee ASC;


-- 5. Sort membership types by borrowing duration.
SELECT *
FROM MembershipTypes
ORDER BY LoanDurationDays ASC;


-- 6. Find the cheapest membership type.
SELECT *
FROM MembershipTypes
WHERE AnnualFee = (
    SELECT MIN(AnnualFee)
    FROM MembershipTypes
);


-- 7. Find the membership type with the longest borrowing duration.
SELECT *
FROM MembershipTypes
WHERE LoanDurationDays = (
    SELECT MAX(LoanDurationDays)
    FROM MembershipTypes
);


-- 8. Count members belonging to each membership type.
SELECT 
    MT.TypeName,
    COUNT(M.MemberID) AS MembersCount
FROM MembershipTypes MT
LEFT JOIN Members M
    ON MT.MembershipTypeID = M.MembershipTypeID
GROUP BY MT.TypeName;


-- 9. Calculate total annual membership revenue
--    assuming every member pays the membership fee.
SELECT 
    SUM(MT.AnnualFee) AS TotalAnnualRevenue
FROM Members M
JOIN MembershipTypes MT
    ON M.MembershipTypeID = MT.MembershipTypeID;


-- 10. Display membership type statistics:
--     name, duration, fee and number of members.
SELECT
    MT.TypeName,
    MT.LoanDurationDays,
    MT.AnnualFee,
    COUNT(M.MemberID) AS MembersCount
FROM MembershipTypes MT
LEFT JOIN Members M
    ON MT.MembershipTypeID = M.MembershipTypeID
GROUP BY
    MT.TypeName,
    MT.LoanDurationDays,
    MT.AnnualFee;

