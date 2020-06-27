CREATE TABLE [dbo].[Provisional_Deal_Licensor] (
    [Provisional_Deal_Licensor_Code] INT IDENTITY (1, 1) NOT NULL,
    [Provisional_Deal_Code]          INT NULL,
    [Vendor_Code]                    INT NULL,
    CONSTRAINT [PK_Provisional_Deal_Licensor] PRIMARY KEY CLUSTERED ([Provisional_Deal_Licensor_Code] ASC),
    CONSTRAINT [FK_Provisional_Deal_Licensor_Provisional_Deal] FOREIGN KEY ([Provisional_Deal_Code]) REFERENCES [dbo].[Provisional_Deal] ([Provisional_Deal_Code]),
    CONSTRAINT [FK_Provisional_Deal_Licensor_Vendor] FOREIGN KEY ([Vendor_Code]) REFERENCES [dbo].[Vendor] ([Vendor_Code])
);

