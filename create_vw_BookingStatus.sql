CREATE OR ALTER VIEW dbo.vw_BookingStatus
AS
SELECT
    BookingStatusId,
    Description,
    SiteId
FROM dbo.BookingStatus;
GO
