SELECT *
FROM dbo.Booking
WHERE CreatedAt >= DATEADD(day, -7, GETDATE())
ORDER BY CreatedAt DESC;