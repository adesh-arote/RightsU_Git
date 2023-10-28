CREATE TABLE [dbo].[Acq_Deal_Rights_Subtitling] (
    [Acq_Deal_Rights_Subtitling_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Rights_Code]            INT      NULL,
    [Language_Type]                   CHAR (1) NULL,
    [Language_Code]                   INT      NULL,
    [Language_Group_Code]             INT      NULL,
    CONSTRAINT [PK_Acq_Deal_Rights_Subtitling] PRIMARY KEY CLUSTERED ([Acq_Deal_Rights_Subtitling_Code] ASC)
);




GO



GO



GO


