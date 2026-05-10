-- Switch to the antique store database
USE AntiqueStore;
GO

-- Check to make sure the database is open
SELECT DB_NAME() AS CurrentDatabase;
GO

-- Create procedure to add a new customer into database (Procedure 1)
CREATE OR ALTER PROCEDURE sp_AddNewCustomer
    @customer_ID INT,
    @first_name VARCHAR(50),
    @last_name VARCHAR(50),
    @email VARCHAR(100),
    @phone VARCHAR(20),
    @join_date DATE = NULL
AS
BEGIN
    -- Use today's date if join_date not provided
    IF @join_date IS NULL
        SET @join_date = GETDATE();
    
    -- Check if customer already exists
    IF EXISTS (SELECT 1 FROM Customers WHERE customer_ID = @customer_ID)
    BEGIN
        PRINT 'Error: Customer ID ' + CAST(@customer_ID AS VARCHAR) + ' already exists.';
        RETURN;
    END;
    
    -- Insert new customer
    INSERT INTO Customers (customer_ID, first_name, last_name, email, customer_phone, join_date, reward_points)
    VALUES (@customer_ID, @first_name, @last_name, @email, @phone, @join_date, 0);
    
    PRINT 'Customer ' + @first_name + ' ' + @last_name + ' has been ADDED successfully.';
END;
GO

--Test new procedure
EXEC sp_AddNewCustomer 104, 'Thomas', 'Edison', 'thomas@email.com', '555-0120', '2026-05-10';

-- Look at the customers table to see changes
SELECT * FROM Customers;


-- Create procedure to retrieve all data for a specific customer (Procedure 2)
CREATE OR ALTER PROCEDURE sp_GetCustomerPurchaseHistory
    @customer_ID INT
AS
BEGIN
    SELECT 
        c.customer_ID,
        c.first_name,
        c.last_name,
        s.sale_ID,
        s.sale_date,
        s.total_amount,
        s.discount_applied,
        i.item_name,
        sd.item_amount,
        sd.final_total AS item_final_price
    FROM Customers c
    JOIN Sales s ON c.customer_ID = s.customer_ID
    JOIN Sale_Details sd ON s.sale_ID = sd.sale_ID
    JOIN Inventory i ON sd.item_ID = i.item_ID
    WHERE c.customer_ID = @customer_ID
    ORDER BY s.sale_date DESC;
END;
GO

-- Use procedure to view willows transactions
EXEC sp_GetCustomerPurchaseHistory 101;

-- Use procedure to view new another customers transactions 
EXEC sp_GetCustomerPurchaseHistory 103;

-- Create procedure to update an items price (Procedure 3)
CREATE OR ALTER PROCEDURE sp_UpdateItemPrice
    @item_ID INT,
    @new_price DECIMAL(8,2)
AS
BEGIN
    -- Check if item exists
    IF NOT EXISTS (SELECT 1 FROM Inventory WHERE item_ID = @item_ID)
    BEGIN
        PRINT 'Error: Item ID ' + CAST(@item_ID AS VARCHAR) + ' does not exist.';
        RETURN;
    END;
    
    -- Get old price for confirmation
    DECLARE @old_price DECIMAL(8,2);
    SELECT @old_price = price FROM Inventory WHERE item_ID = @item_ID;
    
    -- Update the price
    UPDATE Inventory
    SET price = @new_price
    WHERE item_ID = @item_ID;
    
    -- Show the change
    PRINT 'Item ' + CAST(@item_ID AS VARCHAR) + ' price changed from $' + CAST(@old_price AS VARCHAR) + ' to $' + CAST(@new_price AS VARCHAR) + '.';
END;
GO

--Test the procedure
-- Put Haunted Doll on sale from $250 to $200
EXEC sp_UpdateItemPrice 3004, 200.00;

-- Check price change
SELECT * FROM Inventory WHERE item_ID = 3004;
