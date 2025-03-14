-- Step 1: Create a new Snowflake Warehouse
CREATE OR REPLACE WAREHOUSE BLINDS_MANUFACTURING_WH
  WITH WAREHOUSE_SIZE = 'XSMALL' 
  AUTO_SUSPEND = 300 
  AUTO_RESUME = TRUE 
  INITIALLY_SUSPENDED = TRUE;

-- Step 2: Create a new Database
CREATE DATABASE BLINDS_MANUFACTURING_DB;

-- Step 3: Use the created database
USE DATABASE BLINDS_MANUFACTURING_DB;

-- Step 4: Create the database schema
CREATE SCHEMA BLINDS_SCHEMA;
USE SCHEMA BLINDS_SCHEMA;

-- Step 5: Create Customers Table
CREATE TABLE CUSTOMERS (
    CustomerID INT PRIMARY KEY,
    FirstName STRING,
    LastName STRING,
    Email STRING UNIQUE,
    Phone STRING UNIQUE,
    AccountCreationDate DATE,
    LocationID INT,
    BusinessTypeID INT,
    LoyaltyID INT,
    FOREIGN KEY (LocationID) REFERENCES LOCATIONS(LocationID),
    FOREIGN KEY (BusinessTypeID) REFERENCES BUSINESS_TYPES(BusinessTypeID),
    FOREIGN KEY (LoyaltyID) REFERENCES LOYALTY(LoyaltyID)
);

-- Step 6: Create Location Table
CREATE TABLE LOCATIONS (
    LocationID INT PRIMARY KEY,
    LocationName STRING UNIQUE
);

-- Step 7: Create BusinessType Table
CREATE TABLE BUSINESS_TYPES (
    BusinessTypeID INT PRIMARY KEY,
    BusinessTypeName STRING UNIQUE
);

-- Step 8: Create Loyalty Table
CREATE TABLE LOYALTY (
    LoyaltyID INT PRIMARY KEY,
    LoyaltyTier STRING UNIQUE,
    DiscountRate FLOAT,
    PointsRequired INT
);

-- Step 9: Create Orders Table
CREATE TABLE ORDERS (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    ProductID INT,
    Quantity INT,
    UnitPrice FLOAT,
    OrderDate DATE,
    DeliveryDate DATE,
    PaymentMethodID INT,
    ShippingMethodID INT,
    StatusID INT,
    FOREIGN KEY (CustomerID) REFERENCES CUSTOMERS(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES PRODUCTS(ProductID),
    FOREIGN KEY (PaymentMethodID) REFERENCES PAYMENT_METHODS(PaymentMethodID),
    FOREIGN KEY (ShippingMethodID) REFERENCES SHIPPING_METHODS(ShippingMethodID),
    FOREIGN KEY (StatusID) REFERENCES ORDER_STATUSES(StatusID)
);

-- Step 10: Create PaymentMethod Table
CREATE TABLE PAYMENT_METHODS (
    PaymentMethodID INT PRIMARY KEY,
    PaymentMethodName STRING UNIQUE
);

-- Step 11: Create ShippingMethod Table
CREATE TABLE SHIPPING_METHODS (
    ShippingMethodID INT PRIMARY KEY,
    ShippingMethodName STRING UNIQUE
);

-- Step 12: Create OrderStatus Table
CREATE TABLE ORDER_STATUSES (
    StatusID INT PRIMARY KEY,
    StatusName STRING UNIQUE
);

-- Step 13: Create Products Table
CREATE TABLE PRODUCTS (
    ProductID INT PRIMARY KEY,
    ProductName STRING,
    Width FLOAT,
    Height FLOAT,
    Color STRING,
    Weight FLOAT,
    ProductionCost FLOAT,
    CategoryID INT,
    SupplierID INT,
    FOREIGN KEY (CategoryID) REFERENCES CATEGORIES(CategoryID),
    FOREIGN KEY (SupplierID) REFERENCES SUPPLIERS(SupplierID)
);

-- Step 14: Create Category Table
CREATE TABLE CATEGORIES (
    CategoryID INT PRIMARY KEY,
    CategoryName STRING UNIQUE
);

-- Step 15: Create Supplier Table
CREATE TABLE SUPPLIERS (
    SupplierID INT PRIMARY KEY,
    SupplierName STRING UNIQUE
);

-- Step 16: Create Pricing Table
CREATE TABLE PRICING (
    ProductID INT PRIMARY KEY,
    BasePrice FLOAT,
    Discount FLOAT,
    FinalPrice FLOAT,
    EffectiveDate DATE,
    CurrencyID INT,
    FOREIGN KEY (ProductID) REFERENCES PRODUCTS(ProductID),
    FOREIGN KEY (CurrencyID) REFERENCES CURRENCIES(CurrencyID)
);

-- Step 17: Create Currency Table
CREATE TABLE CURRENCIES (
    CurrencyID INT PRIMARY KEY,
    CurrencyName STRING UNIQUE
);

-- Step 18: Create Inventory Table
CREATE TABLE INVENTORY (
    ProductID INT PRIMARY KEY,
    WarehouseID INT,
    StockLevel INT,
    SafetyStockLevel INT,
    ReplenishmentDate DATE,
    LastUpdated DATE,
    FOREIGN KEY (WarehouseID) REFERENCES WAREHOUSES(WarehouseID),
    FOREIGN KEY (ProductID) REFERENCES PRODUCTS(ProductID)
);

-- Step 19: Create Warehouse Table
CREATE TABLE WAREHOUSES (
    WarehouseID INT PRIMARY KEY,
    WarehouseName STRING UNIQUE
);



