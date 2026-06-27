raise SystemExit


db = sqlite3.connect("CS-Statistik.db")
db.row_factory = sqlite3.Row


def show(title, sql):
    print(f"\n## {title}")
    rows = db.execute(sql).fetchall()
    for row in rows:
        print(dict(row))
    print("rows:", len(rows))


show("current campaign rows", """
SELECT KeyType, ItemId, ItemName, COUNT(*) AS Rows,
       COUNT(DISTINCT KeyValue) AS DistinctKeys,
       ROUND(SUM(TotalPrice), 2) AS Amount
FROM AccountingItem
WHERE COALESCE(Deleted, 0) = 0
  AND (UPPER(TRIM(ItemId)) IN ('COUPON', 'COUPONBO')
       OR UPPER(TRIM(ItemName)) LIKE '%KANONDEAL%')
GROUP BY KeyType, ItemId, ItemName
ORDER BY Rows DESC
""")

show("all nonpayment negative booking/invoice candidates", """
SELECT ai.KeyType, ai.ItemId, ai.ItemName, i.IsPayment,
       COUNT(*) AS Rows, COUNT(DISTINCT ai.KeyValue) AS DistinctKeys,
       ROUND(SUM(ai.TotalPrice), 2) AS Amount
FROM AccountingItem ai
LEFT JOIN Item i ON i.ItemId = ai.ItemId
WHERE COALESCE(ai.Deleted, 0) = 0
  AND ai.KeyType IN ('B', 'F')
  AND COALESCE(ai.TotalPrice, 0) < 0
  AND COALESCE(i.IsPayment, 0) = 0
GROUP BY ai.KeyType, ai.ItemId, ai.ItemName, i.IsPayment
ORDER BY Rows DESC
LIMIT 100
""")

show("current-filter attrition", """
WITH candidates AS (
  SELECT ai.*,
         CASE WHEN ai.KeyType='B' THEN ai.KeyValue
              WHEN ai.KeyType='F' THEN ii.BookingId END AS LinkedBookingId
  FROM AccountingItem ai
  LEFT JOIN (
    SELECT DISTINCT InvoiceId, BookingId FROM InvoiceItem
    WHERE COALESCE(Deleted,0)=0 AND InvoiceId IS NOT NULL AND BookingId IS NOT NULL
  ) ii ON ai.KeyType='F' AND ai.KeyValue=ii.InvoiceId
  WHERE COALESCE(ai.Deleted,0)=0
    AND (UPPER(TRIM(ai.ItemId)) IN ('COUPON','COUPONBO')
         OR UPPER(TRIM(ai.ItemName)) LIKE '%KANONDEAL%')
)
SELECT KeyType,
       COUNT(*) AS CandidateRows,
       SUM(LinkedBookingId IS NULL) AS NoBookingLink,
       SUM(LinkedBookingId IS NOT NULL AND b.BookingId IS NULL) AS MissingBooking,
       SUM(LinkedBookingId IS NOT NULL AND b.BookingId IS NOT NULL AND COALESCE(b.Deleted,0)<>0) AS DeletedBooking,
       SUM(LinkedBookingId IS NOT NULL AND b.BookingId IS NOT NULL AND COALESCE(b.Deleted,0)=0) AS IncludedRows,
       COUNT(DISTINCT CASE WHEN b.BookingId IS NOT NULL AND COALESCE(b.Deleted,0)=0 THEN b.BookingId END) AS IncludedBookings
FROM candidates c
LEFT JOIN Booking b ON b.BookingId=c.LinkedBookingId
GROUP BY KeyType
""")

show("invoice-to-multiple-booking ambiguity", """
SELECT ai.KeyValue AS InvoiceId, COUNT(DISTINCT ii.BookingId) AS BookingCount,
       COUNT(*) AS JoinedCampaignRows
FROM AccountingItem ai
JOIN InvoiceItem ii ON ai.KeyType='F' AND ai.KeyValue=ii.InvoiceId
WHERE COALESCE(ai.Deleted,0)=0 AND COALESCE(ii.Deleted,0)=0
  AND (UPPER(TRIM(ai.ItemId)) IN ('COUPON','COUPONBO')
       OR UPPER(TRIM(ai.ItemName)) LIKE '%KANONDEAL%')
GROUP BY ai.KeyValue
HAVING COUNT(DISTINCT ii.BookingId)>1
ORDER BY BookingCount DESC
LIMIT 30
""")

show("attrition by campaign code", """
WITH links AS (
  SELECT DISTINCT InvoiceId, BookingId FROM InvoiceItem
  WHERE COALESCE(Deleted,0)=0 AND InvoiceId IS NOT NULL AND BookingId IS NOT NULL
), candidates AS (
  SELECT ai.ItemName,
         CASE WHEN ai.KeyType='B' THEN ai.KeyValue
              WHEN ai.KeyType='F' THEN links.BookingId END AS LinkedBookingId
  FROM AccountingItem ai
  LEFT JOIN links ON ai.KeyType='F' AND ai.KeyValue=links.InvoiceId
  WHERE COALESCE(ai.Deleted,0)=0 AND ai.KeyType IN ('B','F')
    AND UPPER(TRIM(ai.ItemId)) IN ('COUPON','COUPONBO')
)
SELECT UPPER(TRIM(c.ItemName)) AS CampaignCode,
       COUNT(*) AS CandidateRows,
       SUM(c.LinkedBookingId IS NOT NULL AND b.BookingId IS NOT NULL AND COALESCE(b.Deleted,0)=0) AS IncludedRows,
       SUM(c.LinkedBookingId IS NULL OR b.BookingId IS NULL OR COALESCE(b.Deleted,0)<>0) AS ExcludedRows
FROM candidates c
LEFT JOIN Booking b ON b.BookingId=c.LinkedBookingId
GROUP BY UPPER(TRIM(c.ItemName))
ORDER BY ExcludedRows DESC, CandidateRows DESC
""")

show("status of invoice-linked bookings", """
WITH invoice_campaign_bookings AS (
  SELECT DISTINCT ii.BookingId
  FROM AccountingItem ai
  JOIN InvoiceItem ii ON ai.KeyType='F' AND ai.KeyValue=ii.InvoiceId
  WHERE COALESCE(ai.Deleted,0)=0 AND COALESCE(ii.Deleted,0)=0
    AND UPPER(TRIM(ai.ItemId)) IN ('COUPON','COUPONBO')
)
SELECT CASE WHEN b.BookingId IS NULL THEN 'MISSING' ELSE CAST(COALESCE(b.Deleted,0) AS TEXT) END AS DeletedState,
       b.BookingImportStatus, b.BookingStatusId, COUNT(*) AS Bookings
FROM invoice_campaign_bookings icb
LEFT JOIN Booking b ON b.BookingId=icb.BookingId
GROUP BY CASE WHEN b.BookingId IS NULL THEN 'MISSING' ELSE CAST(COALESCE(b.Deleted,0) AS TEXT) END,
         b.BookingImportStatus, b.BookingStatusId
ORDER BY Bookings DESC
""")
