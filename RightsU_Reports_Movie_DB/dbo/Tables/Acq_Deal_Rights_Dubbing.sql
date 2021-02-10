CREATE TABLE [dbo].[Acq_Deal_Rights_Dubbing] (
    [Acq_Deal_Rights_Dubbing_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Rights_Code]         INT      NULL,
    [Language_Type]                CHAR (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Language_Code]                INT      NULL,
    [Language_Group_Code]          INT      NULL,
    CONSTRAINT [PK_Acq_Deal_Rights_Dubbing] PRIMARY KEY CLUSTERED ([Acq_Deal_Rights_Dubbing_Code] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_Acq_Deal_Rights_Dubbing]
    ON [dbo].[Acq_Deal_Rights_Dubbing]([Acq_Deal_Rights_Code] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Acq_Deal_Rights_Dubbing_1]
    ON [dbo].[Acq_Deal_Rights_Dubbing]([Language_Code] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Acq_Deal_Rights_Dubbing_2]
    ON [dbo].[Acq_Deal_Rights_Dubbing]([Acq_Deal_Rights_Code] ASC, [Language_Code] ASC);

