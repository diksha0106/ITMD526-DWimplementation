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
      - The normalized data files are: Customers.csv, BusinessType.csv, Location.csv and Loyalty.csv.
        
  2. Orders.csv - Status, PaymentMethod, ShippingMethod has repetitive data (transitive dependency) so separate tables were created for each.
      - The normalized data files are: Orders.csv, OrderStatus.csv, PaymentMethod.csv, ShippingMethod.csv.
        
  3. Products.csv - Category and Supplier has repetitive data (transitive dependency) so separate tables were created for each.
      - The normalized data files are: Products.csv, Category.csv, Supplier.csv.
    
  4. Pricing.xml - Currency has repetitive data (transitive dependency) so separate table is created to store currency data.
      - The normalized data files are: Currency.xml and Pricing.xml
        
  5. Inventory.json - Warehouse has repetitive data (transitive dependency) so separate table is created to store warehouse information.
      - The normalized data files are: Inventory.json and Warehouse.json
    
   All the normalized files are stored in the Part2- Normalized Data Sources folder. 

   
