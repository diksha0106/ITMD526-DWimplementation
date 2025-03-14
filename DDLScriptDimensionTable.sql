-- Creating Dimension Tables

-- DimCustomer - This dimension table is derived from Customers.csv, BusinessType.csv, and Loyalty.csv
CREATE OR REPLACE TABLE DimCustomer (
    CustomerKey INT AUTOINCREMENT PRIMARY KEY,
    CustomerID INT UNIQUE,
    FullName STRING,
    Email STRING UNIQUE,
    Phone STRING UNIQUE,
    AccountCreationDate DATE,
    Location STRING,
    BusinessType STRING, -- Derived from BusinessType.csv
    LoyaltyTier STRING, -- Derived from Loyalty.csv
    EffectiveDate DATE,
    EndDate DATE DEFAULT NULL,
    IsCurrent BOOLEAN DEFAULT TRUE
);

-- Insert query to add records into DimCustomer
INSERT INTO DimCustomer (
    CustomerID, FullName, Email, Phone, AccountCreationDate, Location, BusinessType, LoyaltyTier, EffectiveDate, EndDate, IsCurrent
)
SELECT 
    c.CustomerID, 
    CONCAT(c.FirstName, ' ', c.LastName) AS FullName, 
    c.Email, 
    c.Phone, 
    CAST(c.AccountCreationDate AS DATE), 
    c.LocationID,  -- Assuming `LocationID` is mapped to another dimension
    COALESCE(bt.BusinessTypeName, 'Unknown') AS BusinessType,  
    COALESCE(l.LoyaltyTier, 'Standard') AS LoyaltyTier,  
    CURRENT_DATE, 
    NULL, 
    TRUE
FROM Customers c
LEFT JOIN BUSINESS_TYPES bt ON c.BusinessTypeID = bt.BusinessTypeID  
LEFT JOIN Loyalty l ON c.LoyaltyID = l.LoyaltyID;


-- DimProduct - This dimension table is derived from Products.csv, Category.csv, Supplier.csv, and Pricing.xml
CREATE OR REPLACE TABLE DimProduct (
    ProductKey INT AUTOINCREMENT PRIMARY KEY,
    ProductID INT UNIQUE,
    ProductName STRING,
    Category STRING, -- Derived from Category.csv
    Supplier STRING, -- Derived from Supplier.csv
    Width FLOAT,
    Height FLOAT,
    Color STRING,
    Weight FLOAT,
    BasePrice FLOAT, -- Derived from Pricing.xml
    Discount FLOAT, -- Derived from Pricing.xml
    FinalPrice FLOAT, -- Derived from Pricing.xml
    EffectiveDate DATE -- Derived from Pricing.xml
);

-- Insert query to add records to DimProduct. 
INSERT INTO DimProduct (
    ProductID, ProductName, Category, Supplier, Width, Height, Color, Weight, BasePrice, Discount, FinalPrice, EffectiveDate
)
SELECT 
    p.ProductID, 
    p.ProductName, 
    c.CategoryName, 
    s.SupplierName, 
    p.Width, 
    p.Height, 
    p.Color, 
    p.Weight, 
    COALESCE(pr.BasePrice, 0) AS BasePrice, 
    COALESCE(pr.Discount, 0) AS Discount, 
    COALESCE(pr.FinalPrice, p.ProductionCost) AS FinalPrice,  
    COALESCE(pr.EffectiveDate, CURRENT_DATE) AS EffectiveDate
FROM Products p
JOIN CATEGORIES c ON p.CategoryID = c.CategoryID
JOIN SUPPLIERS s ON p.SupplierID = s.SupplierID
LEFT JOIN Pricing pr ON p.ProductID = pr.ProductID;


-- DimDate - This dimension table is derived from Orders.csv.
CREATE OR REPLACE TABLE DimDate (
    DateKey INT PRIMARY KEY,
    FullDate DATE UNIQUE,
    Year INT,
    Month INT,
    Day INT,
    Quarter INT
);

-- Insert query to add records to DimDate.
INSERT INTO DimDate (DateKey, FullDate, Year, Month, Day, Quarter)
SELECT DISTINCT 
    TO_CHAR(i.LastUpdated, 'YYYYMMDD')::INT AS DateKey, 
    i.LastUpdated AS FullDate, 
    EXTRACT(YEAR FROM i.LastUpdated) AS Year, 
    EXTRACT(MONTH FROM i.LastUpdated) AS Month, 
    EXTRACT(DAY FROM i.LastUpdated) AS Day, 
    CASE 
        WHEN EXTRACT(MONTH FROM i.LastUpdated) BETWEEN 1 AND 3 THEN 1
        WHEN EXTRACT(MONTH FROM i.LastUpdated) BETWEEN 4 AND 6 THEN 2
        WHEN EXTRACT(MONTH FROM i.LastUpdated) BETWEEN 7 AND 9 THEN 3
        ELSE 4 
    END AS Quarter
FROM Inventory i
WHERE NOT EXISTS (
    SELECT 1 FROM DimDate d WHERE d.DateKey = TO_CHAR(i.LastUpdated, 'YYYYMMDD')::INT
);



-- DimCurrency - This dimension table is derived from Currency.xml and Pricing.xml
CREATE OR REPLACE TABLE DimCurrency (
    CurrencyKey INT AUTOINCREMENT PRIMARY KEY,
    CurrencyName STRING UNIQUE,
    EffectiveDate DATE,
    EndDate DATE DEFAULT NULL,
    IsCurrent BOOLEAN DEFAULT TRUE
);

--Insert query to add records to DimCurrency. 
INSERT INTO DimCurrency (
    CurrencyName, EffectiveDate, EndDate, IsCurrent
)
SELECT 
    c.CurrencyName, 
    MIN(p.EffectiveDate) AS EffectiveDate,  
    NULL AS EndDate, 
    TRUE AS IsCurrent
FROM CURRENCIES c
JOIN Pricing p ON c.CurrencyID = p.CurrencyID
GROUP BY c.CurrencyName;

-- DimWarehouse - This dimension table is derived from Warehouse.json, Inventory.json, and Locations.csv
CREATE OR REPLACE TABLE DimWarehouse (
    WarehouseKey INT AUTOINCREMENT PRIMARY KEY,
    WarehouseID INT UNIQUE, -- Derived from Warehouse.json
    WarehouseName STRING UNIQUE, -- Derived from Warehouse.json
    Location STRING -- Derived from Locations.csv
);

-- Insert query to add records to DimWarehouse. 
INSERT INTO DimWarehouse (
    WarehouseID, WarehouseName, Location
)
SELECT 
    w.WarehouseID, 
    w.WarehouseName, 
    COALESCE(l.LOCATIONNAME, 'Unknown') AS Location  -- Handle missing locations
FROM WAREHOUSES w
LEFT JOIN Locations l ON w.WarehouseID = l.LOCATIONID;


-- DimShippingMethod - This dimension table is derived from ShippingMethod.csv
CREATE OR REPLACE TABLE DimShippingMethod (
    ShippingMethodKey INT AUTOINCREMENT PRIMARY KEY,
    ShippingMethodID INT UNIQUE,
    ShippingMethodName STRING,
    Carrier STRING,
    EstimatedDeliveryDays INT
);

--Insert query to add records to DimShippingMethod. 
INSERT INTO DimShippingMethod (
    ShippingMethodID, ShippingMethodName
)
SELECT 
    ShippingMethodID, 
    ShippingMethodName
FROM SHIPPING_METHODS;


