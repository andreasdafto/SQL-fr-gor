CREATE TABLE dbo.Calendar (
    CalendarDate date NOT NULL PRIMARY KEY,
    QuarterName nvarchar(10) NOT NULL,
    MonthNumber tinyint NOT NULL,
    MonthName nvarchar(20) NOT NULL,
    MonthShortName nvarchar(10) NOT NULL,
    WeekOfYear tinyint NOT NULL,
    WeekOfMonth tinyint NOT NULL,
    DayOfYear smallint NOT NULL,
    DayOfMonth tinyint NOT NULL,
    DayName nvarchar(20) NOT NULL,
    DayShortName nvarchar(10) NOT NULL,
    DaysInMonth tinyint NOT NULL,
    CalendarDateTime datetime2(0) NOT NULL,
    CalendarYear smallint NOT NULL,
    DayNumberOfWeek tinyint NOT NULL
);
