USE SalesAnalytics;
GO

-- Drop clean schema if exists and recreate
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'clean')
    EXEC('CREATE SCHEMA clean');
GO

-- Clean DimDate
IF OBJECT_ID('clean.DimDate') IS NOT NULL DROP TABLE clean.DimDate;
SELECT * INTO clean.DimDate FROM stg.DimDate;

-- Clean DimProduct
IF OBJECT_ID('clean.DimProduct') IS NOT NULL DROP TABLE clean.DimProduct;
SELECT * INTO clean.DimProduct FROM stg.DimProduct;

-- Clean DimCustomer
IF OBJECT_ID('clean.DimCustomer') IS NOT NULL DROP TABLE clean.DimCustomer;
SELECT * INTO clean.DimCustomer FROM stg.DimCustomer;

-- Clean DimRegion
IF OBJECT_ID('clean.DimRegion') IS NOT NULL DROP TABLE clean.DimRegion;
SELECT * INTO clean.DimRegion FROM stg.DimRegion;

-- Clean CurrencyRates
IF OBJECT_ID('clean.CurrencyRates') IS NOT NULL DROP TABLE clean.CurrencyRates;
SELECT * INTO clean.CurrencyRates FROM stg.CurrencyRates;

-- Create region to currency mapping
IF OBJECT_ID('stg.RegionCurrency') IS NOT NULL
    DROP TABLE stg.RegionCurrency;

CREATE TABLE stg.RegionCurrency (
    RegionName VARCHAR(50) PRIMARY KEY,
    CurrencyCode VARCHAR(3)
);

INSERT INTO stg.RegionCurrency (RegionName, CurrencyCode)
VALUES
    ('Americas', 'USD'),
    ('EMEA', 'EUR'),
    ('APAC', 'JPY');

-- Final Enriched Fact Table
IF OBJECT_ID('clean.FactSalesEnriched') IS NOT NULL DROP TABLE clean.FactSalesEnriched;
SELECT
    s.TransactionID,
    s.DateKey,
    s.ProductID,
    s.CustomerID,
    s.RegionID,
    s.Quantity,
    s.UnitPrice,
    s.Discount,

    -- Enrichments from Region
    r.RegionName,

    -- Enrichments from PriceList
    pl.BasePrice,
    (s.UnitPrice - pl.BasePrice) AS PriceDelta,

    -- Revenue Calculations
    (s.Quantity * s.UnitPrice * (1 - s.Discount)) AS RevenueLocal,

    -- Currency
    rc.CurrencyCode,
    cr.RateToUSD,
    (s.Quantity * s.UnitPrice * (1 - s.Discount)) * cr.RateToUSD AS RevenueUSD,

    -- CRM Enrichment: Account
    a.AccountName,
    a.Industry,

    -- CRM Enrichment: Opportunity
    o.OpportunityID,
    o.Stage AS OpportunityStage,
    o.Amount AS OpportunityAmount,
    o.CloseDate

INTO clean.FactSalesEnriched

FROM stg.FactSalesTransactions s

LEFT JOIN stg.DimRegion r
    ON s.RegionID = r.RegionID

LEFT JOIN stg.RegionCurrency rc
    ON r.RegionName = rc.RegionName

LEFT JOIN stg.CurrencyRates cr
    ON cr.[Date] = CONVERT(date, CONVERT(varchar(8), s.DateKey))
       AND cr.Currency = rc.CurrencyCode

OUTER APPLY (
    SELECT TOP 1 *
    FROM stg.PriceList pl
    WHERE pl.ProductID = s.ProductID
      AND pl.Region = r.RegionName
      AND pl.EffectiveDate <= CONVERT(date, CONVERT(varchar(8), s.DateKey))
    ORDER BY pl.EffectiveDate DESC
) pl

LEFT JOIN stg.Accounts a
    ON s.CustomerID = a.AccountID

OUTER APPLY (
    SELECT TOP 1 *
    FROM stg.Opportunities o
    WHERE o.AccountID = a.AccountID
      AND o.CloseDate >= CONVERT(date, CONVERT(varchar(8), s.DateKey))
    ORDER BY o.CloseDate ASC
) o;
GO

-- Indexing for performance
CREATE INDEX IX_FactSalesEnriched_DateKey ON clean.FactSalesEnriched(DateKey);
CREATE INDEX IX_FactSalesEnriched_ProductID ON clean.FactSalesEnriched(ProductID);
CREATE INDEX IX_FactSalesEnriched_CustomerID ON clean.FactSalesEnriched(CustomerID);
CREATE INDEX IX_FactSalesEnriched_RegionID ON clean.FactSalesEnriched(RegionID);
GO
