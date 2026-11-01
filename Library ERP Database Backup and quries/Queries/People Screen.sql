-- =============================================
-- Screen 4 — People Management
-- =============================================

-- 51. Display all people.
SELECT *
FROM People;


-- 52. Search people by first name.
SELECT *
FROM People
WHERE FirstName LIKE '%John%';


-- 53. Search people by last name.
SELECT *
FROM People
WHERE LastName LIKE '%Smith%';


-- 54. Search people by full name.
SELECT *
FROM People
WHERE CONCAT(FirstName, ' ', LastName) LIKE '%John Smith%';


-- 55. Search people by email.
SELECT *
FROM People
WHERE Email LIKE '%@gmail.com%';


-- 56. Search people by phone.
SELECT *
FROM People
WHERE Phone LIKE '%555%';


-- 57. Filter people by gender.
SELECT *
FROM People
WHERE Gender = 'F';


-- 58. Filter people by country.
SELECT *
FROM People
WHERE Country = 'USA';


-- 59. Find people born before a specified date.
SELECT *
FROM People
WHERE DateOfBirth < '2000-01-01';


-- 60. Find people born after a specified date.
SELECT *
FROM People
WHERE DateOfBirth > '2000-01-01';


-- 61. Calculate the age of each person.
SELECT
    PersonID,
    FirstName,
    LastName,
    DateOfBirth,
    DATEDIFF(YEAR, DateOfBirth, GETDATE())
    - CASE
        WHEN DATEADD(YEAR, DATEDIFF(YEAR, DateOfBirth, GETDATE()), DateOfBirth)
             > GETDATE()
        THEN 1
        ELSE 0
      END AS Age
FROM People
ORDER BY Age DESC;


-- 62. Count people by country.
SELECT
    Country,
    COUNT(*) AS CountryPeople
FROM People
GROUP BY Country
ORDER BY Country;


-- 63. Count people by gender.
SELECT
    CASE
        WHEN Gender = 'M' THEN 'Male'
        WHEN Gender = 'F' THEN 'Female'
        ELSE 'Unknown'
    END AS Gender,
    COUNT(*) AS PeopleGender
FROM People
GROUP BY Gender
ORDER BY Gender;


-- 64. Find people who are authors.
SELECT
    P.PersonID,
    P.FirstName,
    P.LastName,
    A.Biography,
    A.Website
FROM Authors A
JOIN People P
    ON A.PersonID = P.PersonID;


-- 65. Find people who are registered library members.
SELECT
    P.PersonID,
    P.FirstName,
    P.LastName,
    M.LibraryCardNumber,
    M.RegistrationDate
FROM Members M
JOIN People P
    ON M.PersonID = P.PersonID;