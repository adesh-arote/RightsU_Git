CREATE TABLE [dbo].[AT_Syn_Deal_Rights_Title] (
    [AT_Syn_Deal_Rights_Title_Code] INT IDENTITY (1, 1) NOT NULL,
    [AT_Syn_Deal_Rights_Code]       INT NULL,
    [Title_Code]                    INT NULL,
    [Episode_From]                  INT NULL,
    [Episode_To]                    INT NULL,
    [Syn_Deal_Rights_Title_Code]    INT NULL,
    CONSTRAINT [PK_AT_Syn_Deal_Rights_Title] PRIMARY KEY CLUSTERED ([AT_Syn_Deal_Rights_Title_Code] ASC),
    CONSTRAINT [FK_AT_Syn_Deal_rights_title_AT_Syn_Deal_rights] FOREIGN KEY ([AT_Syn_Deal_Rights_Code]) REFERENCES [dbo].[AT_Syn_Deal_Rights] ([AT_Syn_Deal_Rights_Code]),
    CONSTRAINT [FK_AT_Syn_Deal_Rights_Title_Title] FOREIGN KEY ([Title_Code]) REFERENCES [dbo].[Title] ([Title_Code])
);

