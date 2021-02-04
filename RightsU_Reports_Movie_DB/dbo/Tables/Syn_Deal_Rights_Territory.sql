CREATE TABLE [dbo].[Syn_Deal_Rights_Territory] (
    [Syn_Deal_Rights_Territory_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Syn_Deal_Rights_Code]           INT      NULL,
    [Territory_Type]                 CHAR (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Country_Code]                   INT      NULL,
    [Territory_Code]                 INT      NULL,
    CONSTRAINT [PK_Syn_Deal_Rights_Territory] PRIMARY KEY CLUSTERED ([Syn_Deal_Rights_Territory_Code] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_Syn_Deal_Rights_Territory]
    ON [dbo].[Syn_Deal_Rights_Territory]([Syn_Deal_Rights_Code] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Syn_Deal_Rights_Territory_1]
    ON [dbo].[Syn_Deal_Rights_Territory]([Country_Code] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Syn_Deal_Rights_Territory_2]
    ON [dbo].[Syn_Deal_Rights_Territory]([Syn_Deal_Rights_Code] ASC, [Country_Code] ASC);

