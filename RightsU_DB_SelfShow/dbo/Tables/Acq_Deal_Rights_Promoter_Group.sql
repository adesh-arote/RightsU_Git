CREATE TABLE [dbo].[Acq_Deal_Rights_Promoter_Group] (
    [Acq_Deal_Rights_Promoter_Group_Code] INT IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Rights_Promoter_Code]       INT NULL,
    [Promoter_Group_Code]                 INT NULL,
    CONSTRAINT [PK_Acq_Deal_Rights_Promoter_Group_Code] PRIMARY KEY CLUSTERED ([Acq_Deal_Rights_Promoter_Group_Code] ASC)
);

