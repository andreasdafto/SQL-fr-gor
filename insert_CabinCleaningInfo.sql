SET XACT_ABORT ON;
BEGIN TRAN;

MERGE dbo.CabinCleaningInfo AS target
USING (VALUES
    (809, N'Julbord Lördag', 0, 0, CAST(0 AS decimal(4,1))),
    (1, N'Campingtomt M Söderviken', 0, 0, CAST(0 AS decimal(4,1))),
    (3, N'Campingtomt L Höglandet', 0, 0, CAST(0 AS decimal(4,1))),
    (803, N'Räktrålning', 0, 0, CAST(0 AS decimal(4,1))),
    (12, N'Tälttomt Norrviken', 0, 0, CAST(0 AS decimal(4,1))),
    (52, N'Båtplats hyr ej ut', 0, 0, CAST(0 AS decimal(4,1))),
    (55, N'Säsongstomt kategori 1', 0, 0, CAST(0 AS decimal(4,1))),
    (18, N'Tälttomt extra', 0, 0, CAST(0 AS decimal(4,1))),
    (20, N'Stuga Döskallebyn 4 pers', 0, 15, CAST(5.0 AS decimal(4,1))),
    (22, N'Stuga Vrakbyn 4 pers', 0, 15, CAST(5.0 AS decimal(4,1))),
    (26, N'Stuga Krutbyn 4 pers', 4, 30, CAST(5.0 AS decimal(4,1))),
    (28, N'Stuga Saltbyn 4 pers', 4, 30, CAST(5.0 AS decimal(4,1))),
    (30, N'Stuga Sjölia 4 pers', 4, 60, CAST(5.0 AS decimal(4,1))),
    (32, N'Stuga Skeppsbyn 4 pers', 4, 60, CAST(5.0 AS decimal(4,1))),
    (34, N'Stuga Piratbyn 4 pers', 4, 60, CAST(5.0 AS decimal(4,1))),
    (36, N'Stuga Piratbyn 6 pers', 6, 70, CAST(5.0 AS decimal(4,1))),
    (38, N'Stuga Solhöjden 6 pers', 6, 70, CAST(5.0 AS decimal(4,1))),
    (40, N'Stuga Kaptensbyn 8 pers', 8, 90, CAST(5.0 AS decimal(4,1))),
    (50, N'Båtplats säsong/stor', 0, 0, CAST(0 AS decimal(4,1))),
    (51, N'Båtplats säsong/liten', 0, 0, CAST(0 AS decimal(4,1))),
    (100, N'Wellness/bastu/grill', 0, 0, CAST(0 AS decimal(4,1))),
    (110, N'Båtar', 0, 0, CAST(0 AS decimal(4,1))),
    (112, N'Cykel', 0, 0, CAST(0 AS decimal(4,1))),
    (15, N'Tälttomt unik', 0, 0, CAST(0 AS decimal(4,1))),
    (101, N'Lokaler', 0, 0, CAST(0 AS decimal(4,1))),
    (801, N'Skattkammarön', 0, 0, CAST(0 AS decimal(4,1))),
    (13, N'Tälttomt Mittlandet', 0, 0, CAST(0 AS decimal(4,1))),
    (800, N'Packhuset', 0, 0, CAST(0 AS decimal(4,1))),
    (999, N'Skygge', 0, 0, CAST(0 AS decimal(4,1))),
    (802, N'Koster båttur', 0, 0, CAST(0 AS decimal(4,1))),
    (804, N'Sälsafari', 0, 0, CAST(0 AS decimal(4,1))),
    (805, N'Smuggeltur', 0, 0, CAST(0 AS decimal(4,1))),
    (850, N'Event', 0, 0, CAST(0 AS decimal(4,1))),
    (806, N'Frukost', 0, 0, CAST(0 AS decimal(4,1))),
    (111, N'Grillar', 0, 0, CAST(0 AS decimal(4,1))),
    (49, N'Gästhamn', 0, 0, CAST(0 AS decimal(4,1))),
    (14, N'Tälttomt M Söderviken', 0, 0, CAST(0 AS decimal(4,1))),
    (48, N'Personalbostäder', 0, 0, CAST(0 AS decimal(4,1))),
    (19, N'Stuga Döskallebyn 2 pers ny', 0, 15, CAST(5.0 AS decimal(4,1))),
    (8, N'Camping/Husbilstomt XL Höglandet', 0, 0, CAST(0 AS decimal(4,1))),
    (808, N'Julbord Fredag', 0, 0, CAST(0 AS decimal(4,1))),
    (7, N'Camping/Husbilstomt L Höglandet', 0, 0, CAST(0 AS decimal(4,1))),
    (200, N'Present kort', 0, 0, CAST(0 AS decimal(4,1))),
    (115, N'Scen', 0, 0, CAST(0 AS decimal(4,1))),
    (43, N'Stuga unik 4 pers', 0, 50, CAST(5.0 AS decimal(4,1))),
    (120, N'Padeltennis', 0, 0, CAST(0 AS decimal(4,1))),
    (2, N'Campingtomt M Mittlandet', 0, 0, CAST(0 AS decimal(4,1))),
    (810, N'Julbord Familj', 0, 0, CAST(0 AS decimal(4,1))),
    (811, N'Packhuset 200pers', 0, 0, CAST(0 AS decimal(4,1))),
    (812, N'Packhuset 170pers', 0, 0, CAST(0 AS decimal(4,1))),
    (4, N'Campingtomt M Norrviken', 0, 0, CAST(0 AS decimal(4,1))),
    (56, N'Säsongstomt kategori 2', 0, 0, CAST(0 AS decimal(4,1))),
    (57, N'Säsongstomt kategori 3', 0, 0, CAST(0 AS decimal(4,1))),
    (5, N'Husbilstomt M Norrviken', 0, 0, CAST(0 AS decimal(4,1))),
    (9, N'Husbilstomt L Norrviken', 0, 0, CAST(0 AS decimal(4,1))),
    (11, N'Tälttomt Söderviken', 0, 0, CAST(0 AS decimal(4,1))),
    (16, N'Campingtomt unik', 0, 0, CAST(0 AS decimal(4,1))),
    (41, N'Kaparvillan 8 pers', 8, 140, CAST(5.0 AS decimal(4,1))),
    (59, N'Säsongstomt Borttagen', 0, 0, CAST(0 AS decimal(4,1))),
    (17, N'Husbilstomt unik', 0, 0, CAST(0 AS decimal(4,1))),
    (6, N'Camping/Husbilstomt M Norrviken', 0, 0, CAST(0 AS decimal(4,1))),
    (10, N'Husbilstomt L Höglandet', 0, 0, CAST(0 AS decimal(4,1))),
    (60, N'Campingtomt används ej', 0, 0, CAST(0 AS decimal(4,1))),
    (130, N'DAFTÖKAMPEN', 0, 0, CAST(0 AS decimal(4,1))),
    (750, N'Bistro', 0, 0, CAST(0 AS decimal(4,1))),
    (54, N'Säsongstomt kategori A', 0, 0, CAST(0 AS decimal(4,1))),
    (80, N'Markarrende', 0, 0, CAST(0 AS decimal(4,1))),
    (46, N'Hotellet', 4, 50, CAST(5.0 AS decimal(4,1))),
    (45, N'Villan 6 pers', 0, 50, CAST(5.0 AS decimal(4,1))),
    (44, N'Stuga unik 4 pers/2 sovrum', 0, 50, CAST(5.0 AS decimal(4,1)))
) AS source (BookingItemTypeId, Description, BedsToMake, CleaningMinutes, CleaningWindowHours)
ON target.BookingItemTypeId = source.BookingItemTypeId
WHEN MATCHED THEN
    UPDATE SET
        Description = source.Description,
        BedsToMake = source.BedsToMake,
        CleaningMinutes = source.CleaningMinutes,
        CleaningWindowHours = source.CleaningWindowHours
WHEN NOT MATCHED BY TARGET THEN
    INSERT (BookingItemTypeId, Description, BedsToMake, CleaningMinutes, CleaningWindowHours)
    VALUES (source.BookingItemTypeId, source.Description, source.BedsToMake, source.CleaningMinutes, source.CleaningWindowHours);

COMMIT;

SELECT COUNT(*) AS CabinCleaningInfoRows FROM dbo.CabinCleaningInfo;

