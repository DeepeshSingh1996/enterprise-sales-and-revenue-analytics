USE master;
GO

-- Drop and recreate the 'Data Warehouse' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name  = 'SalesAnalytics')
BEGIN
    ALTER DATABASE SalesAnalytics SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE SalesAnalytics;
END;
GO

-- Create the 'DataWarehouse' database
CREATE DATABASE SalesAnalytics;
GO

USE SalesAnalytics;
GO
  
-- Create Schemas
CREATE SCHEMA stg; -- raw staging area
GO
  
CREATE SCHEMA clean; -- cleaned, production‑ready tables
GO
