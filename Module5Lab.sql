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