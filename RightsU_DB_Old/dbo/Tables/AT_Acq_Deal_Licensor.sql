CREATE TABLE [dbo].[AT_Acq_Deal_Licensor] (
    [AT_Acq_Deal_Licensor_Code] INT IDENTITY (1, 1) NOT NULL,
    [AT_Acq_Deal_Code]          INT NULL,
    [Vendor_Code]               INT NULL,
    [Acq_Deal_Licensor_Code]    INT NULL,
    CONSTRAINT [PK_AT_Acq_Deal_Licensor] PRIMARY KEY CLUSTERED ([AT_Acq_Deal_Licensor_Code] ASC),
    CONSTRAINT [FK_AT_Acq_Deal_Licensor_AT_Acq_Deal] FOREIGN KEY ([AT_Acq_Deal_Code]) REFERENCES [dbo].[AT_Acq_Deal] ([AT_Acq_Deal_Code]),
    CONSTRAINT [FK_AT_Acq_Deal_Licensor_Vendor] FOREIGN KEY ([Vendor_Code]) REFERENCES [dbo].[Vendor] ([Vendor_Code])
);

