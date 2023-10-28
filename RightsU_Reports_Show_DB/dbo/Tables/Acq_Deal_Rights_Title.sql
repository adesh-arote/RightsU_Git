CREATE TABLE [dbo].[Acq_Deal_Rights_Title] (
    [Acq_Deal_Rights_Title_Code] INT IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Rights_Code]       INT NULL,
    [Title_Code]                 INT NULL,
    [Episode_From]               INT NULL,
    [Episode_To]                 INT NULL,
    CONSTRAINT [PK_Acq_Deal_Rights_Title] PRIMARY KEY CLUSTERED ([Acq_Deal_Rights_Title_Code] ASC)
);




GO



GO



GO


