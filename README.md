# ITMD526-DWimplementation
 Data Warehouse Implementation Project
 
 ## Overview
 In this project, we create a data warehouse for a windows blinds manufacturing company. The goal is to integrate data from various sources into a structured data warehouse that supports order management, inventory tracking, pricing optimization and customer analytics. The company operates through multiple warehouses and serves customers via online orders which requires accurate inventory tracking, pricing updates, and customer management. This project aims to combine and optimize these data sources for reporting and decision-making. The system processes data from multiple sources, including customer records, order transactions, product catalogs, pricing details, and warehouse inventory levels. These sources interact with each other to maintain real-time business operations. 
 
 ## Part 1: Data Sourcing
 
 ### Data Sources: 
 1.	Customers.csv – This file stores information about customers, including personal details, business type, and loyalty status. (CSV file)
 2.	Orders.csv – This file stores details about customer orders, including order status, payment method, and shipping details. (CSV file)
 3.	Products.csv – This file stores details about the products, including dimensions, category, supplier, and production cost. (CSV file)
 4.	Pricing.xml – This file stores pricing details for products, including base price, discount, final price, and currency. (XML file) 
 5.	Inventory.json – This file stores details about product stock levels, safety stock levels, and replenishment schedules. (JSON file)
 
 Each data source have 200 records.
 
 ### Data Relationships: 
 1.	Orders.csv is linked to Customers.csv through CustomerID. 
 2.	Orders.csv is linked to Products.xlsx through ProductID. 
 3.	Pricing.xlsx is linked to Products.xml through ProductID. 
 4.	Inventory.json is linked to Products.xlsx through ProductID.
 
 ### Entity Relationship Diagram: 
 ![image](https://github.com/user-attachments/assets/a6857901-b964-402a-b2d1-932adc67fdd3)
 
 Customers -> Orders (One-to-Many)
 
 Products -> Orders (One-to-Many)
 
 Products -> Pricing (One-to-One)
 
 Products -> Inventory (One-to-Many) 
 
 ### Data Dictionary: 
 
 Customers.csv
 | Attributes      | Data Type  | Description |
 |-----------------|-----------|-------------|
 | `CustomerID`    | Integer   | Primary Key |
 | `FirstName`     | String    | Customer’s first name |
 | `LastName`      | String    | Customer’s last name |
 | `Location`      | String    | Geographic location like a city |
 | `BusinessType`  | String    | Types of business like Retail, Contractor, Wholesale, Designer |
 | `Email`         | String    | Customer’s email address |
 | `Phone`         | String    | Customer’s phone number |
 | `AccountCreationDate` | DateTime | Date when the customer created the account |
 | `LoyaltyStatus` | String    | Customers’ loyalty level based on purchase history (Gold, Silver, Platinum, Bronze, etc.) |
 
 Orders.csv
 | Attributes    | Data Type  | Description |
 |----------------|-----------|-------------|
 | `OrderID`      | Integer   | Primary Key |
 | `CustomerID`   | Integer   | Foreign Key (References `Customer.CustomerID`) |
 | `ProductID`    | Integer   | Foreign Key (References `Product.ProductID`) |
 | `Quantity`     | Integer   | Number of units ordered |
 | `UnitPrice`    | Decimal   | Price per unit at the time of order |
 | `TotalPrice`   | Decimal   | Total cost of the order (Quantity * UnitPrice) |
 | `OrderDate`    | DateTime  | Date when the order was placed |
 | `Status`       | String    | Order status (Shipped, Delivered, Cancelled, Pending, etc.) |
 | `PaymentMethod` | String   | Payment method used (Credit Card, PayPal, Cash, etc.) |
 | `ShippingMethod` | String  | Shipping mode used (Standard, Express, Overnight, etc.) |
 | `DeliveryDate` | DateTime  | Order delivery date |
 
 Products.csv
 | Attributes      | Data Type  | Description |
 |-----------------|-----------|-------------|
 | `ProductID`     | Integer   | Primary Key |
 | `ProductName`   | String    | Product name |
 | `Category`      | String    | Category to which the product belongs (Blinds, Accessories, Components, etc.) |
 | `Supplier`      | String    | Supplier’s name from where the product arrives |
 | `Width`        | Decimal   | Width of the product in centimeters |
 | `Height`       | Decimal   | Height of the product in centimeters |
 | `Color`        | String    | Color of the product (White, Black, etc.) |
 | `Weight`       | Decimal   | Weight of the product in kilograms |
 | `ProductionCost` | Decimal  | The cost incurred in producing the product |
 
 Pricing.xml
 | Attributes      | Data Type  | Description |
 |-----------------|-----------|-------------|
 | `ProductID`     | Integer   | Foreign Key (References `Product.ProductID`) |
 | `BasePrice`     | Decimal   | Price before discounts |
 | `Discount`      | Decimal   | Discount amount |
 | `FinalPrice`    | Decimal   | Final price after applying discounts |
 | `EffectiveDate` | DateTime  | Date when the price becomes effective |
 | `Currency`      | String    | Currency code |
 
 Inventory.json
 | Attributes         | Data Type  | Description |
 |---------------------|-----------|-------------|
 | `ProductID`        | Integer   | Foreign Key (References `Product.ProductID`) |
 | `Warehouse`        | String    | Warehouse description storing the product |
 | `StockLevel`       | Integer   | The current stock level of the product |
 | `SafetyStockLevel` | Integer   | Minimum stock level to maintain in inventory |
 | `ReplenishmentDate` | DateTime  | Scheduled stock replenishment date |
 | `LastUpdate`       | DateTime  | Last inventory updated date |


 ## Part 2: Normalization


  The current data soruce files are not in the 3NF form. To convert the files into 3NF, we will separate some attributes into a separate table: 
  1. Customers.csv - Location, BusinessType and Loyalty has repetitive data (transitive dependency) so separate tables were created for each.
      - The normalized data files are: Customers.csv, BusinessType.csv, Locations.csv and Loyalty.csv.
        
  2. Orders.csv - Status, PaymentMethod, ShippingMethod has repetitive data (transitive dependency) so separate tables were created for each.
      - The normalized data files are: Orders.csv, OrderStatus.csv, PaymentMethod.csv, ShippingMethod.csv.
        
  3. Products.csv - Category and Supplier has repetitive data (transitive dependency) so separate tables were created for each.
      - The normalized data files are: Products.csv, Category.csv, Supplier.csv.
    
  4. Pricing.xml - Currency has repetitive data (transitive dependency) so separate table is created to store currency data.
      - The normalized data files are: Currency.xml and Pricing.xml
        
  5. Inventory.json - Warehouse has repetitive data (transitive dependency) so separate table is created to store warehouse information.
      - The normalized data files are: Inventory.json and Warehouse.json
    
  All the normalized files are stored in the Part2- Normalized Data Sources folder. 

  We will use Snowflake to create the database schema. 
  Created a new data warehouse, database and a schema. All the DDL logic to create database schemas for normalized tables are stored in "DDL Script to create database schema" file
  ![image](https://github.com/user-attachments/assets/de4fc6b7-2415-404f-9c32-26bd74452a30)

  Normalized database schema is created. 
  ![image](https://github.com/user-attachments/assets/6153f7e5-462d-4837-b335-15b07056a882)
  Snowflake Link to the database schema creation script: https://app.snowflake.com/eleevfr/dq33127/wRyqmIzoA0l/query
  
  To load the data into the tables, we will use the load data option in snowflake, then select the appropriate file from the local machine, then click on Next, Click on Load.

  
  ![image](https://github.com/user-attachments/assets/e8607b5a-0952-402e-8979-b474ed20275d)
  ![image](https://github.com/user-attachments/assets/b1c9f1d2-87d2-4402-b534-39a783570827)
  ![image](https://github.com/user-attachments/assets/3039a172-3cee-481e-8464-4af59e518602)
  ![image](https://github.com/user-attachments/assets/c97e56de-7708-48f8-a94b-0fef532c8c6a)
  ![image](https://github.com/user-attachments/assets/64ee37e0-60ce-4e4f-8833-bdb5f76382c0)

To see the results, we run the select command on the Business Types. 
![image](https://github.com/user-attachments/assets/8967c911-13d6-4599-8bc0-17a246ee309e)

We will follow this steps to load all the datasets. 

To load the xml file, I have written the insert queries as I was unable to load it directly using the load option in snowflake. In our dataset, we have two xml files: Currency and Pricing. I have inserted all the records for currency table and only entered 49 records for the pricing table. 

The DML script to insert the records is stored in the "DML to insert XML data into tables" file. 
Snowflake link to the data update script for Pricing and Currency: https://app.snowflake.com/eleevfr/dq33127/w1Zh8LcQLc2N#query

## Part 4: Dimensional Model 

DDL Scripts for Dimensional Model: https://app.snowflake.com/eleevfr/dq33127/w5TybQCVuCSv#query (Dimension Table) and https://app.snowflake.com/eleevfr/dq33127/wqUb3pUTnBe#query (Fact Table)

### Documentation/Explanation of Dimensions and Fact design
1. DimCustomer: 
 - Purpose: Tracks customers historical changes, including business types and loyalty tiers.
 - Primary Key: CustomerKey (Surrogate Key)
 - Foreign Key References: None
 - Slowly Changing Dimension:
 - EffectiveDate, EndDate, IsCurrent (Tracks changes in business type and loyalty tier over time)
 - Source Files: Customers.csv, BusinessType.csv, Loyalty.csv
 - Explanation: With tracking historical changes, we can perform customer segmentation analysis. 
   
2. DimProduct:
 - Purpose: Stores product details, including category, supplier, and pricing information.
 - Primary Key: ProductKey (Surrogate Key)
 - Foreign Key References: None
 - Additional Attributes: BasePrice, Discount, FinalPrice, EffectiveDate (Tracks product pricing changes over time)
 - Source Files: Products.csv, Category.csv, Supplier.csv, Pricing.xml
 - Explanation: This allows product analytics, enabling tracking of category performance, supplier effectiveness, and pricing changes over time.
   
3. DimDate: 
 - Purpose: Provides a date reference for analytics, including time granularity (Year, Quarter, Month, Day).
 - Primary Key: DateKey
 - Foreign Key References: Referenced in fact tables.
 - Source Files: Orders.csv
 - Explanation: This allows us to keep a track of monthly sales trends or seasonal inventory patterns. 
   
4. DimCurrency:
 - Purpose: Tracks currency fluctuations over time.
 - Primary Key: CurrencyKey (Surrogate Key)
 - Foreign Key References: Referenced in FactSales.
 - Slowly Changing Dimension: EffectiveDate, EndDate, IsCurrent (Captures historical rate changes)
 - Source Files: Currency.xml, Pricing.xml
 - Explanation: This ensures that we keep track of historical sales transactions. 
   
5. DimWarehouse:
 - Purpose: Stores warehouse locations and logistics details.
 - Primary Key: WarehouseKey (Surrogate Key)
 - Foreign Key References: Referenced in FactInventory.
 - Additional Attributes: WarehouseID, WarehouseName, Location (Location added for logistics tracking)
 - Source Files: Warehouse.json, Inventory.json, Locations.csv
 - Explanation: This allows efficient inventory management, supporting stock-level analysis, warehouse performance and optimization. 
   
6. DimShippingMethod: 
 - Purpose: Stores shipping method details, tracking different carriers and delivery speeds.
 - Primary Key: ShippingMethodKey (Surrogate Key)
 - Foreign Key References: Referenced in FactSales.
 - Additional Attributes: ShippingMethodName, Carrier, EstimatedDeliveryDays
 - Source Files: ShippingMethod.csv
 - Explanation: This enables shipping performance analysis, helping businesses evaluate carrier efficiency, cost optimization, and delivery times.
      
6. FactSales:
    - Purpose: This fact table captures all sales transactions and links them to customer, product, date, currency, and shipping dimensions for analytics.
    - Primary Key: SalesKey (Surrogate Key)
    - Foreign Key References: Customer Key comes from DimCustomer, ProductKey comes DimProduct, DateKey comes from DimDate, CurrencyKey comes from DimCurrency and ShippingMethodKey comes from DimShippingMethod.
    - Additonal Attributes: OrderStatus, PaymentMethod, Quantity, TotalPrice.
    - Source File: Orders.csv, OrderStatus.csv, PaymentMethod.csv, ShippingMethod.csv
      
7. FactInvetory:
     - Purpose: his fact table tracks inventory transactions over time, monitoring stock levels and warehouse performance.
     - Primary Key: InventoryKey (Surrogate Key) 
     - Foreign Key References: ProductKey comes from DimProduct, WarehouseKey comes from DimWarehouse and DateKey comes from DimDate.
     - Additional Attributes: StockLevel, SafetyStockLevel, LastUpdated.
     - Source File: Inventory.json, Warehouse.json








  
   

