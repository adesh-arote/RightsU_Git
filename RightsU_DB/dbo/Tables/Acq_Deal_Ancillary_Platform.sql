CREATE TABLE [dbo].[Acq_Deal_Ancillary_Platform] (
    [Acq_Deal_Ancillary_Platform_Code] INT IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Ancillary_Code]          INT NULL,
    [Ancillary_Platform_code]          INT NULL,
    [Platform_Code]                    INT NULL,
    CONSTRAINT [PK_Acq_Deal_Ancillary_Platform] PRIMARY KEY CLUSTERED ([Acq_Deal_Ancillary_Platform_Code] ASC),
    CONSTRAINT [FK_Acq_Deal_Ancillary_Platform_Acq_Deal_Ancillary] FOREIGN KEY ([Acq_Deal_Ancillary_Code]) REFERENCES [dbo].[Acq_Deal_Ancillary] ([Acq_Deal_Ancillary_Code]),
    CONSTRAINT [FK_Acq_Deal_Ancillary_Platform_Ancillary_Platform] FOREIGN KEY ([Ancillary_Platform_code]) REFERENCES [dbo].[Ancillary_Platform] ([Ancillary_Platform_code]),
    CONSTRAINT [FK_Acq_Deal_Ancillary_Platform_Platform] FOREIGN KEY ([Platform_Code]) REFERENCES [dbo].[Platform] ([Platform_Code])
);

