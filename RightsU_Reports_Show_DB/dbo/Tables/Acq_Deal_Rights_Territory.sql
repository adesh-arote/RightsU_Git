CREATE TABLE [dbo].[Acq_Deal_Rights_Territory] (
    [Acq_Deal_Rights_Territory_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Rights_Code]           INT      NULL,
    [Territory_Type]                 CHAR (1) NULL,
    [Country_Code]                   INT      NULL,
    [Territory_Code]                 INT      NULL,
    CONSTRAINT [PK_Acq_Deal_Rights_Territory] PRIMARY KEY CLUSTERED ([Acq_Deal_Rights_Territory_Code] ASC)
);




GO



GO



GO


