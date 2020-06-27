CREATE TABLE [dbo].[AT_Acq_Deal_Sport_Language] (
    [AT_Acq_Deal_Sport_Language_Code] INT      IDENTITY (1, 1) NOT NULL,
    [AT_Acq_Deal_Sport_Code]          INT      NULL,
    [Language_Type]                   CHAR (1) NULL,
    [Language_Code]                   INT      NULL,
    [Language_Group_Code]             INT      NULL,
    [Flag]                            CHAR (1) NULL,
    [Acq_Deal_Sport_Language_Code]    INT      NULL,
    CONSTRAINT [PK_AT_Acq_Deal_Sport_Language] PRIMARY KEY CLUSTERED ([AT_Acq_Deal_Sport_Language_Code] ASC),
    CONSTRAINT [FK_AT_Acq_Deal_Sport_Language_AT_Acq_Deal_Sport] FOREIGN KEY ([AT_Acq_Deal_Sport_Code]) REFERENCES [dbo].[AT_Acq_Deal_Sport] ([AT_Acq_Deal_Sport_Code]),
    CONSTRAINT [FK_AT_Acq_Deal_Sport_Language_Language] FOREIGN KEY ([Language_Code]) REFERENCES [dbo].[Language] ([Language_Code]),
    CONSTRAINT [FK_AT_Acq_Deal_Sport_Language_Language_Group] FOREIGN KEY ([Language_Group_Code]) REFERENCES [dbo].[Language_Group] ([Language_Group_Code])
);

