CREATE TABLE [dbo].[AT_Acq_Deal_Supplementary] (
    [AT_Acq_Deal_Supplementary_Code] INT           IDENTITY (1, 1) NOT NULL,
    [AT_Acq_Deal_Code]               INT           NULL,
    [Title_code]                     INT           NULL,
    [Episode_From]                   INT           NULL,
    [Episode_To]                     INT           NULL,
    [Remarks]                        VARCHAR (MAX) NULL,
    [Acq_Deal_Supplementary_Code]    INT           NULL,
    CONSTRAINT [PK_AT_Acq_Deal_Supplementary] PRIMARY KEY CLUSTERED ([AT_Acq_Deal_Supplementary_Code] ASC)
);

