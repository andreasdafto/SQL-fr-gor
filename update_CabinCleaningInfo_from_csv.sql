SET XACT_ABORT ON;
GO

IF COL_LENGTH(N'dbo.CabinCleaningInfo', N'CleaningMinutesHK') IS NULL
BEGIN
    ALTER TABLE dbo.CabinCleaningInfo ADD [CleaningMinutesHK] int NULL;
END;
GO

BEGIN TRAN;

MERGE dbo.CabinCleaningInfo AS target
USING (VALUES
    (1, N'Campingtomt M Söderviken', 0, 0, CAST(0 AS decimal(4,1)), 0),
    (2, N'Campingtomt M Mittlandet', 0, 0, CAST(0 AS decimal(4,1)), 0),
    (3, N'Campingtomt L Höglandet', 0, 0, CAST(0 AS decimal(4,1)), 0),
    (4, N'Campingtomt M Norrviken', 0, 0, CAST(0 AS decimal(4,1)), 0),
    (5, N'Husbilstomt M Norrviken', 0, 0, CAST(0 AS decimal(4,1)), 0),
    (6, N'Camping/Husbilstomt M Norrviken', 0, 0, CAST(0 AS decimal(4,1)), 0),
    (7, N'Camping/Husbilstomt L Höglandet', 0, 0, CAST(0 AS decimal(4,1)), 0),
    (8, N'Camping/Husbilstomt XL Höglandet', 0, 0, CAST(0 AS decimal(4,1)), 0),
    (9, N'Husbilstomt L Norrviken', 0, 0, CAST(0 AS decimal(4,1)), 0),
    (10, N'Husbilstomt L Höglandet', 0, 0, CAST(0 AS decimal(4,1)), 0),
    (11, N'Tälttomt Söderviken', 0, 0, CAST(0 AS decimal(4,1)), 0),
    (12, N'Tälttomt Norrviken', 0, 0, CAST(0 AS decimal(4,1)), 0),
    (13, N'Tälttomt Mittlandet', 0, 0, CAST(0 AS decimal(4,1)), 0),
    (14, N'Tälttomt M Söderviken', 0, 0, CAST(0 AS decimal(4,1)), 0),
    (15, N'Tälttomt unik', 0, 0, CAST(0 AS decimal(4,1)), 0),
    (16, N'Campingtomt unik', 0, 0, CAST(0 AS decimal(4,1)), 0),
    (17, N'Husbilstomt unik', 0, 0, CAST(0 AS decimal(4,1)), 0),
    (18, N'Tälttomt extra', 0, 0, CAST(0 AS decimal(4,1)), 0),
    (19, N'Stuga Döskallebyn 2 pers ny', 0, 15, CAST(5.0 AS decimal(4,1)), 15),
    (20, N'Stuga Döskallebyn 4 pers', 0, 15, CAST(5.0 AS decimal(4,1)), 15),
    (22, N'Stuga Vrakbyn 4 pers', 0, 15, CAST(5.0 AS decimal(4,1)), 59),
    (26, N'Stuga Krutbyn 4 pers', 4, 30, CAST(5.0 AS decimal(4,1)), 59),
    (28, N'Stuga Saltbyn 4 pers', 4, 30, CAST(5.0 AS decimal(4,1)), 59),
    (30, N'Stuga Sjölia 4 pers', 4, 60, CAST(5.0 AS decimal(4,1)), 59),
    (32, N'Stuga Skeppsbyn 4 pers', 4, 60, CAST(5.0 AS decimal(4,1)), 59),
    (34, N'Stuga Piratbyn 4 pers', 4, 60, CAST(5.0 AS decimal(4,1)), 59),
    (36, N'Stuga Piratbyn 6 pers', 6, 70, CAST(5.0 AS decimal(4,1)), 69),
    (38, N'Stuga Solhöjden 6 pers', 6, 70, CAST(5.0 AS decimal(4,1)), 69),
    (40, N'Stuga Kaptensbyn 8 pers', 8, 90, CAST(5.0 AS decimal(4,1)), 79),
    (41, N'Kaparvillan 8 pers', 8, 140, CAST(5.0 AS decimal(4,1)), 120),
    (43, N'Stuga unik 4 pers', 4, 50, CAST(5.0 AS decimal(4,1)), 59),
    (44, N'Stuga unik 4 pers/2 sovrum', 4, 50, CAST(5.0 AS decimal(4,1)), 59),
    (45, N'Villan 6 pers', 0, 50, CAST(5.0 AS decimal(4,1)), 69),
    (46, N'Hotellet', 4, 50, CAST(5.0 AS decimal(4,1)), 59),
    (48, N'Personalbostäder', 0, 0, CAST(0 AS decimal(4,1)), 0),
    (49, N'Gästhamn', 0, 0, CAST(0 AS decimal(4,1)), 0),
    (50, N'Båtplats säsong/stor', 0, 0, CAST(0 AS decimal(4,1)), 0),
    (51, N'Båtplats säsong/liten', 0, 0, CAST(0 AS decimal(4,1)), 0),
    (52, N'Båtplats hyr ej ut', 0, 0, CAST(0 AS decimal(4,1)), 0),
    (54, N'Säsongstomt kategori A', 0, 0, CAST(0 AS decimal(4,1)), 0),
    (55, N'Säsongstomt kategori 1', 0, 0, CAST(0 AS decimal(4,1)), 0),
    (56, N'Säsongstomt kategori 2', 0, 0, CAST(0 AS decimal(4,1)), 0),
    (57, N'Säsongstomt kategori 3', 0, 0, CAST(0 AS decimal(4,1)), 0),
    (59, N'Säsongstomt Borttagen', 0, 0, CAST(0 AS decimal(4,1)), 0),
    (60, N'Campingtomt används ej', 0, 0, CAST(0 AS decimal(4,1)), 0),
    (80, N'Markarrende', 0, 0, CAST(0 AS decimal(4,1)), 0),
    (100, N'Wellness/bastu/grill', 0, 0, CAST(0 AS decimal(4,1)), 0),
    (101, N'Lokaler', 0, 0, CAST(0 AS decimal(4,1)), 0),
    (110, N'Båtar', 0, 0, CAST(0 AS decimal(4,1)), 0),
    (111, N'Grillar', 0, 0, CAST(0 AS decimal(4,1)), 0),
    (112, N'Cykel', 0, 0, CAST(0 AS decimal(4,1)), 0),
    (115, N'Scen', 0, 0, CAST(0 AS decimal(4,1)), 0),
    (120, N'Padeltennis', 0, 0, CAST(0 AS decimal(4,1)), 0),
    (130, N'DAFTÖKAMPEN', 0, 0, CAST(0 AS decimal(4,1)), 0),
    (200, N'Present kort', 0, 0, CAST(0 AS decimal(4,1)), 0),
    (750, N'Bistro', 0, 0, CAST(0 AS decimal(4,1)), 0),
    (800, N'Packhuset', 0, 0, CAST(0 AS decimal(4,1)), 0),
    (801, N'Skattkammarön', 0, 0, CAST(0 AS decimal(4,1)), 0),
    (802, N'Koster båttur', 0, 0, CAST(0 AS decimal(4,1)), 0),
    (803, N'Räktrålning', 0, 0, CAST(0 AS decimal(4,1)), 0),
    (804, N'Sälsafari', 0, 0, CAST(0 AS decimal(4,1)), 0),
    (805, N'Smuggeltur', 0, 0, CAST(0 AS decimal(4,1)), 0),
    (806, N'Frukost', 0, 0, CAST(0 AS decimal(4,1)), 0),
    (808, N'Julbord Fredag', 0, 0, CAST(0 AS decimal(4,1)), 0),
    (809, N'Julbord Lördag', 0, 0, CAST(0 AS decimal(4,1)), 0),
    (810, N'Julbord Familj', 0, 0, CAST(0 AS decimal(4,1)), 0),
    (811, N'Packhuset 200pers', 0, 0, CAST(0 AS decimal(4,1)), 0),
    (812, N'Packhuset 170pers', 0, 0, CAST(0 AS decimal(4,1)), 0),
    (850, N'Event', 0, 0, CAST(0 AS decimal(4,1)), 0),
    (999, N'Skygge', 0, 0, CAST(0 AS decimal(4,1)), 0)
) AS source ([BookingItemTypeId], [Description], [BedsToMake], [CleaningMinutes], [CleaningWindowHours], [CleaningMinutesHK])
ON target.[BookingItemTypeId] = source.[BookingItemTypeId]
WHEN MATCHED THEN
    UPDATE SET
        target.[Description] = source.[Description],
        target.[BedsToMake] = source.[BedsToMake],
        target.[CleaningMinutes] = source.[CleaningMinutes],
        target.[CleaningWindowHours] = source.[CleaningWindowHours],
        target.[CleaningMinutesHK] = source.[CleaningMinutesHK]
WHEN NOT MATCHED BY TARGET THEN
    INSERT ([BookingItemTypeId], [Description], [BedsToMake], [CleaningMinutes], [CleaningWindowHours], [CleaningMinutesHK])
    VALUES (source.[BookingItemTypeId], source.[Description], source.[BedsToMake], source.[CleaningMinutes], source.[CleaningWindowHours], source.[CleaningMinutesHK]);

COMMIT;

SELECT COUNT(*) AS CabinCleaningInfoRows FROM dbo.CabinCleaningInfo;
GO
