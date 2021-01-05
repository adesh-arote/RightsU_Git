CREATE TABLE [dbo].[AT_Acq_Deal_Rights_Promoter_Group] (
    [AT_Acq_Deal_Rights_Promoter_Group_Code] INT IDENTITY (1, 1) NOT NULL,
    [AT_Acq_Deal_Rights_Promoter_Code]       INT NULL,
    [Promoter_Group_Code]                    INT NULL,
    [Acq_Deal_Rights_Promoter_Group_Code]    INT NULL,
    PRIMARY KEY CLUSTERED ([AT_Acq_Deal_Rights_Promoter_Group_Code] ASC)
);

