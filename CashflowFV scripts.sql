Create PROCEDURE CalculateFutureValue
    @CashFlows NVARCHAR(MAX),  -- Input: Comma-separated cash flow values
    @Rate FLOAT,              -- Input: Annual discount rate as a decimal (e.g., 0.05 for 5%)
    @TimePeriods NVARCHAR(MAX) -- Input: Comma-separated time periods in years
AS
BEGIN
    BEGIN TRY
        -- Start a transaction to ensure atomicity
        BEGIN TRANSACTION;

        -- Create a temporary table to store results
        CREATE TABLE #FVCalculation (
            TimePeriod INT,      -- The year associated with the cash flow
            CashFlow FLOAT,      -- The input cash flow value
            FutureValue FLOAT    -- The calculated future value
        );

        -- Split the input strings into table-like structures
        DECLARE @CashFlowTable TABLE (Value FLOAT);
        DECLARE @TimeTable TABLE (Value INT);

        -- Populate @CashFlowTable with cash flow values
        INSERT INTO @CashFlowTable (Value)
        SELECT value
        FROM STRING_SPLIT(@CashFlows, ',');

        -- Populate @TimeTable with time period values
        INSERT INTO @TimeTable (Value)
        SELECT value
        FROM STRING_SPLIT(@TimePeriods, ',');

        -- Declare variables for calculations
        DECLARE @Time INT, @CashFlow FLOAT, @DiscountFactor FLOAT, @FutureValue FLOAT;
        DECLARE @Index INT = 1;

        -- Iterate through each cash flow and time period
        WHILE @Index <= (SELECT COUNT(*) FROM @CashFlowTable)
        BEGIN
            -- Fetch the current time period
            ;WITH RankedTimeTable AS (
                SELECT Value, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS RowNum
                FROM @TimeTable
            )
            SELECT @Time = Value
            FROM RankedTimeTable
            WHERE RowNum = @Index;

            -- Fetch the current cash flow
            ;WITH RankedCashFlowTable AS (
                SELECT Value, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS RowNum
                FROM @CashFlowTable
            )
            SELECT @CashFlow = Value
            FROM RankedCashFlowTable
            WHERE RowNum = @Index;

            -- Calculate the discount factor and future value
            SET @DiscountFactor = POWER(1 + @Rate, @Time);
            SET @FutureValue = @CashFlow * @DiscountFactor;

            -- Store the results in the temporary table
            INSERT INTO #FVCalculation (TimePeriod, CashFlow, FutureValue)
            VALUES (@Time, @CashFlow, @FutureValue);

            -- Move to the next iteration
            SET @Index = @Index + 1;
        END

        -- Output all results
        SELECT * FROM #FVCalculation;

        -- Commit the transaction if all operations succeed
        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH
        -- Rollback the transaction in case of an error
        ROLLBACK TRANSACTION;

        -- Re-throw the error for debugging
        THROW;
    END CATCH

    -- Cleanup: Drop the temporary table
    IF OBJECT_ID('tempdb..#FVCalculation') IS NOT NULL
        DROP TABLE #FVCalculation;
END
