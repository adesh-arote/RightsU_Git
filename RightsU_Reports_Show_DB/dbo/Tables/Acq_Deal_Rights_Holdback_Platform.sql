CREATE TABLE [dbo].[Acq_Deal_Rights_Holdback_Platform] (
    [Acq_Deal_Rights_Holdback_Platform_Code] INT IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Rights_Holdback_Code]          INT NULL,
    [Platform_Code]                          INT NULL,
    CONSTRAINT [PK_Acq_Deal_Rights_Holdback_Platform] PRIMARY KEY CLUSTERED ([Acq_Deal_Rights_Holdback_Platform_Code] ASC)
);

