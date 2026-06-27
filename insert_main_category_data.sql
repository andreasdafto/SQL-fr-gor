SET XACT_ABORT ON;
BEGIN TRAN;

MERGE dbo.MainCategory AS target
USING (VALUES
    (1, N'Camping'),
    (2, N'Stugor'),
    (3, N'Husbil'),
    (4, N'Hotell'),
    (5, N'Gästhamn'),
    (6, N'Biljetter'),
    (7, N'Grillar')
) AS source (MainCategoryId, MainCategoryName)
ON target.MainCategoryId = source.MainCategoryId
WHEN MATCHED THEN
    UPDATE SET MainCategoryName = source.MainCategoryName
WHEN NOT MATCHED BY TARGET THEN
    INSERT (MainCategoryId, MainCategoryName)
    VALUES (source.MainCategoryId, source.MainCategoryName);

MERGE dbo.MainCategoryMapping AS target
USING (VALUES
    (1, 1, 1),
    (2, 1, 2),
    (3, 1, 3),
    (4, 1, 4),
    (5, 3, 5),
    (6, 1, 6),
    (7, 1, 7),
    (8, 1, 8),
    (9, 3, 9),
    (10, 3, 10),
    (11, 1, 11),
    (12, 1, 12),
    (13, 1, 13),
    (14, 1, 14),
    (15, 1, 15),
    (16, 1, 16),
    (17, 3, 17),
    (18, 1, 18),
    (19, 2, 19),
    (20, 2, 20),
    (21, 2, 22),
    (22, 2, 26),
    (23, 2, 28),
    (24, 2, 30),
    (25, 2, 32),
    (26, 2, 34),
    (27, 2, 36),
    (28, 2, 38),
    (29, 2, 40),
    (30, 2, 41),
    (31, 2, 43),
    (32, 2, 44),
    (33, 2, 45),
    (34, 4, 46),
    (35, 5, 49),
    (36, 6, 999),
    (37, 7, 111)
) AS source (MainCategoryMappingId, MainCategoryId, UnitCategoryId)
ON target.MainCategoryMappingId = source.MainCategoryMappingId
WHEN MATCHED THEN
    UPDATE SET
        MainCategoryId = source.MainCategoryId,
        UnitCategoryId = source.UnitCategoryId
WHEN NOT MATCHED BY TARGET THEN
    INSERT (MainCategoryMappingId, MainCategoryId, UnitCategoryId)
    VALUES (source.MainCategoryMappingId, source.MainCategoryId, source.UnitCategoryId);

COMMIT;

SELECT COUNT(*) AS MainCategoryRows FROM dbo.MainCategory;
SELECT COUNT(*) AS MainCategoryMappingRows FROM dbo.MainCategoryMapping;
