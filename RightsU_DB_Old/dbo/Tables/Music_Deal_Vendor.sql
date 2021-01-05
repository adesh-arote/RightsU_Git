CREATE TABLE [dbo].[Music_Deal_Vendor] (
    [Music_Deal_Vendor_Code] INT IDENTITY (1, 1) NOT NULL,
    [Music_Deal_Code]        INT NULL,
    [Vendor_Code]            INT NULL,
    CONSTRAINT [PK_Music_Deal_Vendor] PRIMARY KEY CLUSTERED ([Music_Deal_Vendor_Code] ASC),
    CONSTRAINT [FK_Music_Deal_Vendor_Music_Deal] FOREIGN KEY ([Music_Deal_Code]) REFERENCES [dbo].[Music_Deal] ([Music_Deal_Code]),
    CONSTRAINT [FK_Music_Deal_Vendor_Vendor] FOREIGN KEY ([Vendor_Code]) REFERENCES [dbo].[Vendor] ([Vendor_Code])
);

