CREATE TABLE [dbo].[AT_Acq_Deal_Ancillary_Platform_Medium] (
    [AT_Acq_Deal_Ancillary_Platform_Medium_Code] INT IDENTITY (1, 1) NOT NULL,
    [AT_Acq_Deal_Ancillary_Platform_Code]        INT NULL,
    [Ancillary_Platform_Medium_Code]             INT NULL,
    [Acq_Deal_Ancillary_Platform_Medium_Code]    INT NULL,
    CONSTRAINT [PK_AT_Acq_Deal_Ancillary_Medium] PRIMARY KEY CLUSTERED ([AT_Acq_Deal_Ancillary_Platform_Medium_Code] ASC),
    CONSTRAINT [FK_AT_Acq_Deal_Ancillary_Platform_Medium_Ancillary_Platform_Medium] FOREIGN KEY ([Ancillary_Platform_Medium_Code]) REFERENCES [dbo].[Ancillary_Platform_Medium] ([Ancillary_Platform_Medium_Code]),
    CONSTRAINT [FK_AT_Acq_Deal_Ancillary_Platform_Medium_AT_Acq_Deal_Ancillary_Platform] FOREIGN KEY ([AT_Acq_Deal_Ancillary_Platform_Code]) REFERENCES [dbo].[AT_Acq_Deal_Ancillary_Platform] ([AT_Acq_Deal_Ancillary_Platform_Code])
);

