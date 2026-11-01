-- =============================================
-- Screen 8 — Book Requests
-- =============================================


-- 131. Display all book requests.
SELECT *
FROM BookRequests;


-- 132. Display requests with member names.
SELECT
    BR.RequestID,
    BR.MemberID,
    P.FirstName,
    P.LastName,
    BR.RequestedTitle,
    BR.RequestDate,
    BR.RequestStatus
FROM BookRequests BR
JOIN Members M
    ON BR.MemberID = M.MemberID
JOIN People P
    ON M.PersonID = P.PersonID;


-- 133. Display pending requests.
SELECT *
FROM BookRequests
WHERE RequestStatus = 'Pending';


-- 134. Display approved requests.
SELECT *
FROM BookRequests
WHERE RequestStatus = 'Approved';


-- 135. Display rejected requests.
SELECT *
FROM BookRequests
WHERE RequestStatus = 'Rejected';


-- 136. Display completed requests.
SELECT *
FROM BookRequests
WHERE RequestStatus = 'Completed';


-- 137. Search requests by requested title.
SELECT *
FROM BookRequests
WHERE RequestedTitle LIKE '%SQL%';


-- 138. Count requests by status.
SELECT
    RequestStatus,
    COUNT(*) AS RequestCount
FROM BookRequests
GROUP BY RequestStatus
ORDER BY RequestCount DESC;


-- 139. Find the most requested book title.
SELECT TOP 1
    RequestedTitle,
    COUNT(*) AS TitleCount
FROM BookRequests
GROUP BY RequestedTitle
ORDER BY TitleCount DESC;


-- 140. Display complete request information with
--      member, title, author, ISBN, date and status.
SELECT
    BR.RequestID,
    P.FirstName,
    P.LastName,
    BR.RequestedTitle,
    P2.FirstName AS AuthorFirstName,
    P2.LastName AS AuthorLastName,
    B.ISBN,
    BR.RequestDate,
    BR.RequestStatus
FROM BookRequests BR
JOIN Members M
    ON BR.MemberID = M.MemberID
JOIN People P
    ON M.PersonID = P.PersonID
LEFT JOIN Books B
    ON BR.RequestedTitle = B.Title
LEFT JOIN BookAuthors BA
    ON B.BookID = BA.BookID
LEFT JOIN Authors A
    ON BA.AuthorID = A.AuthorID
LEFT JOIN People P2
    ON A.PersonID = P2.PersonID;