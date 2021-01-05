CREATE TABLE [dbo].[AT_Music_Deal_Vendor] (
    [AT_Music_Deal_Vendor_Code] INT IDENTITY (1, 1) NOT NULL,
    [AT_Music_Deal_Code]        INT NULL,
    [Vendor_Code]               INT NULL,
    [Music_Deal_Vendor_Code]    INT NULL,
    CONSTRAINT [PK_AT_Music_Deal_Vendor] PRIMARY KEY CLUSTERED ([AT_Music_Deal_Vendor_Code] ASC),
    CONSTRAINT [FK_AT_Music_Deal_Vendor_AT_Music_Deal] FOREIGN KEY ([AT_Music_Deal_Code]) REFERENCES [dbo].[AT_Music_Deal] ([AT_Music_Deal_Code]),
    CONSTRAINT [FK_AT_Music_Deal_Vendor_Vendor] FOREIGN KEY ([Vendor_Code]) REFERENCES [dbo].[Vendor] ([Vendor_Code])
);

