-- Shows campaign rows that point to a BookingId, but no matching row exists in dbo.Booking.
-- These become BookingRecordFound = 0 in dbo.vw_CampaignAccountingBookings.

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
        END AS LinkedBookingId,
        ibl.InvoiceId AS LinkedInvoiceIdFromInvoiceItem
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
        ai.LinkedInvoiceIdFromInvoiceItem,
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
        ai.UpdatedAt AS CampaignRowUpdatedAt,
        ai.Deleted AS CampaignAccountingDeleted
    FROM AccountingBooking AS ai
    LEFT JOIN dbo.Booking AS bFilter
        ON bFilter.BookingId = ai.LinkedBookingId
    LEFT JOIN dbo.Item AS item
        ON item.ItemId = ai.ItemId
    WHERE
        ai.KeyType IN ('B', 'F', 'G')
        -- Reporting starts at 2025-01-01 because earlier imported data is incomplete/backfill only.
        AND COALESCE(CAST(bFilter.FromDate AS date), CAST(ai.FromDate AS date)) >= '2025-01-01'
        AND (
            UPPER(TRIM(ai.ItemId)) IN ('COUPON', 'COUPONBO')
            OR UPPER(TRIM(ai.ItemName)) LIKE N'%KANONDEAL%'
        )
)
SELECT
    cr.BookingId,
    cr.CampaignCode,
    cr.CampaignType,
    cr.CampaignAccountingItemId,
    cr.AccountingOrderId,
    cr.KeyType,
    cr.KeyValue,
    cr.LinkedInvoiceIdFromInvoiceItem,
    cr.CampaignItemId,
    cr.ArticleItemName,
    cr.CampaignCodeOriginal,
    cr.RowQuantity,
    cr.RowTotalPrice,
    cr.CampaignRowFromDate,
    cr.CampaignRowToDate,
    cr.CampaignRowCreatedAt,
    cr.CampaignRowUpdatedAt,
    cr.CampaignAccountingDeleted,
    CASE
        WHEN cr.KeyType = 'B' THEN N'AccountingItem.KeyValue points directly to missing BookingId'
        WHEN cr.KeyType = 'F' THEN N'InvoiceItem links invoice to BookingId, but Booking row is missing'
        WHEN cr.KeyType = 'G' THEN N'Group/accounting row has no reliable booking lookup'
        ELSE N'Unknown link type'
    END AS MissingBookingReason,
    ii.InvoiceId,
    ii.InvoiceDate,
    ii.Status AS InvoiceStatus,
    ii.OrderId AS InvoiceOrderId,
    ii.Deleted AS InvoiceItemDeleted
FROM CampaignRows AS cr
LEFT JOIN dbo.Booking AS b
    ON b.BookingId = cr.BookingId
LEFT JOIN dbo.InvoiceItem AS ii
    ON cr.KeyType = 'F'
   AND ii.InvoiceId = cr.KeyValue
   AND ii.BookingId = cr.BookingId
WHERE
    cr.BookingId IS NOT NULL
    AND b.BookingId IS NULL
ORDER BY
    cr.BookingId,
    cr.CampaignCode,
    cr.CampaignAccountingItemId;

