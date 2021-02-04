CREATE TABLE [dbo].[Acq_Deal_Rights_Holdback_Territory] (
    [Acq_Deal_Rights_Holdback_Territory_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Rights_Holdback_Code]           INT      NULL,
    [Territory_Type]                          CHAR (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Country_Code]                            INT      NULL,
    [Territory_Code]                          INT      NULL,
    CONSTRAINT [PK_Acq_Deal_Rights_HoldBack_Territory] PRIMARY KEY CLUSTERED ([Acq_Deal_Rights_Holdback_Territory_Code] ASC)
);

