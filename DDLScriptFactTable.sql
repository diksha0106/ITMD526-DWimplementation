-- Creating Fact Tables. 

-- FactSales - This fact table captures sales transactions and is linked to dimensions for customers, products, dates, currency, and shipping methods.  
-- It is derived from Orders.csv, OrderStatus.csv, PaymentMethod.csv, and ShippingMethod.csv.

CREATE OR REPLACE TABLE FactSales (
    SalesKey INT AUTOINCREMENT PRIMARY KEY,
    CustomerKey INT REFERENCES DimCustomer(CustomerKey), -- Links to customer details
    ProductKey INT REFERENCES DimProduct(ProductKey), -- Links to product details
    DateKey INT REFERENCES DimDate(DateKey), -- Links to order date
    CurrencyKey INT REFERENCES DimCurrency(CurrencyKey),
    ShippingMethodKey INT REFERENCES DimShippingMethod(ShippingMethodKey), -- Links to shipping method details
    OrderStatus STRING, -- Order status from OrderStatus.csv
    PaymentMethod STRING, -- Payment method from PaymentMethod.csv
    Quantity INT, -- Quantity of products sold
    TotalPrice FLOAT -- Final price after discounts and currency conversion
);

--Insert query to add records into Fact Table
INSERT INTO FactSales (
    CustomerKey, ProductKey, DateKey, ShippingMethodKey, OrderStatus, PaymentMethod, Quantity, TotalPrice
)
SELECT 
    c.CustomerKey, 
    p.ProductKey, 
    d.DateKey, 
    s.ShippingMethodKey, 
    COALESCE(os.StatusName, 'Unknown') AS OrderStatus,  -- Fetch correct status name
    pm.PAYMENTMETHODNAME, 
    o.Quantity, 
    (o.Quantity * o.UnitPrice) AS TotalPrice  -- Correct calculation of TotalPrice
FROM Orders o
JOIN DimCustomer c ON o.CustomerID = c.CustomerID
JOIN DimProduct p ON o.ProductID = p.ProductID
JOIN DimDate d ON TO_CHAR(o.OrderDate, 'YYYYMMDD')::INT = d.DateKey  
LEFT JOIN DimShippingMethod s ON o.ShippingMethodID = s.ShippingMethodID
LEFT JOIN PAYMENT_METHODS pm ON o.PaymentMethodID = pm.PaymentMethodID
LEFT JOIN ORDER_STATUSES os ON o.StatusID = os.StatusID;


-- FactInventory - This fact table tracks inventory transactions over time and is linked to dimensions for products, warehouses, and dates. 
-- It is derived from Inventory.json and Warehouse.json.

CREATE OR REPLACE TABLE FactInventory (
    InventoryKey INT AUTOINCREMENT PRIMARY KEY,
    ProductKey INT REFERENCES DimProduct(ProductKey), -- Links to product details
    WarehouseKey INT REFERENCES DimWarehouse(WarehouseKey), -- Links to warehouse details
    DateKey INT REFERENCES DimDate(DateKey), -- Links to inventory transaction date
    StockLevel INT, -- Current stock level of the product
    SafetyStockLevel INT, -- Safety stock threshold
    LastUpdated DATE -- Last date when stock levels were updated
);

-- Insert query to add records to Fact Inventory
INSERT INTO FactInventory (
    ProductKey, WarehouseKey, DateKey, StockLevel, SafetyStockLevel, LastUpdated
)
SELECT 
    p.ProductKey, 
    w.WarehouseKey, 
    d.DateKey, 
    i.StockLevel, 
    i.SafetyStockLevel, 
    i.LastUpdated
FROM Inventory i
JOIN DimProduct p ON i.ProductID = p.ProductID
JOIN DimWarehouse w ON i.WarehouseID = w.WarehouseID
JOIN DimDate d ON TO_CHAR(i.LastUpdated, 'YYYYMMDD')::INT = d.DateKey;





