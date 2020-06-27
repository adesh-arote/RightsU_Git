CREATE TABLE [dbo].[AT_Syn_Deal_Rights_Blackout_Territory] (
    [AT_Syn_Deal_Rights_Blackout_Territory_Code] INT      IDENTITY (1, 1) NOT NULL,
    [AT_Syn_Deal_Rights_Blackout_Code]           INT      NULL,
    [Territory_Type]                             CHAR (1) NULL,
    [Country_Code]                               INT      NULL,
    [Territory_Code]                             INT      NULL,
    [Syn_Deal_Rights_Blackout_Territory_Code]    INT      NULL,
    CONSTRAINT [PK_AT_Syn_Deal_Rights_Blackout_Territory] PRIMARY KEY CLUSTERED ([AT_Syn_Deal_Rights_Blackout_Territory_Code] ASC),
    CONSTRAINT [FK_AT_Syn_Deal_Rights_Blackout_Territory_AT_Syn_Deal_Rights_Blackout] FOREIGN KEY ([AT_Syn_Deal_Rights_Blackout_Code]) REFERENCES [dbo].[AT_Syn_Deal_Rights_Blackout] ([AT_Syn_Deal_Rights_Blackout_Code]),
    CONSTRAINT [FK_AT_Syn_Deal_Rights_Blackout_Territory_Country] FOREIGN KEY ([Country_Code]) REFERENCES [dbo].[Country] ([Country_Code]),
    CONSTRAINT [FK_AT_Syn_Deal_Rights_Blackout_Territory_Territory] FOREIGN KEY ([Territory_Code]) REFERENCES [dbo].[Territory] ([Territory_Code])
);

