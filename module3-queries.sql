-- Part 2 of Module 3 lab after class

-- Write a query that shows the CompanyName and City of all suppliers from Germany.
SELECT CompanyName, City FROM suppliers
WHERE Country = 'Germany';

-- Write a query that shows the ProductName and UnitPrice for all products that cost less than $20.
SELECT ProductName, UnitPrice FROM Products
WHERE UnitPrice < 20;


-- Write a query that shows the CompanyName, ContactName, and Phone for all customers located in London.
SELECT CompanyName, ContactName, Phone FROM Customers
WHERE city = 'London';