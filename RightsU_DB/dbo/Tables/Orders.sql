CREATE TABLE [dbo].[Orders] (
    [OrderID]      INT            IDENTITY (1, 1) NOT NULL,
    [InvoiceNo]    NVARCHAR (MAX) NULL,
    [CustomerName] NVARCHAR (MAX) NULL,
    [Email]        NVARCHAR (MAX) NULL,
    [MobileNo]     NVARCHAR (50)  NULL,
    [PurchaseDate] DATETIME       NULL,
    [Total]        INT            NULL,
    CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED ([OrderID] ASC)
);

