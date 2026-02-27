-- Change to the Northwind database
USE Northwind;
GO

-- Procedure 1: No parameters
-- This procedure prints a message.

CREATE OR ALTER PROCEDURE WelcomeMessage
AS
BEGIN
    SET NOCOUNT ON;
    PRINT 'Welcome to the Northwind Database!';
END
GO

-- Test it
EXEC WelcomeMessage;
GO



-- Procedure 2: One input parameter
-- Looks up a customer's company name by CustomerID.

CREATE OR ALTER PROCEDURE GetCustomerName
    @CustomerID NCHAR(5)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CompanyName NVARCHAR(40);

    SELECT @CompanyName = CompanyName
    FROM Customers
    WHERE CustomerID = @CustomerID;

    IF @CompanyName IS NULL
        PRINT 'Customer not found.';
    ELSE
        PRINT 'Company Name: ' + @CompanyName;
END
GO

-- Test with a valid customer
EXEC GetCustomerName @CustomerID = 'ALFKI';
GO

-- Test with an invalid customer
EXEC GetCustomerName @CustomerID = 'ZZZZZ';
GO



-- Procedure 3: One input parameter, one output parameter
-- Returns the total number of orders for a customer.

CREATE OR ALTER PROCEDURE GetCustomerOrderCount
    @CustomerID NCHAR(5),
    @OrderCount INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT @OrderCount = COUNT(*)
    FROM Orders
    WHERE CustomerID = @CustomerID;
END
GO

-- Test it
DECLARE @OrderCount INT;

EXEC GetCustomerOrderCount
    @CustomerID = 'ALFKI',
    @OrderCount = @OrderCount OUTPUT;

PRINT 'Order count for ALFKI: ' + CAST(@OrderCount AS NVARCHAR(10));


-- Procedure 4: Input and output parameters with error handling
-- Calculates the total dollar amount for a given order.

CREATE OR ALTER PROCEDURE CalculateOrderTotal
    @OrderID INT,
    @TotalAmount MONEY OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT @TotalAmount = SUM(UnitPrice * Quantity * (1 - Discount))
    FROM [Order Details]
    WHERE OrderID = @OrderID;

    IF @TotalAmount IS NULL
    BEGIN
        SET @TotalAmount = 0;
        PRINT 'Order ' + CAST(@OrderID AS NVARCHAR(10)) + ' not found.';
        RETURN;
    END

    PRINT 'Total for Order ' + CAST(@OrderID AS NVARCHAR(10)) + ': $' + CAST(@TotalAmount AS NVARCHAR(20));
END
GO

-- Test with a valid order
DECLARE @TotalAmount MONEY;

EXEC CalculateOrderTotal
    @OrderID = 10248,
    @TotalAmount = @TotalAmount OUTPUT;

PRINT 'Returned total: $' + CAST(@TotalAmount AS NVARCHAR(20));
GO

-- Test with an invalid order
DECLARE @TotalAmount MONEY;

EXEC CalculateOrderTotal
    @OrderID = 99999,
    @TotalAmount = @TotalAmount OUTPUT;

PRINT 'Returned total: $' + CAST(ISNULL(@TotalAmount, 0) AS NVARCHAR(20));



USE Northwind;
GO

-- =============================================
-- Part 2, Procedure 1: GetProductName
-- =============================================

CREATE OR ALTER PROCEDURE GetProductName
    @ProductID INT,
    @ProductName NVARCHAR(40) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- YOUR CODE HERE: Write a SELECT statement that sets
    -- @ProductName equal to the ProductName column
    -- from the Products table where ProductID matches @ProductID.
    SELECT @ProductName = ProductName
    FROM Products
    WHERE ProductID = @ProductID;

    IF @ProductName IS NULL
        PRINT 'Product not found.';
    ELSE
        PRINT 'Product Name: ' + @ProductName;
END
GO

-- Test it
DECLARE @ProductName NVARCHAR(40);

EXEC GetProductName
    @ProductID = 1,
    @ProductName = @ProductName OUTPUT;
GO


-- =============================================
-- Part 2, Procedure 2: GetEmployeeOrderCount
-- =============================================

CREATE OR ALTER PROCEDURE GetEmployeeOrderCount
    @EmployeeID INT,
    @OrderCount INT OUTPUT
AS
BEGIN

     SET NOCOUNT ON;
    
    SELECT @OrderCount = COUNT(*)
    FROM Orders
    WHERE EmployeeID = @EmployeeID;
    
    PRINT 'Employee ' + CAST(@EmployeeID AS NVARCHAR(10)) + 
          ' has processed ' + CAST(@OrderCount AS NVARCHAR(10)) + ' orders.';
END
GO


-- Test it
DECLARE @OrderCount INT;

EXEC GetEmployeeOrderCount
    @EmployeeID = 5,
    @OrderCount = @OrderCount OUTPUT;
GO


-- =============================================
-- Part 2, Procedure 3: CheckProductStock
-- =============================================

CREATE OR ALTER PROCEDURE CheckProductStock
    @ProductID INT,
    @NeedsReorder BIT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Check if UnitsInStock is less than or equal to ReorderLevel
    SELECT @NeedsReorder = CASE 
        WHEN UnitsInStock <= ReorderLevel THEN 1 
        ELSE 0 
    END
    FROM Products
    WHERE ProductID = @ProductID;
    
    -- Print appropriate message based on the result
    IF @NeedsReorder = 1
        PRINT 'Product ' + CAST(@ProductID AS NVARCHAR(10)) + ' needs reordering.';
    ELSE
        PRINT 'Product ' + CAST(@ProductID AS NVARCHAR(10)) + ' stock is OK.';
END
GO

-- Test CheckProductStock if a product NEEDS REORDER
DECLARE @NeedsReorder BIT;

EXEC CheckProductStock
    @ProductID = 2,
    @NeedsReorder = @NeedsReorder OUTPUT;

GO

-- Test CheckProductStock if a product DOES NOT NEED REORDER
DECLARE @NeedsReorder BIT;

EXEC CheckProductStock
    @ProductID = 7,
    @NeedsReorder = @NeedsReorder OUTPUT;

GO
