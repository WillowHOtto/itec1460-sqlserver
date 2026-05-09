--- This file is for Willow Otto's ITEC 1460 database project ---

-- Creating antique store database (followed code on 01-CreateDatabase.sql) --
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'AntiqueStore')
BEGIN
    CREATE DATABASE AntiqueStore;
END;
GO

-- Switch to the new antique store database
USE AntiqueStore;
GO

-- Check to make sure the database is open
SELECT DB_NAME() AS CurrentDatabase;
GO

-- Initialize tables in order from parent to child tables

-- Parent tables vendors, customers, and employees
CREATE TABLE Vendors (
    vendor_ID INT PRIMARY KEY,
    vendor_name VARCHAR(100) NOT NULL,
    vendor_email VARCHAR(100) UNIQUE,
    vendor_phone VARCHAR(20),
    rental_rate DECIMAL(10,2), 
    lease_term_months INT
);

CREATE TABLE Customers (
    customer_ID INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    customer_phone VARCHAR(20),
    join_date DATE NULL,
    reward_points INT DEFAULT 0
);


CREATE TABLE Employees (
    employee_ID INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    role VARCHAR(50),
    hire_date DATE NOT NULL,
    hourly_rate DECIMAL(8,2)
);

-- Begin initializing child tables that depend on parent tables

CREATE TABLE Booths (
    booth_ID INT PRIMARY KEY,
    booth_name VARCHAR(50) NOT NULL,
    vendor_ID INT, --Foreign key
    location_description VARCHAR(200),
    FOREIGN KEY (vendor_ID) REFERENCES Vendors(vendor_ID)
);

CREATE TABLE Inventory (
    item_ID INT PRIMARY KEY,
    vendor_ID INT, --Foreign key
    booth_ID INT, --Foreign key
    item_name VARCHAR(100),
    price DECIMAL(8,2),
    quantity INT,
    condition VARCHAR(20),
    date_added DATE
    FOREIGN KEY (vendor_ID) REFERENCES Vendors(vendor_ID),
    FOREIGN KEY (booth_ID) REFERENCES Booths(booth_ID)
);


CREATE TABLE Sales (
    sale_ID INT PRIMARY KEY,
    customer_ID INT, --Foreign key
    employee_ID INT, --Foreign key
    sale_date DATE,
    total_amount DECIMAL(8,2),
    discount_applied VARCHAR(10),
    FOREIGN KEY (customer_ID) REFERENCES Customers(customer_ID),
    FOREIGN KEY (employee_ID) REFERENCES Employees(employee_ID)
);



CREATE TABLE Sale_Details (
    sale_details_ID INT PRIMARY KEY,
    sale_ID INT, --Foreign key
    item_ID INT, --Foreign key
    item_amount INT,
    final_total DECIMAL(10,2),
    FOREIGN KEY (sale_ID) REFERENCES Sales(sale_ID),
    FOREIGN KEY (item_ID) REFERENCES Inventory(item_ID)
);


CREATE TABLE Customer_Rewards (
    reward_ID INT PRIMARY KEY,
    customer_ID INT, --Foreign key
    points_earned INT,
    points_redeemed INT,
    transaction_date DATE,
    description VARCHAR(500),
    FOREIGN KEY (customer_ID) REFERENCES Customers(customer_ID)
);

CREATE TABLE Customer_Holds (
    hold_ID INT PRIMARY KEY,
    customer_ID INT,
    item_ID INT,  -- ← Add this column
    hold_date DATE,
    release_date DATE NULL,
    status VARCHAR(100),
    FOREIGN KEY (customer_ID) REFERENCES Customers(customer_ID),
    FOREIGN KEY (item_ID) REFERENCES Inventory(item_ID)
);




-- Fill tables in with sample data

-- Fill in vendors table
INSERT INTO Vendors (vendor_ID, vendor_name, vendor_email, vendor_phone, rental_rate, lease_term_months)
    VALUES 
    (1001, 'Amy Watering', 'Valley.Flower.Antiques@gmail.com', '555-0101', 300.00, 6),
    (1002, 'Gertrude Lynn', 'Dollies.Haunted@gmail.com', '555-0102', 350.00, 8),
    (1003, 'Nick Soda', 'SecretSoda.Society@yahoo.com', '555-0103', 500.00, 12);

-- Check the vendors table for data
SELECT * FROM Vendors;

-- Fill in customers table
INSERT INTO Customers (customer_ID, first_name, last_name, email, customer_phone, join_date, reward_points)
    VALUES 
    (101, 'Willow', 'Otto', 'My.Email@gmail.com', '555-0104', '2026-03-23', 130),
    (102, 'Barbara', 'Lee', 'BarbLarb@yahoo.com', '555-0105', NULL, 0),
    (103, 'Pyppa', 'Shirly', 'Pypster@gmail.com', '555-0106', NULL, 0);

-- Check the cutsomers table for data
SELECT * FROM Customers;

--Fill in employees table
INSERT INTO Employees (employee_ID, first_name, last_name, role, hire_date, hourly_rate)
    VALUES 
    (501, 'Mark', 'Duffle', 'Manager', '2017-02-01', 23.00),
    (502, 'Diana', 'Marge', 'Cashier', '2023-01-15', 17.00),
    (503, 'Sage', 'Sandsmark', 'Stocker', '2026-02-01', 15.00);

-- Check the employees table for data
SELECT * FROM employees;

--Fill in booths table
INSERT INTO Booths (booth_ID, booth_name, vendor_ID, location_description)
    VALUES 
    (2001, 'Valley Flower', 1001, 'West 205'),
    (2002, 'Dollies Haunted Inc.', 1002, 'West 305'),
    (2003, 'Secret Soda Society', 1003, 'North 290');

-- Check booths table for data
SELECT * FROM Booths

--Fill in inventory table
INSERT INTO Inventory (item_ID, vendor_ID, booth_ID, item_name, price, quantity, condition, date_added)
    VALUES 
    --Valley flower booth:
    (3001, 1001, 2001, 'Victorian Flower Vase', 125.00, 1, 'Excellent', '2026-01-15'),
    (3002, 1001, 2001, 'Antique Watering Can', 45.00, 1, 'Good - minor rust', '2026-02-01'),
    (3003, 1001, 2001, 'Pressed Flower Art', 75.00, 1, 'Fair - fading', '2026-02-20'),
    -- Dollies haunted booth:
    (3004, 1002, 2002, 'Haunted Victorian Doll', 250.00, 1, 'Good', '2026-01-10'),
    (3005, 1002, 2002, 'Antique Ouija Board', 180.00, 1, 'Fair', '2026-01-25'),
    (3006, 1002, 2002, 'Gothic Mirror', 95.00, 1, 'Excellent', '2026-03-01'),
    --Secret soda society booth:
    (3007, 1003, 2003, 'Vintage Soda Machine', 450.00, 1, 'Restored - works', '2026-01-05'),
    (3008, 1003, 2003, '1950s Soda Glasses Set', 65.00, 4, 'Excellent', '2026-01-18'),
    (3009, 1003, 2003, 'Pepsi Collector Sign', 120.00, 1, 'Good', '2026-02-10');

-- Check inventory table
SELECT * FROM Inventory;

--Fill Sales table
INSERT INTO Sales (sale_ID, customer_ID, employee_ID, sale_date, total_amount, discount_applied)
    VALUES 
    (301, 101, 502, '2026-04-10', 25.00, '10%'),
    (302, 102, 502, '2026-04-28', 10.00, NULL),
    (303, 103, 502, '2026-03-03', 150.00, NULL);

--Check Sales table
SELECT * FROM Sales;

-- Fill Sales Details table table
INSERT INTO Sale_Details (sale_details_ID, sale_ID, item_ID, item_amount, final_total)
    VALUES 
    (4001, 301, 3002, 1, 22.50),  -- Antique Watering Can with 10% discount
    (4002, 302, 3009, 1, 10.00),  -- Pepsi Collector Sign (no discount)
    (4003, 303, 3004, 1, 150.00);  -- Haunted Victorian Doll (no discount)

--Check sales details table
SELECT * FROM Sale_Details;

-- Fill Customer rewards table
INSERT INTO Customer_Rewards (reward_ID, customer_ID, points_earned, points_redeemed, transaction_date, description)
VALUES 
    (5001, 101, 130, 0, '2026-03-23', 'Initial points from customer join'),
    (5002, 101, 25, 0, '2026-04-10', 'Earned from sale #301'),
    (5003, 101, 0, 10, '2026-04-15', 'Redeemed $5 off purchase');

--Check customer rewards table
SELECT * FROM Customer_Rewards;

--Fill in customer holds table
INSERT INTO Customer_Holds (hold_ID, customer_ID, item_ID, hold_date, release_date, status)
    VALUES 
    (1, 101, 3005, '2026-04-28', '2026-05-05', 'In progress'),
    (2, 102, 3008, '2026-03-04', '2026-03-13', 'Complete'),
    (3, 103, 3001, '2026-04-02', '2026-04-15', 'Complete');

--Check customer holds table
SELECT * FROM Customer_Holds;