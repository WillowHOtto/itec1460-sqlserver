-- Add new customer into database
INSERT INTO Customers (CustomerID, CompanyName, ContactName, Country)
VALUES ('STUDE', 'Student Company', 'Willow', 'America');

-- Check to make sure changes are made
SELECT CustomerID, CompanyName FROM Customers WHERE CustomerID = 'STUDE';

-- Add an order for the customer added 
INSERT INTO Orders (CustomerID, EmployeeID, OrderDate, ShipCountry)
VALUES ('STUDE', 1, GETDATE(), 'America');

-- Check to make sure changes are made
SELECT TOP 1 OrderID FROM Orders WHERE CustomerID = 'STUDE' ORDER BY OrderID DESC;

-- Change the contact name for new customer
UPDATE Customers
SET ContactName = 'Lillow'
WHERE CustomerID = 'STUDE';

-- Check to make sure changes are made
SELECT ContactName FROM Customers WHERE CustomerID = 'STUDE';

-- Change the shipping country for new customers order
UPDATE Orders
SET ShipCountry = 'Germany'
WHERE CustomerID = 'STUDE';

-- Check to make sure changes are made
SELECT ShipCountry FROM Orders WHERE CustomerID = 'STUDE';

-- Remove the order that was created
DELETE FROM Orders WHERE CustomerID = 'STUDE';

-- Check to make sure chnages are made
SELECT OrderID, CustomerID FROM Orders WHERE CustomerID = 'STUDE';

-- Remove the new customer created
DELETE FROM Customers WHERE CustomerID = 'STUDE';

-- Check to make sure changes are made
SELECT CustomerID, CompanyName FROM Customers WHERE CustomerID = 'STUDE';

-- PART 2

-- fill in the blanks to add a new supplier
INSERT INTO Suppliers (CompanyName, ContactName, ContactTitle, Country)
VALUES ('Pop-Up Foods', 'Willow', 'Owner', 'America');

-- Check your work:
SELECT * FROM Suppliers WHERE CompanyName = 'Pop-up Foods';

-- Write your first COMPLETE insert statement
INSERT INTO Products (ProductName, SupplierID, CategoryID, UnitPrice, UnitsInStock)
VALUES ('House Special Pizza', 30, 2, '$15.99', 50);

-- Check your work:
SELECT * FROM Products WHERE ProductName = 'House Special Pizza';

-- Fill in the blanks to update your products price
UPDATE Products
SET UnitPrice = '$12.99'
WHERE ProductName = 'House Special Pizza';
-- Use SELECT statement above to view changes

-- Write a complete UPDATE command to change details for your pizza:
UPDATE Products
SET UnitsInStock = 25,
    UnitPrice = '17.99'
WHERE ProductName = 'House Special Pizza';

-- Check your work
SELECT * FROM Products WHERE ProductName = 'House Special Pizza';

-- Delete the product
DELETE FROM Products 
WHERE ProductName = 'House Special Pizza';

--Part 2 Challenge: Create Your Own Menu Item

-- Create a new product of your choice.
INSERT INTO Products (ProductName, SupplierID, UnitPrice, UnitsInStock)
VALUES ('Shrimp Alfredo', 30, '$21.99', 30);

--Check that new product has been added
SELECT * FROM Products
WHERE ProductName = 'Shrimp Alfredo';

-- Update its price and inventory
UPDATE Products
SET UnitPrice = '$18.99',
    UnitsInStock = 50
WHERE ProductName = 'Shrimp Alfredo';

-- Check that changes were made
SELECT * FROM Products WHERE ProductName = 'Shrimp Alfredo';

--Remove it from the menu
DELETE FROM Products
WHERE ProductName = 'Shrimp Alfredo'
-- Check that the item was removed by running the query on line 95
