CREATE TABLE [dbo].[AT_Acq_Deal_Pushback_Dubbing] (
    [AT_Acq_Deal_Pushback_Dubbing_Code] INT      IDENTITY (1, 1) NOT NULL,
    [AT_Acq_Deal_Pushback_Code]         INT      NULL,
    [Language_Type]                     CHAR (1) NULL,
    [Language_Code]                     INT      NULL,
    [Language_Group_Code]               INT      NULL,
    [Acq_Deal_Pushback_Dubbing_Code]    INT      NULL,
    CONSTRAINT [PK_AT_Acq_Deal_Pushback_Dubbing] PRIMARY KEY CLUSTERED ([AT_Acq_Deal_Pushback_Dubbing_Code] ASC),
    CONSTRAINT [FK_AT_Acq_Deal_Pushback_Dubbing_AT_Acq_Deal_Pushback] FOREIGN KEY ([AT_Acq_Deal_Pushback_Code]) REFERENCES [dbo].[AT_Acq_Deal_Pushback] ([AT_Acq_Deal_Pushback_Code]),
    CONSTRAINT [FK_AT_Acq_Deal_Pushback_Dubbing_Language] FOREIGN KEY ([Language_Code]) REFERENCES [dbo].[Language] ([Language_Code]),
    CONSTRAINT [FK_AT_Acq_Deal_Pushback_Dubbing_Language_Group] FOREIGN KEY ([Language_Group_Code]) REFERENCES [dbo].[Language_Group] ([Language_Group_Code])
);

