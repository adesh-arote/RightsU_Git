CREATE TABLE [dbo].[Syn_Deal_Rights_Territory] (
    [Syn_Deal_Rights_Territory_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Syn_Deal_Rights_Code]           INT      NULL,
    [Territory_Type]                 CHAR (1) NULL,
    [Country_Code]                   INT      NULL,
    [Territory_Code]                 INT      NULL,
    CONSTRAINT [PK_Syn_Deal_Rights_Territory] PRIMARY KEY CLUSTERED ([Syn_Deal_Rights_Territory_Code] ASC)
);




GO



GO



GO


