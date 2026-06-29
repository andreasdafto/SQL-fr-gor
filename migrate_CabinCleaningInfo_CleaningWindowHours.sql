/*
    Rename CleaningPeople to CleaningWindowHours and normalize the values.

    CleaningWindowHours means the available cleaning window between checkout
    and checkin. For Daftö this is 11:00-16:00, so rows with a positive value
    should be 5.0 hours.
*/

SET XACT_ABORT ON;
BEGIN TRAN;

IF COL_LENGTH(N'dbo.CabinCleaningInfo', N'CleaningWindowHours') IS NULL
    AND COL_LENGTH(N'dbo.CabinCleaningInfo', N'CleaningPeople') IS NOT NULL
BEGIN
    EXEC sp_rename
        N'dbo.CabinCleaningInfo.CleaningPeople',
        N'CleaningWindowHours',
        N'COLUMN';
END;

IF COL_LENGTH(N'dbo.CabinCleaningInfoValueBackup', N'CleaningWindowHours') IS NULL
    AND COL_LENGTH(N'dbo.CabinCleaningInfoValueBackup', N'CleaningPeople') IS NOT NULL
BEGIN
    EXEC sp_rename
        N'dbo.CabinCleaningInfoValueBackup.CleaningPeople',
        N'CleaningWindowHours',
        N'COLUMN';
END;

IF COL_LENGTH(N'dbo.CabinCleaningInfo', N'CleaningWindowHours') IS NOT NULL
BEGIN
    EXEC sys.sp_executesql N'
        UPDATE dbo.CabinCleaningInfo
        SET CleaningWindowHours =
            CASE
                WHEN CleaningWindowHours > 0 THEN CAST(5.0 AS decimal(4,1))
                ELSE CAST(0.0 AS decimal(4,1))
            END;
    ';
END;

COMMIT;

IF COL_LENGTH(N'dbo.CabinCleaningInfo', N'CleaningWindowHours') IS NOT NULL
BEGIN
    EXEC sys.sp_executesql N'
        SELECT
            BookingItemTypeId,
            Description,
            BedsToMake,
            CleaningMinutes,
            CleaningWindowHours
        FROM dbo.CabinCleaningInfo
        ORDER BY BookingItemTypeId;
    ';
END;
