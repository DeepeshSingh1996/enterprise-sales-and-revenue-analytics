CREATE OR ALTER PROCEDURE stg.load_stg AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '================================================';
		PRINT 'Loading Stage Layer';
		PRINT '================================================';

		PRINT '------------------------------------------------';
		PRINT 'Loading STG Tables';
		PRINT '------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: stg.DimDate';
		TRUNCATE TABLE stg.DimDate;
		PRINT '>> Inserting Data Into: stg.DimDate';
		BULK INSERT stg.DimDate
		FROM 'C:\Users\ASUS\Downloads\Projects\enterprise-sales-&-revenue-analytics\datasets\DimDate.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: stg.DimProduct';
		TRUNCATE TABLE stg.DimProduct;

		PRINT '>> Inserting Data Into: stg.DimProduct';
		BULK INSERT stg.DimProduct
		FROM 'C:\Users\ASUS\Downloads\Projects\enterprise-sales-&-revenue-analytics\datasets\DimProduct.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: stg.DimCustomer';
		TRUNCATE TABLE stg.DimCustomer;
		PRINT '>> Inserting Data Into: stg.DimCustomer';
		BULK INSERT stg.DimCustomer
		FROM 'C:\Users\ASUS\Downloads\Projects\enterprise-sales-&-revenue-analytics\datasets\DimCustomer.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

				
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: stg.DimRegion';
		TRUNCATE TABLE stg.DimRegion;
		PRINT '>> Inserting Data Into: stg.DimRegion';
		BULK INSERT stg.DimRegion
		FROM 'C:\Users\ASUS\Downloads\Projects\enterprise-sales-&-revenue-analytics\datasets\DimRegion.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: stg.CurrencyRates';
		TRUNCATE TABLE stg.CurrencyRates;
		PRINT '>> Inserting Data Into: stg.CurrencyRates';
		BULK INSERT stg.CurrencyRates
		FROM 'C:\Users\ASUS\Downloads\Projects\enterprise-sales-&-revenue-analytics\datasets\CurrencyRates.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: stg.FactSalesTransactions';
		TRUNCATE TABLE stg.FactSalesTransactions;
		PRINT '>> Inserting Data Into: stg.FactSalesTransactions';
		BULK INSERT stg.FactSalesTransactions
		FROM 'C:\Users\ASUS\Downloads\Projects\enterprise-sales-&-revenue-analytics\datasets\FactSalesTransactions.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: stg.PriceList';
		TRUNCATE TABLE stg.PriceList;
		PRINT '>> Inserting Data Into: stg.PriceList';
		BULK INSERT stg.PriceList
		FROM 'C:\Users\ASUS\Downloads\Projects\enterprise-sales-&-revenue-analytics\datasets\PriceList.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: stg.Accounts';
		TRUNCATE TABLE stg.Accounts;
		PRINT '>> Inserting Data Into: stg.Accounts';
		BULK INSERT stg.Accounts
		FROM 'C:\Users\ASUS\Downloads\Projects\enterprise-sales-&-revenue-analytics\datasets\Accounts.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: stg.Opportunities';
		TRUNCATE TABLE stg.Opportunities;
		PRINT '>> Inserting Data Into: stg.Opportunities';
		BULK INSERT stg.Opportunities
		FROM 'C:\Users\ASUS\Downloads\Projects\enterprise-sales-&-revenue-analytics\datasets\Opportunities.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		SET @batch_end_time = GETDATE();
		PRINT '=========================================='
		PRINT 'Loading Bronze Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '=========================================='
	END TRY
	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
END

EXEC stg.load_stg;
