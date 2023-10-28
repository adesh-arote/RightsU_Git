CREATE TABLE [dbo].[ProductCategory] (
    [ProductCategory_Code] INT           IDENTITY (1, 1) NOT NULL,
    [ProductCategory_Name] NVARCHAR (50) NULL,
    CONSTRAINT [PK_ProductCategory] PRIMARY KEY CLUSTERED ([ProductCategory_Code] ASC)
);

