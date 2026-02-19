-- Create the authors table for Northwinds new product line of books
CREATE TABLE Authors(
    AuthorID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    BirthDate DATE
);

DROP TABLE Authors;

--Check that table was made (It will be empty)
SELECT * FROM Authors;

--Create the books table
CREATE TABLE Books(
    BookID INT PRIMARY KEY,
    Title VARCHAR(100),
    AuthorID INT, -- Foreign ke that connects books to authors tables
    PublicationYear INT,
    Price DECIMAL(10,2),
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID),
);

DROP TABLE Books;

SELECT * FROM Books;

-- Insert data into Authors table
INSERT INTO Authors (AuthorID, FirstName, LastName, BirthDate)
    VALUES 
    (1, 'Jane', 'Austen', '1775-12-16'),
    (2, 'George', 'Orwell', '1903-06-25'),
    (3, 'J.K.', 'Rowling', '1965-07-31'),
    (4, 'Ernest', 'Hemingway', '1899-07-21'),
    (5, 'Virginia', 'Woolf', '1882-01-25');

-- View the Authors table
SELECT * FROM Authors;

-- Insert data into Books table
INSERT INTO Books (BookID, Title, AuthorID, PublicationYear, Price)
    VALUES 
    (1, 'Pride and Prejudice', 1, 1813, 12.99),
    (2, '1984', 2, 1949, 10.99),
    (3, 'Harry Potter and the Philosopher''s Stone', 3, 1997, 15.99),
    (4, 'The Old Man and the Sea', 4, 1952, 11.99),
    (5, 'To the Lighthouse', 5, 1927, 13.99);

--View the Books table
SELECT * FROM Books;

--Create a view that combines info from books and authors tables
CREATE VIEW BookDetails AS
SELECT 
    b.BookID,
    b.Title,
    a.FirstName + ' ' + a.LastName AS AuthorName,
    b.PublicationYear,
    b.Price
FROM 
    Books b
JOIN 
    Authors a ON b.AuthorID = a.AuthorID;

-- Create view that filters by publication year
CREATE VIEW RecentBooks AS
SELECT 
    BookID,
    Title,
    PublicationYear,
    Price
FROM 
    Books
WHERE 
    PublicationYear > 1990;

--Retrieve all records from the BookDetails view
SELECT * FROM BookDetails;

--List all books from the RecentBooks view
SELECT * FROM RecentBooks;

-- Create view for author stats that shows average price of books for each author, and number of books published. 
CREATE VIEW AuthorStats AS
SELECT 
    a.AuthorID,
    a.FirstName + ' ' + a.LastName AS AuthorName,
    COUNT(b.BookID) AS BookCount,
    AVG(b.Price) AS AverageBookPrice
FROM 
    Authors a
LEFT JOIN 
    Books b ON a.AuthorID = b.AuthorID
GROUP BY 
    a.AuthorID, a.FirstName, a.LastName;

--View the view :)
SELECT * FROM AuthorStats;

--Insert a second book for George Orwell 
INSERT INTO Books (BookID, Title, AuthorID, PublicationYear, Price)
VALUES (6, 'Animal Farm', 2, 1960, '55.00');

-- Create an updateable view
CREATE VIEW AuthorContactInfo AS
SELECT 
    AuthorID,
    FirstName,
    LastName
FROM 
    Authors;

--Update the view
UPDATE AuthorContactInfo
SET FirstName = 'Joanne'
WHERE AuthorID = 3;

SELECT * FROM AuthorContactInfo
SELECT * FROM Authors
-- It also updated in the normal authors table, not only the view!

-- Create a price audit table
CREATE TABLE BookPriceAudit (
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    BookID INT,
    OldPrice DECIMAL(10,2),
    NewPrice DECIMAL(10,2),
    ChangeDate DATETIME DEFAULT GETDATE()
);

--Create the trigger 
CREATE TRIGGER trg_BookPriceChange
ON Books
AFTER UPDATE
AS
BEGIN
    IF UPDATE(Price)
    BEGIN
        INSERT INTO BookPriceAudit (BookID, OldPrice, NewPrice)
        SELECT 
            i.BookID,
            d.Price,
            i.Price
        FROM inserted i
        JOIN deleted d ON i.BookID = d.BookID
    END
END;

-- Update a book's price (Test the trigger!)
UPDATE Books
SET Price = 14.99
WHERE BookID = 1;

--view the audit (Should have old price and new price)
SELECT * FROM BookPriceAudit;