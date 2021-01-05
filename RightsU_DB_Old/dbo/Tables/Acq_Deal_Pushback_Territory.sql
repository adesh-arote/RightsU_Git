CREATE TABLE [dbo].[Acq_Deal_Pushback_Territory] (
    [Acq_Deal_Pushback_Territory_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Pushback_Code]           INT      NULL,
    [Territory_Type]                   CHAR (1) NULL,
    [Country_Code]                     INT      NULL,
    [Territory_Code]                   INT      NULL,
    CONSTRAINT [PK_Acq_Deal_Pushback_Territory] PRIMARY KEY CLUSTERED ([Acq_Deal_Pushback_Territory_Code] ASC),
    CONSTRAINT [FK_Acq_Deal_Pushback_Territory_Acq_Deal_Pushback] FOREIGN KEY ([Acq_Deal_Pushback_Code]) REFERENCES [dbo].[Acq_Deal_Pushback] ([Acq_Deal_Pushback_Code]),
    CONSTRAINT [FK_Acq_Deal_Pushback_Territory_Country] FOREIGN KEY ([Country_Code]) REFERENCES [dbo].[Country] ([Country_Code]),
    CONSTRAINT [FK_Acq_Deal_Pushback_Territory_Territory] FOREIGN KEY ([Territory_Code]) REFERENCES [dbo].[Territory] ([Territory_Code])
);


GO
CREATE NONCLUSTERED INDEX [IX_Acq_Deal_Pushback_Territory_1]
    ON [dbo].[Acq_Deal_Pushback_Territory]([Acq_Deal_Pushback_Code] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Acq_Deal_Pushback_Territory_2]
    ON [dbo].[Acq_Deal_Pushback_Territory]([Country_Code] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Acq_Deal_Pushback_Territory_3]
    ON [dbo].[Acq_Deal_Pushback_Territory]([Territory_Code] ASC);

