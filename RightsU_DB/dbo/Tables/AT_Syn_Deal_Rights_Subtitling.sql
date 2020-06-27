CREATE TABLE [dbo].[AT_Syn_Deal_Rights_Subtitling] (
    [AT_Syn_Deal_Rights_Subtitling_Code] INT      IDENTITY (1, 1) NOT NULL,
    [AT_Syn_Deal_Rights_Code]            INT      NULL,
    [Language_Type]                      CHAR (1) NULL,
    [Language_Code]                      INT      NULL,
    [Language_Group_Code]                INT      NULL,
    [Syn_Deal_Rights_Subtitling_Code]    INT      NULL,
    CONSTRAINT [PK_AT_Syn_Deal_Rights_Subtitling] PRIMARY KEY CLUSTERED ([AT_Syn_Deal_Rights_Subtitling_Code] ASC),
    CONSTRAINT [FK_AT_Syn_Deal_Rights_Subtitling_AT_Syn_Deal_Rights] FOREIGN KEY ([AT_Syn_Deal_Rights_Code]) REFERENCES [dbo].[AT_Syn_Deal_Rights] ([AT_Syn_Deal_Rights_Code]),
    CONSTRAINT [FK_AT_Syn_Deal_Rights_Subtitling_Language] FOREIGN KEY ([Language_Code]) REFERENCES [dbo].[Language] ([Language_Code]),
    CONSTRAINT [FK_AT_Syn_Deal_Rights_Subtitling_Language_Group_Code] FOREIGN KEY ([Language_Group_Code]) REFERENCES [dbo].[Language_Group] ([Language_Group_Code])
);

