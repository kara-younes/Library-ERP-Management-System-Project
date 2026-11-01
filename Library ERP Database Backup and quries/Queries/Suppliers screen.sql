-- =============================================
-- Suppliers & Purchasing
-- =============================================


-- 1. Display all suppliers.
SELECT *
FROM Suppliers;


-- 2. Display active suppliers.
SELECT *
FROM Suppliers
WHERE IsActive = 1;


-- 3. Display inactive suppliers.
SELECT *
FROM Suppliers
WHERE IsActive = 0;


-- 4. Search suppliers by name.
SELECT *
FROM Suppliers
WHERE SupplierName LIKE '%Tech%';


-- 5. Search suppliers by contact person.
SELECT *
FROM Suppliers
WHERE ContactPerson LIKE '%John%';


-- 6. Search suppliers by email.
SELECT *
FROM Suppliers
WHERE Email LIKE '%@gmail.com%';


-- 7. Find suppliers with purchase orders.
SELECT DISTINCT
    S.SupplierID,
    S.SupplierName
FROM Suppliers S
JOIN PurchaseOrders PO
    ON S.SupplierID = PO.SupplierID;


-- 8. Count purchase orders per supplier.
SELECT
    S.SupplierID,
    S.SupplierName,
    COUNT(PO.PurchaseOrderID) AS OrderCount
FROM Suppliers S
LEFT JOIN PurchaseOrders PO
    ON S.SupplierID = PO.SupplierID
GROUP BY
    S.SupplierID,
    S.SupplierName
ORDER BY OrderCount DESC;

-- 9. Calculate total purchasing amount per supplier.
SELECT
    S.SupplierID,
    S.SupplierName,
    SUM(PD.Quantity * PD.UnitPrice) AS TotalPurchasingAmount
FROM Suppliers S
JOIN PurchaseOrders PO
    ON S.SupplierID = PO.SupplierID
JOIN PurchaseDetails PD
    ON PO.PurchaseOrderID = PD.PurchaseOrderID
GROUP BY
    S.SupplierID,
    S.SupplierName
ORDER BY TotalPurchasingAmount DESC;


-- 10. Display supplier performance information
--     including orders, completed orders,
--     pending orders and total spending.

SELECT
    S.SupplierID,
    S.SupplierName,

    COUNT(DISTINCT PO.PurchaseOrderID) AS TotalOrders,

    COUNT(DISTINCT CASE
        WHEN PO.Status = 'Completed'
        THEN PO.PurchaseOrderID
    END) AS CompletedOrders,

    COUNT(DISTINCT CASE
        WHEN PO.Status = 'Pending'
        THEN PO.PurchaseOrderID
    END) AS PendingOrders,

    COALESCE(SUM(PD.Quantity * PD.UnitPrice), 0) AS TotalSpending

FROM Suppliers S
LEFT JOIN PurchaseOrders PO
    ON S.SupplierID = PO.SupplierID
LEFT JOIN PurchaseDetails PD
    ON PO.PurchaseOrderID = PD.PurchaseOrderID

GROUP BY
    S.SupplierID,
    S.SupplierName

ORDER BY TotalSpending DESC;