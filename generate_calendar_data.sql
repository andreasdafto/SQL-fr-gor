SET XACT_ABORT ON;
SET DATEFIRST 1;

DECLARE @StartDate date = '1980-01-01';
DECLARE @EndDate date = '2100-12-31';

;WITH Dates AS (
    SELECT @StartDate AS CalendarDate

    UNION ALL

    SELECT DATEADD(day, 1, CalendarDate)
    FROM Dates
    WHERE CalendarDate < @EndDate
), CalendarSource AS (
    SELECT
        CalendarDate,
        CONCAT(N'Qtr ', DATEPART(quarter, CalendarDate)) AS QuarterName,
        MONTH(CalendarDate) AS MonthNumber,
        FORMAT(CalendarDate, N'MMMM', 'sv-SE') AS MonthName,
        LEFT(FORMAT(CalendarDate, N'MMM', 'sv-SE'), 3) AS MonthShortName,
        DATEPART(iso_week, CalendarDate) AS WeekOfYear,
        DATEDIFF(week, DATEFROMPARTS(YEAR(CalendarDate), MONTH(CalendarDate), 1), CalendarDate) + 1 AS WeekOfMonth,
        DATEPART(dayofyear, CalendarDate) AS DayOfYear,
        DAY(CalendarDate) AS DayOfMonth,
        FORMAT(CalendarDate, N'dddd', 'sv-SE') AS DayName,
        LEFT(FORMAT(CalendarDate, N'ddd', 'sv-SE'), 3) AS DayShortName,
        DAY(EOMONTH(CalendarDate)) AS DaysInMonth,
        CAST(CalendarDate AS datetime2(0)) AS CalendarDateTime,
        YEAR(CalendarDate) AS CalendarYear,
        DATEDIFF(day, CONVERT(date, '19000101'), CalendarDate) % 7 AS DayNumberOfWeek
    FROM Dates
)
MERGE dbo.Calendar AS target
USING CalendarSource AS source
ON target.CalendarDate = source.CalendarDate
WHEN MATCHED THEN
    UPDATE SET
        QuarterName = source.QuarterName,
        MonthNumber = source.MonthNumber,
        MonthName = source.MonthName,
        MonthShortName = source.MonthShortName,
        WeekOfYear = source.WeekOfYear,
        WeekOfMonth = source.WeekOfMonth,
        DayOfYear = source.DayOfYear,
        DayOfMonth = source.DayOfMonth,
        DayName = source.DayName,
        DayShortName = source.DayShortName,
        DaysInMonth = source.DaysInMonth,
        CalendarDateTime = source.CalendarDateTime,
        CalendarYear = source.CalendarYear,
        DayNumberOfWeek = source.DayNumberOfWeek
WHEN NOT MATCHED BY TARGET THEN
    INSERT (
        CalendarDate,
        QuarterName,
        MonthNumber,
        MonthName,
        MonthShortName,
        WeekOfYear,
        WeekOfMonth,
        DayOfYear,
        DayOfMonth,
        DayName,
        DayShortName,
        DaysInMonth,
        CalendarDateTime,
        CalendarYear,
        DayNumberOfWeek
    )
    VALUES (
        source.CalendarDate,
        source.QuarterName,
        source.MonthNumber,
        source.MonthName,
        source.MonthShortName,
        source.WeekOfYear,
        source.WeekOfMonth,
        source.DayOfYear,
        source.DayOfMonth,
        source.DayName,
        source.DayShortName,
        source.DaysInMonth,
        source.CalendarDateTime,
        source.CalendarYear,
        source.DayNumberOfWeek
    )
OPTION (MAXRECURSION 0);

SELECT
    COUNT(*) AS CalendarRows,
    MIN(CalendarDate) AS MinDate,
    MAX(CalendarDate) AS MaxDate
FROM dbo.Calendar;

