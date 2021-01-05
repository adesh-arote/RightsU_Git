CREATE TABLE [dbo].[AT_Acq_Deal_Sport_Platform] (
    [AT_Acq_Deal_Sport_Platform_Code] INT         IDENTITY (1, 1) NOT NULL,
    [AT_Acq_Deal_Sport_Code]          INT         NOT NULL,
    [Platform_Code]                   INT         NOT NULL,
    [Type]                            VARCHAR (2) NULL,
    [Acq_Deal_Sport_Platform_Code]    INT         NULL,
    CONSTRAINT [FK_AT_Acq_Deal_Sport_Platform_AT_Acq_Deal_Sport] FOREIGN KEY ([AT_Acq_Deal_Sport_Code]) REFERENCES [dbo].[AT_Acq_Deal_Sport] ([AT_Acq_Deal_Sport_Code]),
    CONSTRAINT [FK_AT_Acq_Deal_Sport_Platform_Platform] FOREIGN KEY ([Platform_Code]) REFERENCES [dbo].[Platform] ([Platform_Code])
);

