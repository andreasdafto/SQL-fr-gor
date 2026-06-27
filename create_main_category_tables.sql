CREATE TABLE dbo.MainCategory (
    MainCategoryId int NOT NULL PRIMARY KEY,
    MainCategoryName nvarchar(100) NOT NULL
);

CREATE TABLE dbo.MainCategoryMapping (
    MainCategoryMappingId int NOT NULL PRIMARY KEY,
    MainCategoryId int NOT NULL,
    UnitCategoryId int NOT NULL,
    CONSTRAINT FK_MainCategoryMapping_MainCategory
        FOREIGN KEY (MainCategoryId)
        REFERENCES dbo.MainCategory (MainCategoryId)
);
