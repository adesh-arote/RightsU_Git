CREATE TABLE [dbo].[Acq_Deal_Rights_Promoter_Group] (
    [Acq_Deal_Rights_Promoter_Group_Code] INT IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Rights_Promoter_Code]       INT NULL,
    [Promoter_Group_Code]                 INT NULL,
    PRIMARY KEY CLUSTERED ([Acq_Deal_Rights_Promoter_Group_Code] ASC),
    FOREIGN KEY ([Acq_Deal_Rights_Promoter_Code]) REFERENCES [dbo].[Acq_Deal_Rights_Promoter] ([Acq_Deal_Rights_Promoter_Code]),
    CONSTRAINT [FK__Acq_Deal___Promo__0333E042] FOREIGN KEY ([Promoter_Group_Code]) REFERENCES [dbo].[Promoter_Group] ([Promoter_Group_Code])
);



