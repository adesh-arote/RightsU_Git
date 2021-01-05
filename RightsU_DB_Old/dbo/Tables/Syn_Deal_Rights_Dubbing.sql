CREATE TABLE [dbo].[Syn_Deal_Rights_Dubbing] (
    [Syn_Deal_Rights_Dubbing_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Syn_Deal_Rights_Code]         INT      NULL,
    [Language_Type]                CHAR (1) NULL,
    [Language_Code]                INT      NULL,
    [Language_Group_Code]          INT      NULL,
    CONSTRAINT [PK_Syn_Deal_Rights_Dubbing] PRIMARY KEY CLUSTERED ([Syn_Deal_Rights_Dubbing_Code] ASC),
    CONSTRAINT [FK_Syn_Deal_Rights_Dubbing_Language] FOREIGN KEY ([Language_Code]) REFERENCES [dbo].[Language] ([Language_Code]),
    CONSTRAINT [FK_Syn_Deal_Rights_Dubbing_Language_Group_Code] FOREIGN KEY ([Language_Group_Code]) REFERENCES [dbo].[Language_Group] ([Language_Group_Code]),
    CONSTRAINT [FK_Syn_Deal_Rights_Dubbing_Syn_Deal_Rights] FOREIGN KEY ([Syn_Deal_Rights_Code]) REFERENCES [dbo].[Syn_Deal_Rights] ([Syn_Deal_Rights_Code])
);

