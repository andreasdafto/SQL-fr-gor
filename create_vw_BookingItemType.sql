CREATE OR ALTER VIEW dbo.vw_HousekeepingBookingItemType
AS
SELECT
    bit.BookingItemTypeId,
    bit.Description,
    bit.SiteId,
    cci.BedsToMake,
    cci.CleaningMinutes,
    cci.CleaningWindowHours,
    CASE WHEN ISNULL(cci.CleaningMinutes, 0) > 0 THEN 1 ELSE 0 END AS IsCleaningUnit
FROM dbo.BookingItemType AS bit
INNER JOIN dbo.CabinCleaningInfo AS cci
    ON cci.BookingItemTypeId = bit.BookingItemTypeId
WHERE cci.CleaningMinutes > 0;
GO
