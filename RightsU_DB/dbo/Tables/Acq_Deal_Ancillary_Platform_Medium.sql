CREATE TABLE [dbo].[Acq_Deal_Ancillary_Platform_Medium] (
    [Acq_Deal_Ancillary_Platform_Medium_Code] INT IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Ancillary_Platform_Code]        INT NULL,
    [Ancillary_Platform_Medium_Code]          INT NULL,
    CONSTRAINT [PK_Acq_Deal_Ancillary_Medium] PRIMARY KEY CLUSTERED ([Acq_Deal_Ancillary_Platform_Medium_Code] ASC),
    CONSTRAINT [FK_Acq_Deal_Ancillary_Platform_Medium_Acq_Deal_Ancillary_Platform] FOREIGN KEY ([Acq_Deal_Ancillary_Platform_Code]) REFERENCES [dbo].[Acq_Deal_Ancillary_Platform] ([Acq_Deal_Ancillary_Platform_Code]),
    CONSTRAINT [FK_Acq_Deal_Ancillary_Platform_Medium_Ancillary_Platform_Medium] FOREIGN KEY ([Ancillary_Platform_Medium_Code]) REFERENCES [dbo].[Ancillary_Platform_Medium] ([Ancillary_Platform_Medium_Code])
);

