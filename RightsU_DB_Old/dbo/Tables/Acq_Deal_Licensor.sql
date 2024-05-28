CREATE TABLE [dbo].[Acq_Deal_Licensor] (
    [Acq_Deal_Licensor_Code] INT IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Code]          INT NULL,
    [Vendor_Code]            INT NULL,
    CONSTRAINT [PK_Acq_Deal_Licensor] PRIMARY KEY CLUSTERED ([Acq_Deal_Licensor_Code] ASC),
    CONSTRAINT [FK_Acq_Deal_Licensor_Acq_Deal] FOREIGN KEY ([Acq_Deal_Code]) REFERENCES [dbo].[Acq_Deal] ([Acq_Deal_Code]),
    CONSTRAINT [FK_Acq_Deal_Licensor_Vendor] FOREIGN KEY ([Vendor_Code]) REFERENCES [dbo].[Vendor] ([Vendor_Code])
);

