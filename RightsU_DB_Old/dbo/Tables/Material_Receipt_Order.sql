CREATE TABLE [dbo].[Material_Receipt_Order] (
    [Material_Receipt_Order]     INT IDENTITY (1, 1) NOT NULL,
    [Material_Receipt_Code]      INT NOT NULL,
    [Material_Order_Detail_Code] INT NULL,
    [Received_Qantity]           INT NULL,
    CONSTRAINT [PK_Material_Receipt_Order] PRIMARY KEY CLUSTERED ([Material_Receipt_Order] ASC),
    CONSTRAINT [FK_Material_Receipt_Order_Material_Order_Details] FOREIGN KEY ([Material_Order_Detail_Code]) REFERENCES [dbo].[Material_Order_Details] ([Material_Order_Detail_Code]),
    CONSTRAINT [FK_Material_Receipt_Order_Material_Receipt] FOREIGN KEY ([Material_Receipt_Code]) REFERENCES [dbo].[Material_Receipt] ([Material_Receipt_Code])
);

