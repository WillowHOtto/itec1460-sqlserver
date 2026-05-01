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