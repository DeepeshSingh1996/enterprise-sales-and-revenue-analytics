USE SalesAnalytics;
GO

IF OBJECT_ID ('stg.DimDate', 'U') IS NOT NULL
	DROP TABLE stg.DimDate;

-- Date dimension (staging)
CREATE TABLE stg.DimDate (
  DateKey    INT       NOT NULL,
  Date       DATE      NOT NULL,
  [Year]     INT       NOT NULL,
  [Month]    INT       NOT NULL,
  [Day]      INT       NOT NULL,
  MonthName  VARCHAR(20),
  Quarter    INT,
  CONSTRAINT PK_Stg_DimDate PRIMARY KEY(DateKey)
);

-- Product

IF OBJECT_ID ('stg.DimProduct', 'U') IS NOT NULL
	DROP TABLE stg.DimProduct;

CREATE TABLE stg.DimProduct (
  ProductID   INT       NOT NULL,
  ProductName VARCHAR(100),
  Category    VARCHAR(50),
  CONSTRAINT PK_Stg_DimProduct PRIMARY KEY(ProductID)
);

-- Customer

IF OBJECT_ID ('stg.DimCustomer', 'U') IS NOT NULL
	DROP TABLE stg.DimCustomer;

CREATE TABLE stg.DimCustomer (
  CustomerID   INT       NOT NULL,
  CustomerName VARCHAR(100),
  Country      VARCHAR(50),
  CONSTRAINT PK_Stg_DimCustomer PRIMARY KEY(CustomerID)
);

-- Region

IF OBJECT_ID ('stg.DimRegion', 'U') IS NOT NULL
	DROP TABLE stg.DimRegion;

CREATE TABLE stg.DimRegion (
  RegionID   INT       NOT NULL,
  RegionName VARCHAR(50),
  CONSTRAINT PK_Stg_DimRegion PRIMARY KEY(RegionID)
);

-- Currency Rates

IF OBJECT_ID ('stg.CurrencyRates', 'U') IS NOT NULL
	DROP TABLE stg.CurrencyRates;

CREATE TABLE stg.CurrencyRates (
  [Date]      DATE      NOT NULL,
  Currency    VARCHAR(3) NOT NULL,
  RateToUSD   DECIMAL(10,4),
  CONSTRAINT PK_Stg_CurrencyRates PRIMARY KEY([Date], Currency)
);

-- Sales Transactions

IF OBJECT_ID ('stg.FactSalesTransactions', 'U') IS NOT NULL
	DROP TABLE stg.FactSalesTransactions;

CREATE TABLE stg.FactSalesTransactions (
  TransactionID INT       NOT NULL,
  DateKey       INT       NOT NULL,
  ProductID     INT       NOT NULL,
  CustomerID    INT       NOT NULL,
  RegionID      INT       NOT NULL,
  Quantity      INT,
  UnitPrice     DECIMAL(10,2),
  Discount      DECIMAL(4,2),
  CONSTRAINT PK_Stg_FactSales PRIMARY KEY(TransactionID)
);

-- Price List

IF OBJECT_ID ('stg.PriceList', 'U') IS NOT NULL
	DROP TABLE stg.PriceList;


CREATE TABLE stg.PriceList (
  ProductID     INT       NOT NULL,
  Region        VARCHAR(50) NOT NULL,
  BasePrice     DECIMAL(10,2),
  EffectiveDate DATE      NOT NULL
);

-- CRM Accounts

IF OBJECT_ID ('stg.Accounts', 'U') IS NOT NULL
	DROP TABLE stg.Accounts;

CREATE TABLE stg.Accounts (
  AccountID    INT       NOT NULL,
  AccountName  VARCHAR(100),
  Region       VARCHAR(50),
  Industry     VARCHAR(50),
  CONSTRAINT PK_Stg_Accounts PRIMARY KEY(AccountID)
);

-- CRM Opportunities

IF OBJECT_ID ('stg.Opportunities', 'U') IS NOT NULL
	DROP TABLE stg.Opportunities;

CREATE TABLE stg.Opportunities (
  OpportunityID INT       NOT NULL,
  AccountID     INT       NOT NULL,
  Amount        DECIMAL(12,2),
  CloseDate     DATE,
  Stage         VARCHAR(50),
  CONSTRAINT PK_Stg_Opportunities PRIMARY KEY(OpportunityID)
);
