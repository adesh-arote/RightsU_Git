CREATE TABLE [dbo].[AT_Syn_Deal_Rights_Blackout_Dubbing] (
    [AT_Syn_Deal_Rights_Blackout_Dubbing_Code] INT IDENTITY (1, 1) NOT NULL,
    [AT_Syn_Deal_Rights_Blackout_Code]         INT NULL,
    [Language_Code]                            INT NULL,
    [Syn_Deal_Rights_Blackout_Dubbing_Code]    INT NULL,
    CONSTRAINT [PK_AT_Syn_Deal_Rights_Blackout_Dubbing] PRIMARY KEY CLUSTERED ([AT_Syn_Deal_Rights_Blackout_Dubbing_Code] ASC),
    CONSTRAINT [FK_AT_Syn_Deal_Rights_Blackout_Dubbing_AT_Syn_Deal_Rights_Blackout] FOREIGN KEY ([AT_Syn_Deal_Rights_Blackout_Code]) REFERENCES [dbo].[AT_Syn_Deal_Rights_Blackout] ([AT_Syn_Deal_Rights_Blackout_Code]),
    CONSTRAINT [FK_AT_Syn_Deal_Rights_Blackout_Dubbing_Language] FOREIGN KEY ([Language_Code]) REFERENCES [dbo].[Language] ([Language_Code])
);

