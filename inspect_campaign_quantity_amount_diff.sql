-- Drilldown for why CampaignQuantity and CampaignAmount differ.
-- Change @CampaignCode to inspect one code, or leave NULL to show all rows where Quantity <> TotalPrice.

DECLARE @CampaignCode nvarchar(100) = NULL;
-- Examples:
-- DECLARE @CampaignCode nvarchar(100) = N'BLACK30';
-- DECLARE @CampaignCode nvarchar(100) = N'LATESUMMER';
-- DECLARE @CampaignCode nvarchar(100) = N'USM25';

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
        ai.AccountingItemId,
        ai.OrderId AS AccountingOrderId,
        ai.KeyType,
        ai.KeyValue,
        ai.ItemId AS CampaignItemId,
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
        ai.Quantity,
        ai.TotalPrice,
        ISNULL(ai.TotalPrice, 0) - ISNULL(ai.Quantity, 0) AS AmountMinusQuantity,
        ai.FromDate AS CampaignRowFromDate,
        ai.ToDate AS CampaignRowToDate,
        ai.CreatedAt AS CampaignRowCreatedAt,
        ai.UpdatedAt AS CampaignRowUpdatedAt
    FROM AccountingBooking AS ai
    WHERE
        ai.KeyType IN ('B', 'F', 'G')
        AND (
            UPPER(TRIM(ai.ItemId)) IN ('COUPON', 'COUPONBO')
            OR UPPER(TRIM(ai.ItemName)) LIKE N'%KANONDEAL%'
        )
), BookingValue AS (
    SELECT
        LinkedBookingId AS BookingId,
        SUM(CASE WHEN ISNULL(TotalPrice, 0) > 0 THEN ISNULL(TotalPrice, 0) ELSE 0 END) AS BookingPositiveValue,
        SUM(CASE WHEN ISNULL(TotalPrice, 0) < 0 THEN ISNULL(TotalPrice, 0) ELSE 0 END) AS BookingNegativeValue,
        SUM(ISNULL(TotalPrice, 0)) AS BookingNetValue,
        COUNT(*) AS AccountingRows
    FROM AccountingBooking
    WHERE
        KeyType IN ('B', 'F')
        AND LinkedBookingId IS NOT NULL
    GROUP BY
        LinkedBookingId
)
SELECT
    cr.CampaignCode,
    cr.CampaignType,
    COUNT(DISTINCT cr.BookingId) AS Bookings,
    COUNT(*) AS CampaignRows,
    SUM(ISNULL(cr.Quantity, 0)) AS CampaignQuantity,
    SUM(ISNULL(cr.TotalPrice, 0)) AS CampaignAmount,
    SUM(ISNULL(cr.TotalPrice, 0)) - SUM(ISNULL(cr.Quantity, 0)) AS AmountMinusQuantity
FROM CampaignRows AS cr
WHERE
    (@CampaignCode IS NULL OR cr.CampaignCode = UPPER(TRIM(@CampaignCode)))
    AND (
        @CampaignCode IS NOT NULL
        OR ISNULL(cr.Quantity, 0) <> ISNULL(cr.TotalPrice, 0)
    )
GROUP BY
    cr.CampaignCode,
    cr.CampaignType
ORDER BY
    cr.CampaignCode;

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
        ai.AccountingItemId,
        ai.OrderId AS AccountingOrderId,
        ai.KeyType,
        ai.KeyValue,
        ai.ItemId AS CampaignItemId,
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
        ai.Quantity,
        ai.TotalPrice,
        ISNULL(ai.TotalPrice, 0) - ISNULL(ai.Quantity, 0) AS AmountMinusQuantity,
        ai.FromDate AS CampaignRowFromDate,
        ai.ToDate AS CampaignRowToDate,
        ai.CreatedAt AS CampaignRowCreatedAt,
        ai.UpdatedAt AS CampaignRowUpdatedAt
    FROM AccountingBooking AS ai
    WHERE
        ai.KeyType IN ('B', 'F', 'G')
        AND (
            UPPER(TRIM(ai.ItemId)) IN ('COUPON', 'COUPONBO')
            OR UPPER(TRIM(ai.ItemName)) LIKE N'%KANONDEAL%'
        )
), BookingValue AS (
    SELECT
        LinkedBookingId AS BookingId,
        SUM(CASE WHEN ISNULL(TotalPrice, 0) > 0 THEN ISNULL(TotalPrice, 0) ELSE 0 END) AS BookingPositiveValue,
        SUM(CASE WHEN ISNULL(TotalPrice, 0) < 0 THEN ISNULL(TotalPrice, 0) ELSE 0 END) AS BookingNegativeValue,
        SUM(ISNULL(TotalPrice, 0)) AS BookingNetValue,
        COUNT(*) AS AccountingRows
    FROM AccountingBooking
    WHERE
        KeyType IN ('B', 'F')
        AND LinkedBookingId IS NOT NULL
    GROUP BY
        LinkedBookingId
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
    cr.AccountingItemId AS CampaignAccountingItemId,
    cr.AccountingOrderId,
    cr.KeyType,
    cr.KeyValue,
    cr.CampaignItemId,
    cr.CampaignCodeOriginal,
    cr.Quantity AS RowQuantity,
    cr.TotalPrice AS RowTotalPrice,
    cr.AmountMinusQuantity,
    bv.BookingPositiveValue,
    bv.BookingNegativeValue,
    bv.BookingNetValue,
    bv.AccountingRows,
    cr.CampaignRowFromDate,
    cr.CampaignRowToDate,
    cr.CampaignRowCreatedAt,
    cr.CampaignRowUpdatedAt
FROM CampaignRows AS cr
LEFT JOIN dbo.Booking AS b
    ON b.BookingId = cr.BookingId
LEFT JOIN dbo.BookingStatus AS bs
    ON bs.BookingStatusId = b.BookingStatusId
LEFT JOIN BookingValue AS bv
    ON bv.BookingId = cr.BookingId
WHERE
    (@CampaignCode IS NULL OR cr.CampaignCode = UPPER(TRIM(@CampaignCode)))
    AND (
        @CampaignCode IS NOT NULL
        OR ISNULL(cr.Quantity, 0) <> ISNULL(cr.TotalPrice, 0)
    )
ORDER BY
    ABS(cr.AmountMinusQuantity) DESC,
    cr.CampaignCode,
    cr.BookingId,
    cr.AccountingItemId;
