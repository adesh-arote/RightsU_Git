CREATE TABLE [dbo].[Product] (
    [Product_Code]         INT            IDENTITY (1, 1) NOT NULL,
    [Product_Name]         NVARCHAR (MAX) NULL,
    [Price]                INT            NULL,
    [ProductCategory_Code] INT            NULL,
    CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED ([Product_Code] ASC),
    CONSTRAINT [FK_Product_ProductCategory] FOREIGN KEY ([ProductCategory_Code]) REFERENCES [dbo].[ProductCategory] ([ProductCategory_Code])
);

