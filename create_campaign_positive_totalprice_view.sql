CREATE OR ALTER VIEW dbo.vw_CampaignPositiveTotalPrice AS
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
        ai.AccountingItemId AS CampaignAccountingItemId,
        ai.OrderId AS AccountingOrderId,
        ai.KeyType,
        ai.KeyValue,
        ai.ItemId AS CampaignItemId,
        item.ItemName AS ArticleItemName,
        ai.ItemName AS CampaignCodeOriginal,
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
        ai.Quantity AS RowQuantity,
        ai.TotalPrice AS RowTotalPrice,
        ai.FromDate AS CampaignRowFromDate,
        ai.ToDate AS CampaignRowToDate,
        ai.CreatedAt AS CampaignRowCreatedAt,
        ai.UpdatedAt AS CampaignRowUpdatedAt
    FROM AccountingBooking AS ai
    LEFT JOIN dbo.Item AS item
        ON item.ItemId = ai.ItemId
    WHERE
        ai.KeyType IN ('B', 'F', 'G')
        AND (
            UPPER(TRIM(ai.ItemId)) IN ('COUPON', 'COUPONBO')
            OR UPPER(TRIM(ai.ItemName)) LIKE N'%KANONDEAL%'
        )
        AND ISNULL(ai.TotalPrice, 0) > 0
)
SELECT
    cr.CampaignCode,
    cr.CampaignType,
    cr.BookingId,
    b.OrderId AS BookingOrderId,
    b.CustomerId,
    CAST(b.FromDate AS date) AS ArrivalDate,
    CAST(b.ToDate AS date) AS DepartureDate,
    b.BookingStatusId,
    CASE
        WHEN b.BookingStatusId IS NULL OR TRIM(b.BookingStatusId) = '' THEN N'Ej flyttbar'
        ELSE bs.Description
    END AS BookingStatusDescription,
    b.BookingImportStatus,
    cr.CampaignAccountingItemId,
    cr.AccountingOrderId,
    cr.KeyType,
    cr.KeyValue,
    cr.CampaignItemId,
    cr.ArticleItemName,
    cr.CampaignCodeOriginal,
    cr.RowQuantity,
    cr.RowTotalPrice,
    cr.CampaignRowFromDate,
    cr.CampaignRowToDate,
    cr.CampaignRowCreatedAt,
    cr.CampaignRowUpdatedAt
FROM CampaignRows AS cr
LEFT JOIN dbo.Booking AS b
    ON b.BookingId = cr.BookingId
LEFT JOIN dbo.BookingStatus AS bs
    ON bs.BookingStatusId = b.BookingStatusId;
GO

SELECT
    CampaignCode,
    CampaignType,
    BookingId,
    BookingOrderId,
    CustomerId,
    ArrivalDate,
    DepartureDate,
    BookingStatusId,
    BookingStatusDescription,
    BookingImportStatus,
    CampaignAccountingItemId,
    CampaignItemId,
    ArticleItemName,
    CampaignCodeOriginal,
    RowQuantity,
    RowTotalPrice,
    CampaignRowFromDate,
    CampaignRowToDate,
    CampaignRowCreatedAt,
    CampaignRowUpdatedAt
FROM dbo.vw_CampaignPositiveTotalPrice
ORDER BY
    CampaignCode,
    BookingId,
    CampaignAccountingItemId;

