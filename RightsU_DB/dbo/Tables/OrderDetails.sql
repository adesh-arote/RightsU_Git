CREATE TABLE [dbo].[OrderDetails] (
    [OrderDetailsId]       INT IDENTITY (1, 1) NOT NULL,
    [OrderId]              INT NULL,
    [ProductCategory_Code] INT NULL,
    [Product_Code]         INT NULL,
    [Quantity]             INT NULL,
    [Amount]               INT NULL,
    [Total]                INT NULL,
    CONSTRAINT [PK_OrderDetails] PRIMARY KEY CLUSTERED ([OrderDetailsId] ASC),
    CONSTRAINT [FK_OrderDetails_Order] FOREIGN KEY ([OrderId]) REFERENCES [dbo].[Orders] ([OrderID]),
    CONSTRAINT [FK_OrderDetails_Product] FOREIGN KEY ([Product_Code]) REFERENCES [dbo].[Product] ([Product_Code]),
    CONSTRAINT [FK_OrderDetails_ProductCategory1] FOREIGN KEY ([ProductCategory_Code]) REFERENCES [dbo].[ProductCategory] ([ProductCategory_Code])
);

