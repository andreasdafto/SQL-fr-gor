-- Diagnos: varför kommer KANONDEAL inte med i kampanjvyerna?
-- Kör hela filen i SQL Server.

SELECT
    ai.AccountingItemId,
    ai.KeyType,
    ai.KeyValue AS BookingId,
    b.BookingId AS MatchedBookingId,
    b.Deleted AS BookingDeleted,
    ai.Deleted AS AccountingDeleted,
    ai.ItemId,
    ai.ItemName,
    ai.Quantity,
    ai.TotalPrice,
    campaignItem.ItemName AS ItemTableName,
    campaignItem.IsPayment,
    ai.FromDate AS AccountingFromDate,
    ai.ToDate AS AccountingToDate,
    ai.CreatedAt AS AccountingCreatedAt,
    b.FromDate AS BookingFromDate,
    b.ToDate AS BookingToDate,

    CASE WHEN ai.KeyType = 'B' THEN 1 ELSE 0 END AS PassKeyTypeB,
    CASE WHEN b.BookingId IS NOT NULL THEN 1 ELSE 0 END AS PassBookingJoin,
    CASE WHEN ISNULL(b.Deleted, 0) = 0 THEN 1 ELSE 0 END AS PassBookingNotDeleted,
    CASE WHEN ISNULL(ai.Deleted, 0) = 0 THEN 1 ELSE 0 END AS PassAccountingNotDeleted,
    CASE WHEN ai.ItemId IN ('Coupon', 'CouponBo') THEN 1 ELSE 0 END AS PassCouponItemId,
    CASE WHEN ISNULL(ai.TotalPrice, 0) < 0 THEN 1 ELSE 0 END AS PassNegativeTotalPrice,
    CASE WHEN NULLIF(TRIM(ai.ItemName), '') IS NOT NULL THEN 1 ELSE 0 END AS PassHasItemName,
    CASE WHEN ISNULL(campaignItem.IsPayment, 0) = 0 THEN 1 ELSE 0 END AS PassNotPaymentItem,

    CASE
        WHEN ai.KeyType = 'B'
         AND b.BookingId IS NOT NULL
         AND ISNULL(b.Deleted, 0) = 0
         AND ISNULL(ai.Deleted, 0) = 0
         AND (
                ai.ItemId IN ('Coupon', 'CouponBo')
                OR (
                    ISNULL(ai.TotalPrice, 0) < 0
                    AND NULLIF(TRIM(ai.ItemName), '') IS NOT NULL
                    AND ISNULL(campaignItem.IsPayment, 0) = 0
                )
             )
        THEN 1 ELSE 0
    END AS IncludedByCurrentViewFilter
FROM dbo.AccountingItem AS ai
LEFT JOIN dbo.Booking AS b
    ON ai.KeyType = 'B'
   AND ai.KeyValue = b.BookingId
LEFT JOIN dbo.Item AS campaignItem
    ON campaignItem.ItemId = ai.ItemId
WHERE
    UPPER(TRIM(ai.ItemName)) LIKE N'%KANONDEAL%'
ORDER BY
    ai.CreatedAt DESC,
    ai.AccountingItemId;

-- Sammanfattning per år och artikel.
SELECT
    YEAR(COALESCE(ai.CreatedAt, ai.FromDate)) AS AccountingYear,
    ai.ItemId,
    ai.ItemName,
    campaignItem.IsPayment,
    COUNT(*) AS RowsCount,
    COUNT(DISTINCT CASE WHEN ai.KeyType = 'B' THEN ai.KeyValue END) AS BookingCount,
    SUM(ISNULL(ai.TotalPrice, 0)) AS TotalAmount,
    MIN(ai.CreatedAt) AS FirstCreatedAt,
    MAX(ai.CreatedAt) AS LastCreatedAt,
    MIN(ai.FromDate) AS FirstAccountingFromDate,
    MAX(ai.FromDate) AS LastAccountingFromDate
FROM dbo.AccountingItem AS ai
LEFT JOIN dbo.Item AS campaignItem
    ON campaignItem.ItemId = ai.ItemId
WHERE
    UPPER(TRIM(ai.ItemName)) LIKE N'%KANONDEAL%'
GROUP BY
    YEAR(COALESCE(ai.CreatedAt, ai.FromDate)),
    ai.ItemId,
    ai.ItemName,
    campaignItem.IsPayment
ORDER BY
    AccountingYear DESC,
    RowsCount DESC;
