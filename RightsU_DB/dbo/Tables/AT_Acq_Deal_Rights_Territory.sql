CREATE TABLE [dbo].[AT_Acq_Deal_Rights_Territory] (
    [AT_Acq_Deal_Rights_Territory_Code] INT      IDENTITY (1, 1) NOT NULL,
    [AT_Acq_Deal_Rights_Code]           INT      NULL,
    [Territory_Type]                    CHAR (1) NULL,
    [Country_Code]                      INT      NULL,
    [Territory_Code]                    INT      NULL,
    [Acq_Deal_Rights_Territory_Code]    INT      NULL,
    CONSTRAINT [PK_AT_Acq_Deal_Rights_Territory] PRIMARY KEY CLUSTERED ([AT_Acq_Deal_Rights_Territory_Code] ASC),
    CONSTRAINT [FK_AT_Acq_Deal_Rights_Territory_AT_Acq_Deal_Rights] FOREIGN KEY ([AT_Acq_Deal_Rights_Code]) REFERENCES [dbo].[AT_Acq_Deal_Rights] ([AT_Acq_Deal_Rights_Code]),
    CONSTRAINT [FK_AT_Acq_Deal_Rights_Territory_Country] FOREIGN KEY ([Country_Code]) REFERENCES [dbo].[Country] ([Country_Code]),
    CONSTRAINT [FK_AT_Acq_Deal_Rights_Territory_Territory] FOREIGN KEY ([Territory_Code]) REFERENCES [dbo].[Territory] ([Territory_Code])
);

