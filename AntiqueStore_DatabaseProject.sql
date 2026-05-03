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
    final_total DECIMAL(10,2)
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
    customer_ID INT, --Foreign key
    hold_date DATE,
    release_date DATE NULL,
    status VARCHAR(100)
);