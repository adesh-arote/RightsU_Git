CREATE TABLE [dbo].[Acq_Deal_Rights_Territory] (
    [Acq_Deal_Rights_Territory_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Rights_Code]           INT      NULL,
    [Territory_Type]                 CHAR (1) NULL,
    [Country_Code]                   INT      NULL,
    [Territory_Code]                 INT      NULL,
    CONSTRAINT [PK_Acq_Deal_Rights_Territory] PRIMARY KEY CLUSTERED ([Acq_Deal_Rights_Territory_Code] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_Acq_Deal_Rights_Territory]
    ON [dbo].[Acq_Deal_Rights_Territory]([Acq_Deal_Rights_Code] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Acq_Deal_Rights_Territory_1]
    ON [dbo].[Acq_Deal_Rights_Territory]([Country_Code] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Acq_Deal_Rights_Territory_2]
    ON [dbo].[Acq_Deal_Rights_Territory]([Acq_Deal_Rights_Code] ASC, [Country_Code] ASC);

