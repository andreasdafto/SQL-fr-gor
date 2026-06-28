CREATE OR ALTER VIEW dbo.vw_DepartureCalendar
AS
SELECT
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
FROM dbo.Calendar
WHERE CalendarDate >= CONVERT(date, '2025-01-01', 120)
    AND CalendarDate <= CONVERT(date, '2027-12-31', 120);
GO
