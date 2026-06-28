CREATE OR ALTER VIEW dbo.vw_BookingItem
AS
SELECT
    BookingItemId,
    Description,
    BookingItemTypeId,
    SiteId
FROM dbo.BookingItem;
GO
