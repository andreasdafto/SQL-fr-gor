CREATE OR ALTER VIEW dbo.vw_Bokningar
AS
SELECT
    b.BookingId,
    b.CustomerId,
    b.BookingItemId,
    bi.Description AS BookingItemDescription,
    bi.BookingItemTypeId,
    b.FromDate,
    b.ToDate,
    b.GroupId,
    b.CreatedAt,
    b.CreatedBy,
    b.UpdatedAt,
    b.UpdatedBy,
    b.CustomerTypeId,
    b.Ordersource,
    b.SubOrdersource,
    b.OrderId,
    COALESCE(bs.Description, N'Okand status') AS BookingStatusDescription,
    b.SiteId,
    b.BookingImportStatus,
    b.FirstSeenAt,
    b.LastSeenAt,
    b.CancelledDetectedAt,
    b.EndedEarlyDetectedAt,
    b.CompletedDetectedAt,

    CONVERT(date, b.FromDate) AS FromDateDate,
    CONVERT(date, b.ToDate) AS ToDateDate,
    CONVERT(date, b.CreatedAt) AS CreatedAtDate,

    DATEDIFF(day, CONVERT(date, b.FromDate), CONVERT(date, b.ToDate)) AS AntalDagar,
    DATEDIFF(day, CONVERT(date, GETDATE()), CONVERT(date, b.FromDate)) AS AntalDagarTillAnkomst
FROM dbo.Booking AS b
LEFT JOIN dbo.BookingStatus AS bs
    ON bs.BookingStatusId = b.BookingStatusId
LEFT JOIN dbo.BookingItem AS bi
    ON bi.BookingItemId = b.BookingItemId
WHERE b.FromDate >= CONVERT(datetime, '2025-01-01', 120);
GO
