CREATE TABLE [dbo].[Acq_Deal_Sport_Language] (
    [Acq_Deal_Sport_Language_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Sport_Code]          INT      NULL,
    [Language_Type]                CHAR (1) NULL,
    [Language_Code]                INT      NULL,
    [Language_Group_Code]          INT      NULL,
    [Flag]                         CHAR (1) NULL,
    CONSTRAINT [PK_Acq_Deal_Sport_Language] PRIMARY KEY CLUSTERED ([Acq_Deal_Sport_Language_Code] ASC),
    CONSTRAINT [FK_Acq_Deal_Sport_Language_Acq_Deal_Sport] FOREIGN KEY ([Acq_Deal_Sport_Code]) REFERENCES [dbo].[Acq_Deal_Sport] ([Acq_Deal_Sport_Code]),
    CONSTRAINT [FK_Acq_Deal_Sport_Language_Language] FOREIGN KEY ([Language_Code]) REFERENCES [dbo].[Language] ([Language_Code]),
    CONSTRAINT [FK_Acq_Deal_Sport_Language_Language_Group] FOREIGN KEY ([Language_Group_Code]) REFERENCES [dbo].[Language_Group] ([Language_Group_Code])
);

