CREATE TABLE [dbo].[Syn_Deal_Rights_Dubbing] (
    [Syn_Deal_Rights_Dubbing_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Syn_Deal_Rights_Code]         INT      NULL,
    [Language_Type]                CHAR (1) NULL,
    [Language_Code]                INT      NULL,
    [Language_Group_Code]          INT      NULL,
    CONSTRAINT [PK_Syn_Deal_Rights_Dubbing] PRIMARY KEY CLUSTERED ([Syn_Deal_Rights_Dubbing_Code] ASC)
);




GO



GO



GO


