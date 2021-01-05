CREATE TABLE [dbo].[AT_Acq_Deal_Rights_Title_EPS] (
    [AT_Acq_Deal_Rights_Title_EPS_Code] INT IDENTITY (1, 1) NOT NULL,
    [AT_Acq_Deal_Rights_Title_Code]     INT NULL,
    [EPS_No]                            INT NULL,
    [Acq_Deal_Rights_Title_EPS_Code]    INT NULL,
    CONSTRAINT [PK_AT_Acq_Deal_Rights_Title_EPS] PRIMARY KEY CLUSTERED ([AT_Acq_Deal_Rights_Title_EPS_Code] ASC)
);

