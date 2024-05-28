CREATE TABLE [dbo].[Acq_Deal_Sport_Platform] (
    [Acq_Deal_Sport_Platform_Code] INT         IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Sport_Code]          INT         NOT NULL,
    [Platform_Code]                INT         NOT NULL,
    [Type]                         VARCHAR (2) NULL,
    CONSTRAINT [PK_Acq_Deal_Sport_Platform] PRIMARY KEY CLUSTERED ([Acq_Deal_Sport_Platform_Code] ASC),
    CONSTRAINT [FK_Acq_Deal_Sport_Platform_Acq_Deal_Sport] FOREIGN KEY ([Acq_Deal_Sport_Code]) REFERENCES [dbo].[Acq_Deal_Sport] ([Acq_Deal_Sport_Code]),
    CONSTRAINT [FK_Acq_Deal_Sport_Platform_Platform] FOREIGN KEY ([Platform_Code]) REFERENCES [dbo].[Platform] ([Platform_Code])
);

