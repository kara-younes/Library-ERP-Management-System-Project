-- =============================================
-- Purchase Orders / Purchasing Management
-- =============================================


-- 1. Display all purchase orders.
SELECT *
FROM PurchaseOrders;


-- 2. Display purchase orders with supplier names.
SELECT
    PO.PurchaseOrderID,
    S.SupplierName,
    PO.OrderDate,
    PO.ExpectedDate,
    PO.Status
FROM PurchaseOrders PO
JOIN Suppliers S
    ON PO.SupplierID = S.SupplierID;


-- 3. Display pending purchase orders.
SELECT *
FROM PurchaseOrders
WHERE Status = 'Pending';


-- 4. Display completed purchase orders.
SELECT *
FROM PurchaseOrders
WHERE Status = 'Completed';


-- 5. Find overdue purchase orders based on expected date.
SELECT *
FROM PurchaseOrders
WHERE ExpectedDate < GETDATE()
  AND Status <> 'Completed';


-- 6. Find purchase orders expected within 7 days.
SELECT *
FROM PurchaseOrders
WHERE ExpectedDate BETWEEN GETDATE()
                       AND DATEADD(DAY, 7, GETDATE())
  AND Status <> 'Completed';


-- 7. Display purchase order details.
SELECT
    PD.PurchaseOrderID,
    PD.BookID,
    B.Title,
    PD.Quantity,
    PD.UnitPrice
FROM PurchaseDetails PD
JOIN Books B
    ON PD.BookID = B.BookID;


-- 8. Display purchase order with all books ordered.
SELECT
    PO.PurchaseOrderID,
    S.SupplierName,
    B.Title,
    PD.Quantity,
    PD.UnitPrice
FROM PurchaseOrders PO
JOIN Suppliers S
    ON PO.SupplierID = S.SupplierID
JOIN PurchaseDetails PD
    ON PO.PurchaseOrderID = PD.PurchaseOrderID
JOIN Books B
    ON PD.BookID = B.BookID
ORDER BY PO.PurchaseOrderID;


-- 9. Calculate total amount of each purchase order.
SELECT
    PO.PurchaseOrderID,
    SUM(PD.Quantity * PD.UnitPrice) AS TotalAmount
FROM PurchaseOrders PO
JOIN PurchaseDetails PD
    ON PO.PurchaseOrderID = PD.PurchaseOrderID
GROUP BY PO.PurchaseOrderID
ORDER BY PO.PurchaseOrderID;


-- 10. Calculate total quantity of books ordered per purchase order.
SELECT
    PO.PurchaseOrderID,
    SUM(PD.Quantity) AS TotalQuantity
FROM PurchaseOrders PO
JOIN PurchaseDetails PD
    ON PO.PurchaseOrderID = PD.PurchaseOrderID
GROUP BY PO.PurchaseOrderID
ORDER BY PO.PurchaseOrderID;


-- 11. Find the largest purchase order.
SELECT TOP 1
    PO.PurchaseOrderID,
    SUM(PD.Quantity * PD.UnitPrice) AS TotalAmount
FROM PurchaseOrders PO
JOIN PurchaseDetails PD
    ON PO.PurchaseOrderID = PD.PurchaseOrderID
GROUP BY PO.PurchaseOrderID
ORDER BY TotalAmount DESC;


-- 12. Find the most expensive purchased book.
SELECT TOP 1
    B.BookID,
    B.Title,
    PD.UnitPrice
FROM PurchaseDetails PD
JOIN Books B
    ON PD.BookID = B.BookID
ORDER BY PD.UnitPrice DESC;


-- 13. Calculate total purchasing expenditure.
SELECT
    SUM(PD.Quantity * PD.UnitPrice) AS TotalPurchasingExpenditure
FROM PurchaseDetails PD;


-- 14. Calculate total expenditure per supplier.
SELECT
    S.SupplierID,
    S.SupplierName,
    SUM(PD.Quantity * PD.UnitPrice) AS TotalExpenditure
FROM Suppliers S
JOIN PurchaseOrders PO
    ON S.SupplierID = PO.SupplierID
JOIN PurchaseDetails PD
    ON PO.PurchaseOrderID = PD.PurchaseOrderID
GROUP BY
    S.SupplierID,
    S.SupplierName
ORDER BY TotalExpenditure DESC;


-- 15. Generate a complete purchase report containing
--     supplier, order date, expected date, status,
--     books, quantities, unit prices and total amount.

SELECT
    PO.PurchaseOrderID,
    S.SupplierName,
    PO.OrderDate,
    PO.ExpectedDate,
    PO.Status,
    B.Title,
    PD.Quantity,
    PD.UnitPrice,
    (PD.Quantity * PD.UnitPrice) AS TotalAmount
FROM PurchaseOrders PO
JOIN Suppliers S
    ON PO.SupplierID = S.SupplierID
JOIN PurchaseDetails PD
    ON PO.PurchaseOrderID = PD.PurchaseOrderID
JOIN Books B
    ON PD.BookID = B.BookID
ORDER BY PO.PurchaseOrderID, B.Title;