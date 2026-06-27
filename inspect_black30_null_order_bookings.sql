-- Visar Black30-bokningar som saknar Booking.OrderId.
-- De finns i Booking-tabellen, men räknas inte som SoldOrders eftersom COUNT(DISTINCT OrderId) ignorerar NULL.

SELECT
    b.BookingId,
    b.OrderId AS BookingOrderId,
    b.CustomerId,
    b.BookingItemId,
    bi.Description AS BookingItemDescription,
    bi.BookingItemTypeId,
    bit.Description AS BookingItemTypeDescription,
    b.FromDate,
    b.ToDate,
    DATEDIFF(day, CAST(b.FromDate AS date), CAST(b.ToDate AS date)) AS Nights,
    b.CreatedAt,
    DATEDIFF(day, CAST(b.CreatedAt AS date), CAST(b.FromDate AS date)) AS LeadTimeDays,
    b.UpdatedAt,
    b.Ordersource,
    b.SubOrdersource,
    b.BookingStatusId,
    CASE
        WHEN b.BookingStatusId IS NULL OR TRIM(b.BookingStatusId) = '' THEN N'Ej flyttbar'
        ELSE bs.Description
    END AS BookingStatusDescription,
    b.GroupId,
    b.CustomerTypeId,
    b.GrouplineId,
    b.SiteId,
    b.Parts,
    b.Deleted AS BookingDeleted,
    b.BookingImportStatus,

    campaign.AccountingItemId AS CampaignAccountingItemId,
    campaign.OrderId AS CampaignAccountingOrderId,
    campaign.ItemId AS CampaignItemId,
    campaign.ItemName AS CampaignCode,
    campaign.Quantity AS CampaignQuantity,
    campaign.TotalPrice AS CampaignTotalPrice,
    campaign.FromDate AS CampaignFromDate,
    campaign.ToDate AS CampaignToDate,
    campaign.CreatedAt AS CampaignCreatedAt,
    campaign.UpdatedAt AS CampaignUpdatedAt,
    campaign.KeyType AS CampaignKeyType,
    campaign.KeyValue AS CampaignKeyValue,
    campaign.Deleted AS CampaignDeleted,

    totals.BookingPositiveValue,
    totals.BookingNegativeValue,
    totals.BookingNetValue,
    totals.AccountingRows
FROM dbo.Booking AS b
INNER JOIN dbo.AccountingItem AS campaign
    ON campaign.KeyType = 'B'
   AND campaign.KeyValue = b.BookingId
   AND campaign.ItemId IN ('Coupon', 'CouponBo')
   AND campaign.ItemName = 'Black30'
LEFT JOIN dbo.BookingStatus AS bs
    ON bs.BookingStatusId = b.BookingStatusId
LEFT JOIN dbo.BookingItem AS bi
    ON bi.BookingItemId = b.BookingItemId
LEFT JOIN dbo.BookingItemType AS bit
    ON bit.BookingItemTypeId = bi.BookingItemTypeId
OUTER APPLY (
    SELECT
        SUM(CASE WHEN ai.TotalPrice > 0 THEN ai.TotalPrice ELSE 0 END) AS BookingPositiveValue,
        SUM(CASE WHEN ai.TotalPrice < 0 THEN ai.TotalPrice ELSE 0 END) AS BookingNegativeValue,
        SUM(ISNULL(ai.TotalPrice, 0)) AS BookingNetValue,
        COUNT(*) AS AccountingRows
    FROM dbo.AccountingItem AS ai
    WHERE
        ai.KeyType = 'B'
        AND ai.KeyValue = b.BookingId
        AND ISNULL(ai.Deleted, 0) = 0
) AS totals
WHERE
    b.OrderId IS NULL
    AND ISNULL(b.Deleted, 0) = 0
    AND ISNULL(campaign.Deleted, 0) = 0
ORDER BY
    b.FromDate,
    b.BookingId;

-- Vill du se alla ekonomirader på samma tre bokningar, kör även denna:

SELECT
    b.BookingId,
    b.OrderId AS BookingOrderId,
    b.FromDate AS BookingFromDate,
    b.ToDate AS BookingToDate,
    ai.AccountingItemId,
    ai.OrderId AS AccountingOrderId,
    ai.ItemId,
    ai.ItemName,
    ai.Quantity,
    ai.TotalPrice,
    ai.FromDate AS AccountingFromDate,
    ai.ToDate AS AccountingToDate,
    ai.CreatedAt AS AccountingCreatedAt,
    ai.UpdatedAt AS AccountingUpdatedAt,
    ai.KeyType,
    ai.KeyValue,
    ai.Deleted
FROM dbo.Booking AS b
INNER JOIN dbo.AccountingItem AS campaign
    ON campaign.KeyType = 'B'
   AND campaign.KeyValue = b.BookingId
   AND campaign.ItemId IN ('Coupon', 'CouponBo')
   AND campaign.ItemName = 'Black30'
INNER JOIN dbo.AccountingItem AS ai
    ON ai.KeyType = 'B'
   AND ai.KeyValue = b.BookingId
WHERE
    b.OrderId IS NULL
    AND ISNULL(b.Deleted, 0) = 0
    AND ISNULL(campaign.Deleted, 0) = 0
    AND ISNULL(ai.Deleted, 0) = 0
ORDER BY
    b.BookingId,
    ai.TotalPrice DESC,
    ai.AccountingItemId;
