CREATE TABLE [dbo].[Syn_Deal_Rights_Title_EPS] (
    [Syn_Deal_Rights_Title_EPS_Code] INT IDENTITY (1, 1) NOT NULL,
    [Syn_Deal_Rights_Title_Code]     INT NULL,
    [EPS_No]                         INT NULL,
    CONSTRAINT [PK_Syn_Deal_Rights_Title_EPS] PRIMARY KEY CLUSTERED ([Syn_Deal_Rights_Title_EPS_Code] ASC)
);

