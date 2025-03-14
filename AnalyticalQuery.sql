-- Query to return products by revenue

SELECT 
    p.ProductName, 
    SUM(fs.Quantity) AS TotalQuantitySold, 
    SUM(fs.TotalPrice) AS TotalRevenue
FROM FactSales fs
JOIN DimProduct p ON fs.ProductKey = p.ProductKey
GROUP BY p.ProductName
ORDER BY TotalRevenue DESC;

-- Query to output best performing warehouses. 
SELECT 
    w.WarehouseName, 
    SUM(fs.TotalPrice) AS TotalSales
FROM FactSales fs
JOIN FactInventory fi ON fs.ProductKey = fi.ProductKey
JOIN DimWarehouse w ON fi.WarehouseKey = w.WarehouseKey
GROUP BY w.WarehouseName
ORDER BY TotalSales DESC;

-- Query to output customer segmentation by total spending
SELECT 
    c.FullName AS CustomerName, 
    c.LoyaltyTier, 
    SUM(fs.TotalPrice) AS TotalSpending
FROM FactSales fs
JOIN DimCustomer c ON fs.CustomerKey = c.CustomerKey
GROUP BY c.FullName, c.LoyaltyTier
ORDER BY TotalSpending DESC
LIMIT 5;

-- Query to output monthly sales performance
SELECT 
    d.Year, 
    d.Month, 
    SUM(fs.TotalPrice) AS MonthlyRevenue
FROM FactSales fs
JOIN DimDate d ON fs.DateKey = d.DateKey
GROUP BY d.Year, d.Month
ORDER BY d.Year, d.Month;

-- Query to output products below stock level
SELECT 
    w.WarehouseName, 
    p.ProductName, 
    fi.StockLevel, 
    fi.SafetyStockLevel
FROM FactInventory fi
JOIN DimWarehouse w ON fi.WarehouseKey = w.WarehouseKey
JOIN DimProduct p ON fi.ProductKey = p.ProductKey
WHERE fi.StockLevel < fi.SafetyStockLevel
ORDER BY fi.StockLevel ASC
LIMIT 10;


