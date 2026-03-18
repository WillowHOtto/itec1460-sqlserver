-- STEP 1 & 2: Create database 

CREATE DATABASE PixelPizzaPalace;
GO

--Make sure the database created is in use
USE PixelPizzaPalace;
GO

--Begin making tables and filling them with data
CREATE TABLE Products (
    ProductID   INT PRIMARY KEY IDENTITY(1,1),
    ProductName VARCHAR(50),
    Price       DECIMAL(5,2),
    Stock       INT
);

CREATE TABLE Sales (
    SaleID    INT PRIMARY KEY IDENTITY(1,1),
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    Quantity  INT,
    SaleDate  DATETIME DEFAULT GETDATE()
);

INSERT INTO Products (ProductName, Price, Stock)
VALUES 
    ('Pepperoni Pizza', 12.99, 50),
    ('Cheese Pizza',    10.99, 50),
    ('Garlic Bread',     4.99, 75),
    ('Soda',             2.50, 200);

INSERT INTO Sales (ProductID, Quantity)
VALUES (1, 3), (2, 2), (3, 5);
GO

-- Step 3: Create users and grant permissions

-- Create logins at the server level
CREATE LOGIN Cashier WITH PASSWORD = 'Cash123!';
CREATE LOGIN Manager WITH PASSWORD = 'Mangr123!';
GO

USE PixelPizzaPalace;
GO

-- Create users inside the PixelPizzaPalace database
CREATE USER Cashier FOR LOGIN Cashier;
CREATE USER Manager FOR LOGIN Manager;
GO

-- Cashier can only read the menu and add new sales
GRANT SELECT ON Products TO Cashier;
GRANT SELECT, INSERT ON Sales TO Cashier;
GO

-- Manager can do everything on both tables
GRANT SELECT, INSERT, UPDATE, DELETE ON Products TO Manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON Sales TO Manager;
GO

-- Step 4: check user permissions
SELECT 
    dp.name            AS UserName,
    o.name             AS TableName,
    p.permission_name  AS Permission
FROM sys.database_permissions p
JOIN sys.database_principals dp 
    ON p.grantee_principal_id = dp.principal_id
JOIN sys.objects o 
    ON p.major_id = o.object_id
WHERE dp.name IN ('Cashier', 'Manager')
ORDER BY UserName, TableName;
GO

--Step 5: monitor database size
SELECT 
    name        AS FileName,
    size / 128.0 AS SizeMB
FROM sys.database_files;
GO

--Step 6: Create a backup of the database
BACKUP DATABASE PixelPizzaPalace
TO DISK = '/var/opt/mssql/data/PixelPizzaPalace.bak'
WITH FORMAT;
GO

--Step 7: Create an index
-- Create an index so searches by ProductName are faster
CREATE NONCLUSTERED INDEX IX_Products_Name 
ON Products(ProductName);
GO

-- Verify the index was created by listing all indexes on Products
SELECT 
    i.name      AS IndexName,
    i.type_desc AS IndexType,
    COL_NAME(ic.object_id, ic.column_id) AS ColumnName
FROM sys.indexes i
JOIN sys.index_columns ic 
    ON i.object_id = ic.object_id 
    AND i.index_id = ic.index_id
WHERE i.object_id = OBJECT_ID('Products')
ORDER BY i.name;
GO

-- ===== PART 2 STEP 2: ADD INVENTORY USER =====

--Create login for inventory manager
CREATE LOGIN InventoryMgr  WITH PASSWORD = 'Inv_123!';
GO
-- Received an error for password being too short, make it longer. Original password is INV123!

-- Create user inventory manager inside the PixelPizzaPalace database
CREATE USER InventoryMgr FOR LOGIN InventoryMgr;
GO

-- Inventory manager can only select and update items in products table
GRANT SELECT, UPDATE ON Products TO InventoryMgr;
GO

-- Check that permissions are correct
SELECT 
    dp.name            AS UserName,
    o.name             AS TableName,
    p.permission_name  AS Permission
FROM sys.database_permissions p
JOIN sys.database_principals dp 
    ON p.grantee_principal_id = dp.principal_id
JOIN sys.objects o 
    ON p.major_id = o.object_id
WHERE dp.name IN ('Cashier', 'Manager', 'InventoryMgr')
ORDER BY UserName, TableName;
GO

-- ===== PART 2 STEP 3: TABLE SIZES =====
USE PixelPizzaPalace;
GO

SELECT 
    t.name              AS TableName,
    p.rows              AS NumberOfRows,
    SUM(a.total_pages) * 8 AS TotalSpaceKB
FROM sys.tables t
JOIN sys.indexes i 
    ON t.object_id = i.object_id
JOIN sys.partitions p 
    ON i.object_id = p.object_id 
    AND i.index_id = p.index_id
JOIN sys.allocation_units a 
    ON p.partition_id = a.container_id
GROUP BY t.name, p.rows
ORDER BY TotalSpaceKB DESC;
GO

-- ===== PART 2 STEP 4: BACKUP AND RESTORE =====

-- Step 4a
INSERT INTO Products (ProductName, Price, Stock)
VALUES ('Ice Cream Sundae', 5.99, 60);
GO

-- Step 4b
BACKUP DATABASE PixelPizzaPalace
TO DISK = '/var/opt/mssql/data/PixelPizzaPalace_New.bak'
WITH FORMAT;
GO

-- Step 4c
DELETE FROM Products WHERE ProductName = 'Ice Cream Sundae';
GO

SELECT * FROM Products;
GO

--Step 4d
USE master;
GO

-- Take the database offline so we can restore it
ALTER DATABASE PixelPizzaPalace SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

RESTORE DATABASE PixelPizzaPalace
FROM DISK = '/var/opt/mssql/data/PixelPizzaPalace_New.bak'
WITH REPLACE;
GO

-- Bring the database back online for all users
ALTER DATABASE PixelPizzaPalace SET MULTI_USER;
GO

USE PixelPizzaPalace;
GO

SELECT * FROM Products;
GO

-- ===== PART 2 STEP 5: REFLECTION =====

-- Reflection
-- Question 1: The three most important tasks were...
    -- 1: Creating a backup of the database
    --2: Giving correct permissions to users 
    --3: Protecting user accounts with strong passwords (Not really shown in the lab but we talked about it)

-- Question 2: Pixel Pizza Palace needs permission control because...
    -- Without permission control users have the power to alter and delete anything in the database, which can lead to unwanted changes and issues.
    -- With permissions controls we can make sure that only authorized users can do their specific tasks. 

-- Question 3: Without regular backups...
    -- there is no way to ensure data security and recovery. In cases of data loss, without a backup the data cannot be retrieved and it is lost for good. 