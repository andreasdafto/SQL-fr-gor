/*
    Updates dbo.CabinCleaningInfo to match "antal bäddar - correct.csv"
    for the rows that previously differed from "antal bäddar - correct.csv".

    Current values before this update are saved in:
    dbo.CabinCleaningInfoValueBackup

    Previous values before the correct.csv update:
    BookingItemTypeId  Description                 BedsToMake  CleaningMinutes  CleaningWindowHours
    26                 Stuga Krutbyn 4 pers        4           40               5.0
    28                 Stuga Saltbyn 4 pers        4           45               5.0
    30                 Stuga Sjölia 4 pers         4           50               5.0
    32                 Stuga Skeppsbyn 4 pers      4           50               5.0
    34                 Stuga Piratbyn 4 pers       4           50               5.0
    36                 Stuga Piratbyn 6 pers       6           60               5.0
    41                 Kaparvillan 8 pers          8           120              5.0

    New values from "antal bäddar - correct.csv":
    BookingItemTypeId  Description                 BedsToMake  CleaningMinutes  CleaningWindowHours
    26                 Stuga Krutbyn 4 pers        4           30               5.0
    28                 Stuga Saltbyn 4 pers        4           30               5.0
    30                 Stuga Sjölia 4 pers         4           60               5.0
    32                 Stuga Skeppsbyn 4 pers      4           60               5.0
    34                 Stuga Piratbyn 4 pers       4           60               5.0
    36                 Stuga Piratbyn 6 pers       6           70               5.0
    41                 Kaparvillan 8 pers          8           140              5.0
*/

SET XACT_ABORT ON;
BEGIN TRAN;

IF OBJECT_ID(N'dbo.CabinCleaningInfoValueBackup', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.CabinCleaningInfoValueBackup (
        BackupId int IDENTITY(1,1) NOT NULL
            CONSTRAINT PK_CabinCleaningInfoValueBackup PRIMARY KEY,
        BackupLabel nvarchar(100) NOT NULL,
        BackupCreatedAt datetime2(0) NOT NULL
            CONSTRAINT DF_CabinCleaningInfoValueBackup_BackupCreatedAt DEFAULT SYSUTCDATETIME(),
        BookingItemTypeId int NOT NULL,
        Description nvarchar(100) NOT NULL,
        BedsToMake int NOT NULL,
        CleaningMinutes int NOT NULL,
        CleaningWindowHours decimal(4,1) NOT NULL
    );
END;

INSERT INTO dbo.CabinCleaningInfoValueBackup (
    BackupLabel,
    BookingItemTypeId,
    Description,
    BedsToMake,
    CleaningMinutes,
    CleaningWindowHours
)
SELECT
    N'Before update to antal bäddar - correct.csv',
    BookingItemTypeId,
    Description,
    BedsToMake,
    CleaningMinutes,
    CleaningWindowHours
FROM dbo.CabinCleaningInfo
WHERE BookingItemTypeId IN (26, 28, 30, 32, 34, 36, 41);

MERGE dbo.CabinCleaningInfo AS target
USING (VALUES
    (26, N'Stuga Krutbyn 4 pers', 4, 30, CAST(5.0 AS decimal(4,1))),
    (28, N'Stuga Saltbyn 4 pers', 4, 30, CAST(5.0 AS decimal(4,1))),
    (30, N'Stuga Sjölia 4 pers', 4, 60, CAST(5.0 AS decimal(4,1))),
    (32, N'Stuga Skeppsbyn 4 pers', 4, 60, CAST(5.0 AS decimal(4,1))),
    (34, N'Stuga Piratbyn 4 pers', 4, 60, CAST(5.0 AS decimal(4,1))),
    (36, N'Stuga Piratbyn 6 pers', 6, 70, CAST(5.0 AS decimal(4,1))),
    (41, N'Kaparvillan 8 pers', 8, 140, CAST(5.0 AS decimal(4,1)))
) AS source (BookingItemTypeId, Description, BedsToMake, CleaningMinutes, CleaningWindowHours)
ON target.BookingItemTypeId = source.BookingItemTypeId
WHEN MATCHED THEN
    UPDATE SET
        Description = source.Description,
        BedsToMake = source.BedsToMake,
        CleaningMinutes = source.CleaningMinutes,
        CleaningWindowHours = source.CleaningWindowHours;

COMMIT;

SELECT
    BookingItemTypeId,
    Description,
    BedsToMake,
    CleaningMinutes,
    CleaningWindowHours
FROM dbo.CabinCleaningInfo
WHERE BookingItemTypeId IN (26, 28, 30, 32, 34, 36, 41)
ORDER BY BookingItemTypeId;

SELECT TOP (20)
    BackupId,
    BackupLabel,
    BackupCreatedAt,
    BookingItemTypeId,
    Description,
    BedsToMake,
    CleaningMinutes,
    CleaningWindowHours
FROM dbo.CabinCleaningInfoValueBackup
WHERE BookingItemTypeId IN (26, 28, 30, 32, 34, 36, 41)
ORDER BY BackupId DESC;
