-- Shows AccountingItem rows connected to one booking.
-- Change @BookingId when you want to inspect another booking.

DECLARE @BookingId int;
SET @BookingId = 1379742;

SELECT
    b.BookingId,
    b.OrderId AS BookingOrderId,
    b.CustomerId,
    b.BookingItemId,
    bi.Description AS BookingItemDescription,
    bi.BookingItemTypeId,
    bit.Description AS BookingItemTypeDescription,
    CAST(b.FromDate AS date) AS ArrivalDate,
    CAST(b.ToDate AS date) AS DepartureDate,
    DATEDIFF(day, CAST(b.FromDate AS date), CAST(b.ToDate AS date)) AS Nights,
    b.CreatedAt,
    b.UpdatedAt,
    b.Ordersource,
    b.SubOrdersource,
    b.BookingStatusId,
    CASE
        WHEN b.BookingStatusId IS NULL OR TRIM(b.BookingStatusId) = '' THEN N'Ej flyttbar'
        ELSE bs.Description
    END AS BookingStatusDescription,
    b.BookingImportStatus,
    b.Deleted AS BookingDeleted
FROM dbo.Booking AS b
LEFT JOIN dbo.BookingStatus AS bs
    ON bs.BookingStatusId = b.BookingStatusId
LEFT JOIN dbo.BookingItem AS bi
    ON bi.BookingItemId = b.BookingItemId
LEFT JOIN dbo.BookingItemType AS bit
    ON bit.BookingItemTypeId = bi.BookingItemTypeId
WHERE
    b.BookingId = @BookingId;

SELECT DISTINCT
    ii.InvoiceId,
    ii.BookingId,
    ii.CustomerId,
    ii.GroupId,
    ii.InvoiceDate,
    ii.InvoiceAmount,
    ii.TotalTurnover,
    ii.PayedAmount,
    ii.EqualizedAmount,
    ii.DueDate,
    ii.Status,
    ii.OrderId AS InvoiceOrderId,
    ii.Ordersource,
    ii.SubOrdersource,
    ii.Deleted AS InvoiceItemDeleted
FROM dbo.InvoiceItem AS ii
WHERE
    ii.BookingId = @BookingId
ORDER BY
    ii.InvoiceDate,
    ii.InvoiceId;

WITH LinkedAccountingItems AS (
    SELECT
        ai.*,
        CAST(N'Direct booking row: KeyType B + KeyValue = BookingId' AS nvarchar(100)) AS LinkReason,
        CAST(NULL AS int) AS LinkedInvoiceId
    FROM dbo.AccountingItem AS ai
    WHERE
        ai.KeyType = 'B'
        AND ai.KeyValue = @BookingId

    UNION ALL

    SELECT
        ai.*,
        CAST(N'Invoice row: KeyType F + KeyValue = InvoiceItem.InvoiceId' AS nvarchar(100)) AS LinkReason,
        ii.InvoiceId AS LinkedInvoiceId
    FROM dbo.AccountingItem AS ai
    INNER JOIN (
        SELECT DISTINCT InvoiceId
        FROM dbo.InvoiceItem
        WHERE
            BookingId = @BookingId
            AND InvoiceId IS NOT NULL
    ) AS ii
        ON ai.KeyType = 'F'
       AND ai.KeyValue = ii.InvoiceId
)
SELECT
    LinkReason,
    LinkedInvoiceId,
    AccountingItemId,
    OrderId AS AccountingOrderId,
    lai.ItemId,
    item.ItemName AS ArticleItemName,
    lai.ItemName AS AccountingItemName,
    Quantity,
    TotalPrice,
    ISNULL(TotalPrice, 0) - ISNULL(Quantity, 0) AS AmountMinusQuantity,
    ABS(ISNULL(TotalPrice, 0)) - ABS(ISNULL(Quantity, 0)) AS AbsAmountMinusAbsQuantity,
    CASE
        WHEN ISNULL(Quantity, 0) = ISNULL(TotalPrice, 0) THEN N'Quantity = TotalPrice'
        WHEN ABS(ISNULL(Quantity, 0)) = ABS(ISNULL(TotalPrice, 0)) THEN N'Same amount, opposite sign'
        ELSE N'Quantity differs from TotalPrice'
    END AS QuantityAmountCheck,
    CASE
        WHEN ISNULL(Quantity, 0) = 0 AND ISNULL(TotalPrice, 0) = 0 THEN N'Both zero'
        WHEN SIGN(ISNULL(Quantity, 0)) = SIGN(ISNULL(TotalPrice, 0)) THEN N'Same sign'
        ELSE N'Opposite sign'
    END AS QuantityAmountSignCheck,
    lai.CustomerId,
    lai.FromDate,
    lai.ToDate,
    lai.FromValue,
    lai.ToValue,
    lai.KeyType,
    lai.KeyValue,
    lai.SiteId,
    lai.Deleted,
    lai.CreatedAt,
    lai.UpdatedAt,
    lai.ImportFirstSeenAt,
    lai.ImportUpdatedAt,
    lai.ImportSourceDate
FROM LinkedAccountingItems AS lai
LEFT JOIN dbo.Item AS item
    ON item.ItemId = lai.ItemId
ORDER BY
    CASE WHEN lai.TotalPrice > 0 THEN 0 ELSE 1 END,
    lai.FromDate,
    lai.ItemId,
    lai.AccountingItemId;

WITH LinkedAccountingItems AS (
    SELECT
        ai.*
    FROM dbo.AccountingItem AS ai
    WHERE
        ai.KeyType = 'B'
        AND ai.KeyValue = @BookingId

    UNION ALL

    SELECT
        ai.*
    FROM dbo.AccountingItem AS ai
    INNER JOIN (
        SELECT DISTINCT InvoiceId
        FROM dbo.InvoiceItem
        WHERE
            BookingId = @BookingId
            AND InvoiceId IS NOT NULL
    ) AS ii
        ON ai.KeyType = 'F'
       AND ai.KeyValue = ii.InvoiceId
)
SELECT
    COUNT(*) AS AccountingRows,
    SUM(CASE WHEN ISNULL(TotalPrice, 0) > 0 THEN ISNULL(TotalPrice, 0) ELSE 0 END) AS PositiveTotalPrice,
    SUM(CASE WHEN ISNULL(TotalPrice, 0) < 0 THEN ISNULL(TotalPrice, 0) ELSE 0 END) AS NegativeTotalPrice,
    SUM(ISNULL(TotalPrice, 0)) AS NetTotalPrice,
    SUM(ISNULL(Quantity, 0)) AS QuantityTotal,
    SUM(ISNULL(TotalPrice, 0)) - SUM(ISNULL(Quantity, 0)) AS AmountMinusQuantityTotal,
    SUM(ABS(ISNULL(TotalPrice, 0))) - SUM(ABS(ISNULL(Quantity, 0))) AS AbsAmountMinusAbsQuantityTotal
FROM LinkedAccountingItems;

WITH LinkedAccountingItems AS (
    SELECT
        ai.*
    FROM dbo.AccountingItem AS ai
    WHERE
        ai.KeyType = 'B'
        AND ai.KeyValue = @BookingId

    UNION ALL

    SELECT
        ai.*
    FROM dbo.AccountingItem AS ai
    INNER JOIN (
        SELECT DISTINCT InvoiceId
        FROM dbo.InvoiceItem
        WHERE
            BookingId = @BookingId
            AND InvoiceId IS NOT NULL
    ) AS ii
        ON ai.KeyType = 'F'
       AND ai.KeyValue = ii.InvoiceId
)
SELECT
    lai.ItemId,
    item.ItemName AS ArticleItemName,
    lai.ItemName AS AccountingItemName,
    COUNT(*) AS Rows,
    SUM(ISNULL(lai.Quantity, 0)) AS QuantityTotal,
    SUM(ISNULL(lai.TotalPrice, 0)) AS AmountTotal,
    SUM(ISNULL(lai.TotalPrice, 0)) - SUM(ISNULL(lai.Quantity, 0)) AS AmountMinusQuantity,
    SUM(ABS(ISNULL(lai.TotalPrice, 0))) - SUM(ABS(ISNULL(lai.Quantity, 0))) AS AbsAmountMinusAbsQuantity
FROM LinkedAccountingItems AS lai
LEFT JOIN dbo.Item AS item
    ON item.ItemId = lai.ItemId
GROUP BY
    lai.ItemId,
    item.ItemName,
    lai.ItemName
ORDER BY
    AmountTotal DESC,
    lai.ItemId,
    lai.ItemName;
