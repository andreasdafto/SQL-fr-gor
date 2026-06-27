CREATE OR ALTER VIEW dbo.vw_CampaignAccountingBookings AS
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
), CampaignRows AS (
    SELECT
        ai.LinkedBookingId AS BookingId,
        CASE WHEN ai.LinkedBookingId IS NULL THEN ai.AccountingItemId END AS UnlinkedCampaignAccountingItemId,
        STRING_AGG(CAST(ai.KeyType AS nvarchar(max)), N', ') AS CampaignKeyTypes,
        STRING_AGG(CAST(ai.ItemId AS nvarchar(max)), N', ') AS CampaignItemIds,
        STRING_AGG(CAST(CASE
            WHEN UPPER(TRIM(ai.ItemId)) = 'COUPONBO' OR UPPER(TRIM(ai.ItemName)) LIKE N'%KANONDEAL%' THEN N'BoendeKampanj'
            WHEN UPPER(TRIM(ai.ItemId)) = 'COUPON' THEN N'Biljett'
        END AS nvarchar(max)), N', ') AS CampaignTypes,
        STRING_AGG(CAST(ai.ItemName AS nvarchar(max)), N', ') AS CampaignCodesOriginal,
        STRING_AGG(CAST(
            CASE
                WHEN NULLIF(TRIM(ai.ItemName), '') IS NULL THEN N'(SAKNAR KAMPANJKOD)'
                WHEN UPPER(TRIM(ai.ItemName)) LIKE N'RABATTKOD BOENDE %' THEN
                    COALESCE(NULLIF(TRIM(SUBSTRING(UPPER(TRIM(ai.ItemName)), LEN(N'RABATTKOD BOENDE ') + 1, 4000)), ''), N'(SAKNAR KAMPANJKOD)')
                WHEN UPPER(TRIM(ai.ItemName)) LIKE N'RABATTKOD %' THEN
                    COALESCE(NULLIF(TRIM(SUBSTRING(UPPER(TRIM(ai.ItemName)), LEN(N'RABATTKOD ') + 1, 4000)), ''), N'(SAKNAR KAMPANJKOD)')
                ELSE UPPER(TRIM(ai.ItemName))
            END AS nvarchar(max)), N', ') AS CampaignCodes,
        COUNT(DISTINCT ai.AccountingItemId) AS CampaignUses,
        SUM(ISNULL(ai.TotalPrice, 0)) AS CampaignAmount
    FROM AccountingBooking AS ai
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
        CASE WHEN ai.LinkedBookingId IS NULL THEN ai.AccountingItemId END
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
)
SELECT
    cr.BookingId,
    CASE WHEN b.BookingId IS NULL THEN 0 ELSE 1 END AS BookingRecordFound,
    b.Deleted AS BookingDeleted,
    b.BookingImportStatus,
    b.CustomerId,
    b.BookingItemId,
    CAST(b.FromDate AS date) AS ArrivalDate,
    CAST(b.ToDate AS date) AS DepartureDate,
    b.Ordersource,
    b.SubOrdersource,
    b.OrderId AS BookingOrderId,

    COALESCE(NULLIF(TRIM(b.BookingStatusId), ''), ' ') AS NormalizedBookingStatusId,
    CASE
        WHEN b.BookingStatusId IS NULL OR TRIM(b.BookingStatusId) = '' THEN N'Ej flyttbar'
        ELSE bs.Description
    END AS BookingStatusDescription,

    bi.BookingItemTypeId,
    bit.Description AS BookingItemTypeDescription,
    mc.MainCategoryId,
    mc.MainCategoryName,

    cr.CampaignKeyTypes,
    cr.CampaignItemIds,
    cr.CampaignTypes,
    cr.CampaignCodesOriginal,
    cr.CampaignCodes,
    cr.CampaignUses,
    cr.CampaignAmount,
    bv.BookingPositiveValue,

    cal.CalendarYear AS ArrivalYear,
    cal.MonthNumber AS ArrivalMonthNumber,
    cal.MonthName AS ArrivalMonthName,
    cal.WeekOfYear AS ArrivalWeekOfYear
FROM CampaignRows AS cr
LEFT JOIN dbo.Booking AS b
    ON b.BookingId = cr.BookingId
LEFT JOIN BookingValue AS bv
    ON bv.BookingId = b.BookingId
LEFT JOIN dbo.BookingStatus AS bs
    ON bs.BookingStatusId = b.BookingStatusId
LEFT JOIN dbo.BookingItem AS bi
    ON bi.BookingItemId = b.BookingItemId
LEFT JOIN dbo.BookingItemType AS bit
    ON bit.BookingItemTypeId = bi.BookingItemTypeId
LEFT JOIN dbo.MainCategoryMapping AS mcm
    ON mcm.UnitCategoryId = bit.BookingItemTypeId
LEFT JOIN dbo.MainCategory AS mc
    ON mc.MainCategoryId = mcm.MainCategoryId
LEFT JOIN dbo.Calendar AS cal
    ON cal.CalendarDate = CAST(b.FromDate AS date);
GO

SELECT
    BookingId,
    BookingRecordFound,
    BookingDeleted,
    BookingImportStatus,
    ArrivalDate,
    DepartureDate,
    BookingItemTypeDescription,
    MainCategoryName,
    CampaignKeyTypes,
    CampaignItemIds,
    CampaignTypes,
    CampaignCodesOriginal,
    CampaignCodes,
    CampaignUses,
    CampaignAmount,
    BookingPositiveValue
FROM dbo.vw_CampaignAccountingBookings
ORDER BY ArrivalDate DESC, BookingId;


