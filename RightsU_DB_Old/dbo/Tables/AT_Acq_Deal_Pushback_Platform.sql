CREATE TABLE [dbo].[AT_Acq_Deal_Pushback_Platform] (
    [AT_Acq_Deal_Pushback_Platform_Code] INT IDENTITY (1, 1) NOT NULL,
    [AT_Acq_Deal_Pushback_Code]          INT NULL,
    [Platform_Code]                      INT NULL,
    [Acq_Deal_Pushback_Platform_Code]    INT NULL,
    CONSTRAINT [PK_AT_Acq_Deal_Pushback_Platform] PRIMARY KEY CLUSTERED ([AT_Acq_Deal_Pushback_Platform_Code] ASC),
    CONSTRAINT [FK_AT_Acq_Deal_Pushback_Platform_AT_Acq_Deal_Pushback] FOREIGN KEY ([AT_Acq_Deal_Pushback_Code]) REFERENCES [dbo].[AT_Acq_Deal_Pushback] ([AT_Acq_Deal_Pushback_Code]),
    CONSTRAINT [FK_AT_Acq_Deal_Pushback_Platform_Platform] FOREIGN KEY ([Platform_Code]) REFERENCES [dbo].[Platform] ([Platform_Code])
);

