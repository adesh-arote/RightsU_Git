CREATE TABLE [dbo].[AT_Syn_Deal_Rights_Title_EPS] (
    [AT_Syn_Deal_Rights_Title_EPS_Code] INT IDENTITY (1, 1) NOT NULL,
    [AT_Syn_Deal_Rights_Title_Code]     INT NULL,
    [EPS_No]                            INT NULL,
    [Syn_Deal_Rights_Title_EPS_Code]    INT NULL,
    CONSTRAINT [PK_AT_Syn_Deal_Rights_Title_EPS] PRIMARY KEY CLUSTERED ([AT_Syn_Deal_Rights_Title_EPS_Code] ASC)
);

