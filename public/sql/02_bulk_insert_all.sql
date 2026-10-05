-- =========================================================
-- FIFA World Cup Analytics - Load ALL tables from CSV files
-- (one file, runs all 17 tables in the correct order)
--
-- REQUIREMENTS
--   * SQL Server 2017 or newer (needs BULK INSERT ... FORMAT = 'CSV')
--   * Run 01_create_database.sql first
--   * The CSV files must be in a folder that the SQL SERVER can read
--     (see the note below)
--
-- HOW TO USE: only change the two lines marked  <<< CHANGE ME
-- =========================================================

USE FIFA_World_Cup_Analytics;
GO
SET NOCOUNT ON;

-- ---------------------------------------------------------
-- 1) Folder that contains the CSV files  (must end with \ or /)
--    Windows        :  N'C:\FIFA_Data\'
--    Network share  :  N'\\MyPC\Share\FIFA_Data\'
--    Linux / Docker :  N'/var/opt/mssql/data/FIFA_Data/'
--    NOTE: BULK INSERT reads the path from the machine where SQL Server
--    is running, not from the machine where you opened SSMS.
-- ---------------------------------------------------------
DECLARE @Path NVARCHAR(500) = N'C:\Users\shima\Desktop\FIFA-World-Cup-Data-Analytics\Fifa worldcup data\';     -- <<< CHANGE ME

-- ---------------------------------------------------------
-- 2) Row terminator of the CSV files
--    '0x0a'  = files with Unix line endings (LF)  -> the files as delivered
--    '0x0d0a'= files saved on Windows (CRLF), e.g. re-saved by Excel/Notepad
-- ---------------------------------------------------------
DECLARE @RowTerm VARCHAR(10) = '0x0a';                -- <<< CHANGE ME (only if needed)

-- Set to 1 to empty all tables first (safe re-run). 0 = do not touch existing data.
DECLARE @ClearFirst BIT = 0;

-- ---------------------------------------------------------
-- Load order (parents before children) + expected row counts
-- ---------------------------------------------------------
DECLARE @Tables TABLE (Seq INT PRIMARY KEY, TableName SYSNAME, ExpectedRows INT);
INSERT INTO @Tables (Seq, TableName, ExpectedRows) VALUES
 (1,  'Confederations',          6),
 (2,  'Federations',             91),
 (3,  'Teams',                   93),
 (4,  'Players',                 11364),
 (5,  'Tournaments',             31),
 (6,  'Stadiums',                256),
 (7,  'Matches',                 1352),
 (8,  'Team_Appearances',        2704),
 (9,  'Player_Appearances',      32824),
 (10, 'Goals',                   3945),
 (11, 'Bookings',                3459),
 (12, 'Substitutions',           12220),
 (13, 'Match_Attendance',        964),
 (14, 'Player_Match_Stats',      3288),
 (15, 'Team_Match_Stats',        16120),
 (16, 'Passing_Network_Edges',   52072),
 (17, 'FIFA_Rankings',           71019);

DECLARE @i INT, @t SYSNAME, @sql NVARCHAR(MAX), @file NVARCHAR(600);

-- ---------------------------------------------------------
-- Optional: clear tables (children first)
-- ---------------------------------------------------------
IF @ClearFirst = 1
BEGIN
    SET @i = 17;
    WHILE @i >= 1
    BEGIN
        SELECT @t = TableName FROM @Tables WHERE Seq = @i;
        SET @sql = N'DELETE FROM dbo.' + QUOTENAME(@t) + N';';
        EXEC sys.sp_executesql @sql;
        SET @i -= 1;
    END
    PRINT 'All tables cleared.';
END

-- ---------------------------------------------------------
-- Load every CSV
-- ---------------------------------------------------------
SET @i = 1;
WHILE @i <= 17
BEGIN
    SELECT @t = TableName FROM @Tables WHERE Seq = @i;
    SET @file = @Path + @t + N'.csv';

    SET @sql = N'BULK INSERT dbo.' + QUOTENAME(@t)
             + N' FROM ''' + REPLACE(@file, '''', '''''') + N''''
             + N' WITH ('
             + N'FORMAT = ''CSV'', FIELDQUOTE = ''"'', '
             + N'FIRSTROW = 2, FIELDTERMINATOR = '','', '
             + N'ROWTERMINATOR = ''' + @RowTerm + N''', '
             + N'CODEPAGE = ''65001'', '   -- UTF-8
             + N'KEEPNULLS, TABLOCK, BATCHSIZE = 50000);';

    BEGIN TRY
        EXEC sys.sp_executesql @sql;
        PRINT CONCAT(RIGHT('0' + CAST(@i AS VARCHAR(2)), 2), '/17  loaded  ', @t);
    END TRY
    BEGIN CATCH
        PRINT CONCAT('FAILED on table ', @t, ' (file: ', @file, ')');
        PRINT ERROR_MESSAGE();
        PRINT 'Loading stopped. Fix the problem, then set @ClearFirst = 1 and run again.';
        RETURN;
    END CATCH

    SET @i += 1;
END

-- ---------------------------------------------------------
-- Verify: loaded rows vs expected rows
-- ---------------------------------------------------------
DECLARE @Result TABLE (Seq INT, TableName SYSNAME, ExpectedRows INT, LoadedRows INT, Status VARCHAR(10));
DECLARE @cnt INT;

SET @i = 1;
WHILE @i <= 17
BEGIN
    SELECT @t = TableName FROM @Tables WHERE Seq = @i;
    SET @sql = N'SELECT @c = COUNT(*) FROM dbo.' + QUOTENAME(@t) + N';';
    EXEC sys.sp_executesql @sql, N'@c INT OUTPUT', @c = @cnt OUTPUT;

    INSERT INTO @Result
    SELECT Seq, TableName, ExpectedRows, @cnt,
           CASE WHEN @cnt = ExpectedRows THEN 'OK' ELSE 'MISMATCH' END
    FROM @Tables WHERE Seq = @i;

    SET @i += 1;
END

SELECT TableName, ExpectedRows, LoadedRows, Status
FROM @Result
ORDER BY Seq;
GO
