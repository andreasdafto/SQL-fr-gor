CREATE OR ALTER VIEW dbo.vw_CampaignSummaryByCode AS
WITH InvoiceBookingLink AS (
    SELECT DISTINCT
        InvoiceId,
        BookingId
    FROM dbo.InvoiceItem
    WHERE
        InvoiceId IS NOT NULL
        AND BookingId IS NOT NULL
), AccountingBooking AS (
    SELECT
        ai.*,
        CASE
            WHEN ai.KeyType = 'B' THEN ai.KeyValue
            WHEN ai.KeyType = 'F' THEN ibl.BookingId
        END AS LinkedBookingId
    FROM dbo.AccountingItem AS ai
    LEFT JOIN InvoiceBookingLink AS ibl
        ON ai.KeyType = 'F'
       AND ai.KeyValue = ibl.InvoiceId
), CampaignBookings AS (
    SELECT
        ai.LinkedBookingId AS BookingId,
        b.CustomerId,
        CAST(b.FromDate AS date) AS ArrivalDate,
        CAST(b.ToDate AS date) AS DepartureDate,
        DATEDIFF(day, CAST(b.FromDate AS date), CAST(b.ToDate AS date)) AS Nights,
        DATEDIFF(day, CAST(b.CreatedAt AS date), CAST(b.FromDate AS date)) AS LeadTimeDays,
        b.Ordersource,
        b.SubOrdersource,
        b.CreatedAt,
        COALESCE(NULLIF(TRIM(b.BookingStatusId), ''), ' ') AS NormalizedBookingStatusId,
        CASE
            WHEN b.BookingStatusId IS NULL OR TRIM(b.BookingStatusId) = '' THEN N'Ej flyttbar'
            ELSE bs.Description
        END AS BookingStatusDescription,
        ai.ItemId AS CampaignItemId,
        CASE
            WHEN UPPER(TRIM(ai.ItemId)) = 'COUPONBO' OR UPPER(TRIM(ai.ItemName)) LIKE N'%KANONDEAL%' THEN N'BoendeKampanj'
            WHEN UPPER(TRIM(ai.ItemId)) = 'COUPON' THEN N'Biljett'
        END AS CampaignType,
        CASE
            WHEN NULLIF(TRIM(ai.ItemName), '') IS NULL THEN N'(SAKNAR KAMPANJKOD)'
            WHEN UPPER(TRIM(ai.ItemName)) LIKE N'RABATTKOD BOENDE %' THEN
                COALESCE(NULLIF(TRIM(SUBSTRING(UPPER(TRIM(ai.ItemName)), LEN(N'RABATTKOD BOENDE ') + 1, 4000)), ''), N'(SAKNAR KAMPANJKOD)')
            WHEN UPPER(TRIM(ai.ItemName)) LIKE N'RABATTKOD %' THEN
                COALESCE(NULLIF(TRIM(SUBSTRING(UPPER(TRIM(ai.ItemName)), LEN(N'RABATTKOD ') + 1, 4000)), ''), N'(SAKNAR KAMPANJKOD)')
            ELSE UPPER(TRIM(ai.ItemName))
        END AS CampaignCode,
        COUNT(DISTINCT ai.AccountingItemId) AS CampaignUses,
        SUM(ISNULL(ai.TotalPrice, 0)) AS CampaignAmount
    FROM AccountingBooking AS ai
    LEFT JOIN dbo.Booking AS b
        ON b.BookingId = ai.LinkedBookingId
    LEFT JOIN dbo.BookingStatus AS bs
        ON bs.BookingStatusId = b.BookingStatusId
    LEFT JOIN dbo.Item AS campaignItem
        ON campaignItem.ItemId = ai.ItemId
    WHERE
        ai.KeyType IN ('B', 'F', 'G')
        AND (
            UPPER(TRIM(ai.ItemId)) IN ('COUPON', 'COUPONBO')
            OR UPPER(TRIM(ai.ItemName)) LIKE N'%KANONDEAL%'
        )
    GROUP BY
        ai.LinkedBookingId,
        b.CustomerId,
        CAST(b.FromDate AS date),
        CAST(b.ToDate AS date),
        b.Ordersource,
        b.SubOrdersource,
        b.CreatedAt,
        COALESCE(NULLIF(TRIM(b.BookingStatusId), ''), ' '),
        CASE
            WHEN b.BookingStatusId IS NULL OR TRIM(b.BookingStatusId) = '' THEN N'Ej flyttbar'
            ELSE bs.Description
        END,
        ai.ItemId,
        CASE
            WHEN UPPER(TRIM(ai.ItemId)) = 'COUPONBO' OR UPPER(TRIM(ai.ItemName)) LIKE N'%KANONDEAL%' THEN N'BoendeKampanj'
            WHEN UPPER(TRIM(ai.ItemId)) = 'COUPON' THEN N'Biljett'
        END,
        CASE
            WHEN NULLIF(TRIM(ai.ItemName), '') IS NULL THEN N'(SAKNAR KAMPANJKOD)'
            WHEN UPPER(TRIM(ai.ItemName)) LIKE N'RABATTKOD BOENDE %' THEN
                COALESCE(NULLIF(TRIM(SUBSTRING(UPPER(TRIM(ai.ItemName)), LEN(N'RABATTKOD BOENDE ') + 1, 4000)), ''), N'(SAKNAR KAMPANJKOD)')
            WHEN UPPER(TRIM(ai.ItemName)) LIKE N'RABATTKOD %' THEN
                COALESCE(NULLIF(TRIM(SUBSTRING(UPPER(TRIM(ai.ItemName)), LEN(N'RABATTKOD ') + 1, 4000)), ''), N'(SAKNAR KAMPANJKOD)')
            ELSE UPPER(TRIM(ai.ItemName))
        END
), BookingValue AS (
    SELECT
        LinkedBookingId AS BookingId,
        SUM(ISNULL(TotalPrice, 0)) AS BookingPositiveValue
    FROM AccountingBooking
    WHERE
        KeyType IN ('B', 'F')
        AND LinkedBookingId IS NOT NULL
        AND ISNULL(TotalPrice, 0) > 0
    GROUP BY
        LinkedBookingId
), CampaignBookingWithValue AS (
    SELECT
        cb.*,
        ISNULL(bv.BookingPositiveValue, 0) AS BookingPositiveValue
    FROM CampaignBookings AS cb
    LEFT JOIN BookingValue AS bv
        ON bv.BookingId = cb.BookingId
)
SELECT
    CampaignItemId,
    CampaignType,
    CampaignCode,

    COUNT(DISTINCT BookingId) AS SoldBookings,
    COUNT(DISTINCT CustomerId) AS UniqueCustomers,
    SUM(CampaignUses) AS CampaignUses,
    SUM(CampaignAmount) AS CampaignAmount,
    SUM(BookingPositiveValue) AS BookingPositiveValue,
    SUM(BookingPositiveValue) + SUM(CampaignAmount) AS BookingValueAfterCampaign,

    AVG(CAST(BookingPositiveValue AS decimal(18, 2))) AS AvgBookingPositiveValue,
    AVG(CAST(CampaignAmount AS decimal(18, 2))) AS AvgCampaignAmount,
    SUM(Nights) AS TotalNights,
    AVG(CAST(Nights AS decimal(18, 2))) AS AvgNights,
    AVG(CAST(LeadTimeDays AS decimal(18, 2))) AS AvgBookingLeadTimeDays,
    AVG(CAST(Nights AS decimal(18, 2))) AS AvgBookingLengthNights,

    MIN(ArrivalDate) AS FirstArrivalDate,
    MAX(ArrivalDate) AS LastArrivalDate,
    MIN(DepartureDate) AS FirstDepartureDate,
    MAX(DepartureDate) AS LastDepartureDate
FROM CampaignBookingWithValue
GROUP BY
    CampaignItemId,
    CampaignType,
    CampaignCode;
GO

SELECT
    CampaignItemId,
    CampaignType,
    CampaignCode,
    SoldBookings,
    UniqueCustomers,
    CampaignUses,
    CampaignAmount,
    BookingPositiveValue,
    BookingValueAfterCampaign,
    TotalNights,
    AvgBookingLengthNights,
    AvgBookingLeadTimeDays,
    FirstArrivalDate,
    LastArrivalDate
FROM dbo.vw_CampaignSummaryByCode
ORDER BY SoldBookings DESC, CampaignAmount DESC;


