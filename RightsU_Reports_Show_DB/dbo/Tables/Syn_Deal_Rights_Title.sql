CREATE TABLE [dbo].[Syn_Deal_Rights_Title] (
    [Syn_Deal_Rights_Title_Code] INT IDENTITY (1, 1) NOT NULL,
    [Syn_Deal_Rights_Code]       INT NULL,
    [Title_Code]                 INT NULL,
    [Episode_From]               INT NULL,
    [Episode_To]                 INT NULL,
    CONSTRAINT [PK_Syn_Deal_Rights_Title] PRIMARY KEY CLUSTERED ([Syn_Deal_Rights_Title_Code] ASC)
);




GO



GO



GO


