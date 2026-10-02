IF DB_ID(N'PowerUpSupplementation') IS NULL
BEGIN
    CREATE DATABASE PowerUpSupplementation;
END
GO

USE PowerUpSupplementation;
GO

IF OBJECT_ID(N'dbo.OrderItems', N'U') IS NOT NULL DROP TABLE dbo.OrderItems;
IF OBJECT_ID(N'dbo.Orders', N'U') IS NOT NULL DROP TABLE dbo.Orders;
IF OBJECT_ID(N'dbo.Products', N'U') IS NOT NULL DROP TABLE dbo.Products;
IF OBJECT_ID(N'dbo.Brands', N'U') IS NOT NULL DROP TABLE dbo.Brands;
IF OBJECT_ID(N'dbo.Categories', N'U') IS NOT NULL DROP TABLE dbo.Categories;
GO

CREATE TABLE dbo.Categories (
    CategoryId INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL UNIQUE,
    IsActive BIT NOT NULL DEFAULT 1
);
GO

CREATE TABLE dbo.Brands (
    BrandId INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(150) NOT NULL UNIQUE,
    IsActive BIT NOT NULL DEFAULT 1
);
GO

CREATE TABLE dbo.Products (
    ProductId INT IDENTITY(1,1) PRIMARY KEY,
    CategoryId INT NOT NULL,
    BrandId INT NOT NULL,
    Name NVARCHAR(250) NOT NULL,
    Presentation NVARCHAR(150) NULL,
    Price DECIMAL(18,2) NOT NULL,
    ImagePath NVARCHAR(500) NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    UpdatedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    CONSTRAINT FK_Products_Categories FOREIGN KEY (CategoryId) REFERENCES dbo.Categories(CategoryId),
    CONSTRAINT FK_Products_Brands FOREIGN KEY (BrandId) REFERENCES dbo.Brands(BrandId),
    CONSTRAINT CK_Products_Price CHECK (Price >= 0)
);
GO

CREATE INDEX IX_Products_CategoryId ON dbo.Products(CategoryId);
CREATE INDEX IX_Products_BrandId ON dbo.Products(BrandId);
GO

CREATE TABLE dbo.Orders (
    OrderId BIGINT IDENTITY(1,1) PRIMARY KEY,
    Status NVARCHAR(40) NOT NULL DEFAULT N'PENDIENTE_INSTAGRAM',
    Total DECIMAL(18,2) NOT NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    CONSTRAINT CK_Orders_Total CHECK (Total >= 0)
);
GO

CREATE TABLE dbo.OrderItems (
    OrderItemId BIGINT IDENTITY(1,1) PRIMARY KEY,
    OrderId BIGINT NOT NULL,
    ProductId INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(18,2) NOT NULL,
    Subtotal AS (Quantity * UnitPrice) PERSISTED,
    CONSTRAINT FK_OrderItems_Orders FOREIGN KEY (OrderId) REFERENCES dbo.Orders(OrderId),
    CONSTRAINT FK_OrderItems_Products FOREIGN KEY (ProductId) REFERENCES dbo.Products(ProductId),
    CONSTRAINT CK_OrderItems_Quantity CHECK (Quantity > 0),
    CONSTRAINT CK_OrderItems_UnitPrice CHECK (UnitPrice >= 0)
);
GO
INSERT INTO dbo.Categories (Name) VALUES
(N'Proteina'),
(N'Creatina'),
(N'Pre-Entreno'),
(N'Vitamina'),
(N'Omega'),
(N'Colágeno'),
(N'Aminoacidos'),
(N'Quemador'),
(N'Precursor');
GO

INSERT INTO dbo.Brands (Name) VALUES
(N'VITANAS'),
(N'GMN'),
(N'NUTRAMERICAN PHARMA'),
(N'PROSCIENCE'),
(N'TNT'),
(N'DYMATIZE'),
(N'ISOPURE'),
(N'MUSCLETECH'),
(N'OPTIMUM NUTRITION'),
(N'IMN'),
(N'Healthy Sports'),
(N'MACROBLENDS'),
(N'FITMAFIA'),
(N'SMARTMUSCLE'),
(N'DRAGON PHARMA'),
(N'INSANE LABZ'),
(N'HEALTHY AMERICA'),
(N'ANGRY SUPPLEMENTS');
GO

INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'100% Whey Elite 2 lb', N'28 servicios', 179000, N'whey_elite.jpg', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Proteina' AND b.Name=N'VITANAS';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'100% Whey Elite 5 lb', N'67 servicios', 385000, N'whey_elite.jpg', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Proteina' AND b.Name=N'VITANAS';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'100% Whey Elite 8 lb ', N'121 servicios', 547000, N'whey_elite.jpg', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Proteina' AND b.Name=N'VITANAS';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Beef Isolate 2 lb', N'28 servicios', 175000, N'Beef_Isolate.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Proteina' AND b.Name=N'VITANAS';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Beef Isolate 5 lb', N'67 servicios', 360000, N'Beef_Isolate.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Proteina' AND b.Name=N'VITANAS';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Isolate Gourmet 2lb ', N'28 servicios', 235000, N'Isolate_Army.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Proteina' AND b.Name=N'VITANAS';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Isolate Gourmet 5lb', N'67 servicios', 475000, N'Isolate_Army.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Proteina' AND b.Name=N'VITANAS';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Titan Beef Mass 2 lb', N'4 servicios', 60000, N'Titan_Beef_Mass.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Proteina' AND b.Name=N'VITANAS';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Titan Beef Mass 5 lb', N'12 servicios', 130000, N'Titan_Beef_Mass.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Proteina' AND b.Name=N'VITANAS';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Titan Beef Mass 10 lb', N'21 servicios', 230000, N'Titan_Beef_Mass.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Proteina' AND b.Name=N'VITANAS';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Be One 2 lb', N'32 servicios', 178000, N'Be_One.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Proteina' AND b.Name=N'GMN';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Be One 3 lb', N'49 servicios', 249000, N'Be_One.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Proteina' AND b.Name=N'GMN';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Mega Gainer 2 lb', N'5 servicios', 74200, N'Mega_gainer_2lb.jpg', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Proteina' AND b.Name=N'GMN';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Mega Gainer 5 lb', N'9 servicios', 74200, N'imagenes/Mega_Gainer_5_lb.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Proteina' AND b.Name=N'GMN';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Megaplex Creatine Power 10 lb ', N'17 Servicios', 284990, N'imagenes/Megaplex_Creatine.jpg', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Proteina' AND b.Name=N'NUTRAMERICAN PHARMA';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Megaplex Creatine Power 2.3 lb', N'4 Servicios', 74990, N'imagenes/Megaplex_Creatine_23.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Proteina' AND b.Name=N'NUTRAMERICAN PHARMA';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Biprotein Classic 2 lb ', N'35 Servicios', 249000, N'imagenes/Biprotein_Classic.jpg', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Proteina' AND b.Name=N'NUTRAMERICAN PHARMA';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Biprotein Classic 3 lb ', N'51 Servicios', 329000, N'imagenes/biBiprotein_Classic_3_lb.png', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Proteina' AND b.Name=N'NUTRAMERICAN PHARMA';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Best Protein 2 lb ', N'28 Servicios', 214900, N'imagenes/best_protein_2lb.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Proteina' AND b.Name=N'PROSCIENCE';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Best Protein 4 lb ', N'55 Servicios', 399900, N'imagenes/best_protein_4lb.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Proteina' AND b.Name=N'PROSCIENCE';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Best Vegan 2.16 lb  ', N'28 Servicios', 130000, N'imagenes/Best_Vegan_216.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Proteina' AND b.Name=N'PROSCIENCE';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Best Whey 2 lb  ', N'28 Servicios', 161900, N'imagenes/Best_Whey_2 lbs.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Proteina' AND b.Name=N'PROSCIENCE';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Best Whey 5 lb  ', N'69 Servicios', 339000, N'imagenes/Best_Whey_Proscience_5_LB.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Proteina' AND b.Name=N'PROSCIENCE';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Smart Gainer 13lb  ', N'24 Servicios', 344900, N'imagenes/Smart_Gainer_13lb.jpg', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Proteina' AND b.Name=N'PROSCIENCE';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Smart Gainer 3b  ', N'6 Servicios', 98900, N'imagenes/Smart_Gainer_3lb.jpg', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Proteina' AND b.Name=N'PROSCIENCE';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Smart Gainer 6lb  ', N'11 Servicios', 98900, N'imagenes/smart-6lb.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Proteina' AND b.Name=N'PROSCIENCE';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'TNT 3lb  ', N'4 Servicios', 91200, N'imagenes/TNT_BOLSA_3lb.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Proteina' AND b.Name=N'TNT';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'TNT 6lb  ', N'9 Servicios', 175000, N'imagenes/tnt_gainer_6lb.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Proteina' AND b.Name=N'TNT';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'TNT 10lb  ', N'15 Servicios', 285000, N'imagenes/tnt_10lb.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Proteina' AND b.Name=N'TNT';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Elite Whey 5 Lb ', N'63 Servicios', 380000, N'imagenes/Elite_Dimatize_5 Lb.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Proteina' AND b.Name=N'DYMATIZE';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Elite Whey Protein 2 Lb ', N'25 Servicios', 207000, N'imagenes/Elite_Whey_Protein_2lb.avif', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Proteina' AND b.Name=N'DYMATIZE';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Iso 100 1.3 Lb ', N'20 Servicios', 235500, N'imagenes/Iso_100_1_3_Lb.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Proteina' AND b.Name=N'DYMATIZE';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Iso 100 3 Lb ', N'45 Servicios', 390000, N'imagenes/iso_100_2lb.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Proteina' AND b.Name=N'DYMATIZE';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Iso 100 5 Lb ', N'73 Servicios', 550000, N'imagenes/iso_100_2lb.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Proteina' AND b.Name=N'DYMATIZE';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Super Mass Gainer 12 Lbs ', N'16 Servicios', 361000, N'imagenes/super_mass_12.jpg', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Proteina' AND b.Name=N'DYMATIZE';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Super Mass Gainer 6 Lbs ', N'8 Servicios', 365000, N'imagenes/super_mass_12.jpg', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Proteina' AND b.Name=N'DYMATIZE';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Isopure Zero Carb 3lb', N'44 Servicios', 395000, N'imagenes/Isopure_3lb.avif', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Proteina' AND b.Name=N'ISOPURE';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Isopure Zero Carb 1,98lb', N'36 Servicios', 329000, N'imagenes/Isopure_Zero_Carb.jpg', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Proteina' AND b.Name=N'ISOPURE';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Iso whey 5lb ', N'75 Servicios', 391000, N'imagenes/MUSCLETECH_whey_5lb.jpg', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Proteina' AND b.Name=N'MUSCLETECH';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Mass Tech Elite-2lb ', N'10 Servicios', 420000, N'imagenes/Mass_Tech_Elite -.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Proteina' AND b.Name=N'MUSCLETECH';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'extreme 2000 - 6 Lb   ', N'5 Servicios', 241000, N'imagenes/Extreme_2000.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Proteina' AND b.Name=N'MUSCLETECH';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Nitro Tech Protein - 4 Lb   ', N'40 Servicios', 301000, N'imagenes/Nitro_Tech_Protein_4 Lb.avif', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Proteina' AND b.Name=N'MUSCLETECH';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Nitro Tech Whey GOLD 2LB  ', N'31 Servicios', 213000, N'imagenes/Gold_Muscletech_5_LB.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Proteina' AND b.Name=N'MUSCLETECH';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Nitro Tech Whey GOLD 5LB  ', N'69 Servicios', 322900, N'imagenes/Gold_Muscletech_5_LB.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Proteina' AND b.Name=N'MUSCLETECH';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Nitro Tech Protein 2LB  ', N'22 Servicios', 213000, N'imagenes/Nitrotech_Whey_Protein.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Proteina' AND b.Name=N'MUSCLETECH';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Nitro Tech Protein 4LB  ', N'40 Servicios', 301000, N'imagenes/Nitrotech_Whey_Protein.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Proteina' AND b.Name=N'MUSCLETECH';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'100% Whey Gold Standard 2 lb  ', N'29 Servicios', 225000, N'imagenes/gold-standard-2-lb.jpg', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Proteina' AND b.Name=N'OPTIMUM NUTRITION';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'100% Whey Gold Standard 5 lb  ', N'73 Servicios', 440900, N'imagenes/gold-standar-5lb.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Proteina' AND b.Name=N'OPTIMUM NUTRITION';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Creatine Time 150g', N'50 Servicios', 58000, N'Creatine_Time.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Creatina' AND b.Name=N'VITANAS';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Creatine Time 300g', N'100 Servicios', 98000, N'Creatine_Time_100.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Creatina' AND b.Name=N'IMN';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Creatine Monohidrato', N'100 Servicios', 98000, N'creatina_monohidratada_GMN.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Creatina' AND b.Name=N'GMN';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Healthy 150g Unflavored ', N'50 Servicios', 85000, N'imagenes/Healthy_Unflavored.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Creatina' AND b.Name=N'Healthy Sports';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Healthy 300g Unflavored ', N'100 Servicios', 127200, N'imagenes/Healthy_Unflavored_100.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Creatina' AND b.Name=N'Healthy Sports';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Creatina Monohidratada (500g) ', N'133 Servicios', 129000, N'imagenes/Creatina_Monohidratada_imn.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Creatina' AND b.Name=N'IMN';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Creatina Monohidratada (300g) ', N'50 Servicios', 79900, N'imagenes/Creatina_Monohidratada_imn.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Creatina' AND b.Name=N'IMN';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'CR2 (Passion fruit)', N'30 Servicios', 69000, N'imagenes/CR2_Passion_fruit.jpg', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Creatina' AND b.Name=N'MACROBLENDS';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'CR2 Creatine(360g) ', N'60 Servicios', 99000, N'imagenes/Creatina_CR2.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Creatina' AND b.Name=N'MACROBLENDS';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Legacy (330g)', N'30 Servicios', 85000, N'imagenes/Legacy_30_Serv.jpg', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Creatina' AND b.Name=N'PROSCIENCE';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Legacy (550g)', N'50 Servicios', 130000, N'imagenes/Legacy_50_Serv.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Creatina' AND b.Name=N'PROSCIENCE';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Legend (600g) ', N'50 Servicios', 127000, N'imagenes/Legend_50.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Creatina' AND b.Name=N'FITMAFIA';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Legend (360g) ', N'30 Servicios', 79900, N'imagenes/LEGEND_30_SERV.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Creatina' AND b.Name=N'FITMAFIA';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Atomic Monohydrato(600g) ', N'120 Servicios', 115000, N'imagenes/atomic_mono.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Creatina' AND b.Name=N'SMARTMUSCLE';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Atomic Monohydrato(300g) ', N'60 Servicios', 65000, N'imagenes/atomic_mono.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Creatina' AND b.Name=N'SMARTMUSCLE';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Atomic HCL(300g) ', N'60 Servicios', 90000, N'imagenes/Atomic_Hcl.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Creatina' AND b.Name=N'SMARTMUSCLE';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Creatina Dymatize (300g)  ', N'88 Servicios', 157000, N'imagenes/Creatina_Dymatize.jpg', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Creatina' AND b.Name=N'DYMATIZE';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Cell Tech 6lb  ', N'56 Servicios', 249000, N'imagenes/Cell-_ech_6Lb.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Creatina' AND b.Name=N'MUSCLETECH';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Cell Tech 3lb  ', N'27 Servicios', 181000, N'imagenes/Cell-_ech_6Lb.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Creatina' AND b.Name=N'MUSCLETECH';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Cell Tech Creator - Unflavored ', N'120 Servicios', 154000, N'imagenes/Cell_Tech_Creator.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Creatina' AND b.Name=N'MUSCLETECH';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Platinum creatine - 400gr Unflavored ', N'80 servicio', 177000, N'imagenes/Platinum_Creatine.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Creatina' AND b.Name=N'MUSCLETECH';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Platinum creatine - 400gr Unflavored ', N'60 servicio', 177000, N'imagenes/Platinun_sabor_creatina.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Creatina' AND b.Name=N'MUSCLETECH';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Creatina ON  ', N'240 servicio', 257000, N'imagenes/Creatina_ON_240.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Creatina' AND b.Name=N'OPTIMUM NUTRITION';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Creatina ON  ', N'120 servicio', 192000, N'imagenes/Creatina_ON_240.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Creatina' AND b.Name=N'OPTIMUM NUTRITION';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Creatina ON  ', N'60 servicio', 132000, N'imagenes/Creatine_60_servicios.jpg', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Creatina' AND b.Name=N'OPTIMUM NUTRITION';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Intenze Citrus Punch ', N'30 servicios', 145000, N'imagenes/Intenze_30_Serv.jpg', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Pre-Entreno' AND b.Name=N'PROSCIENCE';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Pase (330g) ', N'30 servicios', 105000, N'imagenes/pase_fitmafia.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Pre-Entreno' AND b.Name=N'FITMAFIA';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Electron (300g) ', N'15 servicios', 85000, N'imagenes/electron_15_s.jpg', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Pre-Entreno' AND b.Name=N'SMARTMUSCLE';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Electron (600g) ', N'30 servicios', 125000, N'imagenes/electron_15_s.jpg', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Pre-Entreno' AND b.Name=N'SMARTMUSCLE';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Venom Inferno  ', N'40 servicios', 161000, N'imagenes/VENOM_40.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Pre-Entreno' AND b.Name=N'DRAGON PHARMA';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Venom Inferno  ', N'30 servicios', 120000, N'imagenes/venom_30.jpg', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Pre-Entreno' AND b.Name=N'DRAGON PHARMA';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Psychotic Black ', N'35 servicios', 129500, N'imagenes/Psychotic_Black_35.jpg', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Pre-Entreno' AND b.Name=N'INSANE LABZ';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Psychotic Gold', N'60 servicios', 180900, N'imagenes/Psychotic_GOLD_60.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Pre-Entreno' AND b.Name=N'INSANE LABZ';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Psychotic Red', N'35 servicios', 151000, N'imagenes/psychotic_red.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Pre-Entreno' AND b.Name=N'INSANE LABZ';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Psychotic Red', N'60 servicios', 189000, N'imagenes/psychotic_red.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Pre-Entreno' AND b.Name=N'INSANE LABZ';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Psychotic Saw', N'30 servicios', 154900, N'imagenes/Psychotic_saw.jpg', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Pre-Entreno' AND b.Name=N'INSANE LABZ';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Psychotic Saw', N'60 servicios', 195000, N'imagenes/Psychotic_saw.jpg', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Pre-Entreno' AND b.Name=N'INSANE LABZ';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Psychotic xtreme', N'30 servicios', 165000, N'imagenes/Psychotic_xtreme.jpg', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Pre-Entreno' AND b.Name=N'INSANE LABZ';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'B-100 Complex ', N'50 tabs', 86000, N'imagenes/B_100_Complex.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Vitamina' AND b.Name=N'HEALTHY AMERICA';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'VCal-Mag-Zinc Plus VD3', N'90 Cap', 63000, N'imagenes/Cal_Mag_Zinc_Plus_VD3.jpg', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Vitamina' AND b.Name=N'HEALTHY AMERICA';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Chelated Zinc 40 mg', N'100 tabs', 69000, N'imagenes/chelated_zinc.jpg', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Vitamina' AND b.Name=N'HEALTHY AMERICA';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Fibaxil ', N'120 Cap', 80000, N'imagenes/Fibaxil.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Vitamina' AND b.Name=N'HEALTHY AMERICA';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Melatonina 3mg ', N'120 Sft', 53000, N'imagenes/Melatonina.jpg', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Vitamina' AND b.Name=N'HEALTHY AMERICA';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Potassium 99mg  ', N'60 cap', 52000, N'imagenes/Potassium_99mg.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Vitamina' AND b.Name=N'HEALTHY AMERICA';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Probioticos ', N'60 Gummies', 60000, N'imagenes/Probiotics.jpg', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Vitamina' AND b.Name=N'HEALTHY AMERICA';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Super Magnesium 400mg', N'100 Sft', 85000, N'imagenes/Super_Magnesium.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Vitamina' AND b.Name=N'HEALTHY AMERICA';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Vitamina C 1000mg  ', N'100 Tab', 67000, N'imagenes/Vitamina_C.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Vitamina' AND b.Name=N'HEALTHY AMERICA';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Vitamina D3 2000 IU  ', N'100 Sft', 67000, N'imagenes/Vitamina_D3.jpg', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Vitamina' AND b.Name=N'HEALTHY AMERICA';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Multi(Vitamina C / Multivitamínico 600 g) ', N'30 Servicios', 69900, N'imagenes/Multi_MN.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Vitamina' AND b.Name=N'IMN';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Ashwagandha', N'60 gomas', 75000, N'imagenes/Ashwagandha.jpg', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Vitamina' AND b.Name=N'PROSCIENCE';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Vitamina D3+K2 ', N'30 perlas', 77000, N'imagenes/VITAMINA_D3_K2_PROS.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Vitamina' AND b.Name=N'PROSCIENCE';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'The One Orange 300 g  ', N'30 servicios', 90000, N'imagenes/The_One_Orange.jpg', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Vitamina' AND b.Name=N'PROSCIENCE';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Shield Lemon 450g  ', N'30 servicios', 100000, N'imagenes/Shield_Lemon.jpg', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Vitamina' AND b.Name=N'PROSCIENCE';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Multiplatinum  ', N'90 cap', 94000, N'imagenes/multiplatinum.jpg', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Vitamina' AND b.Name=N'MUSCLETECH';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Multiplatinum ', N'180 cap', 133000, N'imagenes/multiplatinum.jpg', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Vitamina' AND b.Name=N'MUSCLETECH';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Multivitamin OPTI-MEN  ', N'90 Caps', 137000, N'imagenes/Multivitamin_optimen.jpg', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Vitamina' AND b.Name=N'OPTIMUM NUTRITION';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Multivitamin OPTI-MEN  ', N'150 Caps', 175000, N'imagenes/Multivitamin_optimen.jpg', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Vitamina' AND b.Name=N'OPTIMUM NUTRITION';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Fish Oil Omega 3 1200mg', N'100 Cap', 70000, N'imagenes/Fish_Oil_Omega.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Omega' AND b.Name=N'HEALTHY AMERICA';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Triple Omega 3-6-9 ', N'120 Cap', 99000, N'imagenes/Triple_Omega.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Omega' AND b.Name=N'HEALTHY AMERICA';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'KORAGEEM (Collagen Red Fusion 480 g) ', N'24 Servicios', 89900, N'imagenes/KORAGEEM.jpg', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Colágeno' AND b.Name=N'IMN';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'KORAGEEM (Collagen Té Chai 480 g)  ', N'24 Servicios', 89900, N'imagenes/KORAGEEM_Te.jpg', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Colágeno' AND b.Name=N'IMN';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Omega 3   ', N'120 Caps', 64900, N'imagenes/OMEGA_3_imn.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Omega' AND b.Name=N'IMN';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Omega 3  ', N'120 Caps', 75000, N'imagenes/Omega_Megablends.png', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Omega' AND b.Name=N'MACROBLENDS';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Collagen Stack ', N'45 Servicios', 99990, N'imagenes/Collagen_Stack.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Colágeno' AND b.Name=N'NUTRAMERICAN PHARMA';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Omega 3   ', N'120 Caps', 77000, N'imagenes/Omega_proscience.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Omega' AND b.Name=N'PROSCIENCE';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Omega   ', N'100 Caps', 100000, N'imagenes/Platinum_Fish_Oil_Omega_3_Muscletech.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Omega' AND b.Name=N'MUSCLETECH';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'BCAA 2:1:1', N'30 Servicios', 119900, N'imagenes/BCAA.jpg', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Aminoacidos' AND b.Name=N'IMN';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'EAAS Mix Aminos', N'30 Servicios', 117900, N'imagenes/Mix_Aminos_30.png', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Aminoacidos' AND b.Name=N'MACROBLENDS';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Army Eaas Citrus Punch ', N'30 Servicios', 115000, N'imagenes/Army_Eaas.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Aminoacidos' AND b.Name=N'PROSCIENCE';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Alpha Bcaa (600g)', N'30 Servicios', 120000, N'imagenes/Alpha_Bcaa.jpg', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Aminoacidos' AND b.Name=N'SMARTMUSCLE';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'100 % Eaa+ Platinum', N'30 Servicios', 177000, N'imagenes/100_Platinum_EAA.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Aminoacidos' AND b.Name=N'MUSCLETECH';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Amino Build', N'40 Servicios', 177000, N'imagenes/100_Platinum_EAA.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Aminoacidos' AND b.Name=N'MUSCLETECH';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Amino Energy Fruit Punch /Citrus ', N'30 Servicios', 131000, N'imagenes/amino-energy.jpg', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Aminoacidos' AND b.Name=N'OPTIMUM NUTRITION';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Amino Energy Fruit Fusion', N'65 Servicios', 220000, N'imagenes/amino-energy.jpg', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Aminoacidos' AND b.Name=N'OPTIMUM NUTRITION';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Burner Stack 360g ', N'60 Servicios', 139990, N'imagenes/Burner_Stack_360g.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Quemador' AND b.Name=N'NUTRAMERICAN PHARMA';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Animal Test ', N'120 tab', 101000, N'imagenes/animal_test.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Precursor' AND b.Name=N'ANGRY SUPPLEMENTS';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Monster Test Blanco  ', N'120 tab', 97000, N'imagenes/Monster_test.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Precursor' AND b.Name=N'ANGRY SUPPLEMENTS';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Monster test + Creatina ', N'120 Cap', 137000, N'imagenes/Monster_test_Creatina.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Precursor' AND b.Name=N'ANGRY SUPPLEMENTS';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Monster Test PM  ', N'60 Cap', 101000, N'imagenes/Monster_Test_PM.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Precursor' AND b.Name=N'ANGRY SUPPLEMENTS';
INSERT INTO dbo.Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
SELECT c.CategoryId, b.BrandId, N'Alpha Test ', N'120 Cap', 167000, N'imagenes/amino_build.webp', 1
FROM dbo.Categories c CROSS JOIN dbo.Brands b
WHERE c.Name=N'Precursor' AND b.Name=N'MUSCLETECH';
GO

SELECT COUNT(*) AS TotalProductos FROM dbo.Products;
SELECT TOP 20 p.ProductId, c.Name AS Categoria, b.Name AS Marca,
       p.Name, p.Presentation, p.Price, p.ImagePath
FROM dbo.Products p
JOIN dbo.Categories c ON c.CategoryId=p.CategoryId
JOIN dbo.Brands b ON b.BrandId=p.BrandId
ORDER BY p.ProductId;
GO
