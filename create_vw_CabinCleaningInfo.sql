CREATE OR ALTER VIEW dbo.vw_CabinCleaningInfo
AS
SELECT
    BookingItemTypeId,
    Description,
    BedsToMake,
    CleaningMinutes,
    CleaningWindowHours
FROM dbo.CabinCleaningInfo
WHERE CleaningMinutes > 0;
GO
