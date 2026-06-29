IF OBJECT_ID(N'dbo.CabinCleaningInfo', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.CabinCleaningInfo (
        BookingItemTypeId int NOT NULL
            CONSTRAINT PK_CabinCleaningInfo PRIMARY KEY,
        Description nvarchar(100) NOT NULL,
        BedsToMake int NOT NULL,
        CleaningMinutes int NOT NULL,
        CleaningWindowHours decimal(4,1) NOT NULL
    );
END;
GO
