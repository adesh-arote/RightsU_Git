CREATE TABLE [dbo].[Acq_Deal_Supplementary] (
    [Acq_Deal_Supplementary_Code] INT           IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Code]               INT           NULL,
    [Title_code]                  INT           NULL,
    [Episode_From]                INT           NULL,
    [Episode_To]                  INT           NULL,
    [Remarks]                     VARCHAR (MAX) NULL,
    CONSTRAINT [PK_Acq_Deal_Supplementary] PRIMARY KEY CLUSTERED ([Acq_Deal_Supplementary_Code] ASC),
    CONSTRAINT [FK_Acq_Deal_Supplementary_Acq_Deal] FOREIGN KEY ([Acq_Deal_Code]) REFERENCES [dbo].[Acq_Deal] ([Acq_Deal_Code]),
    CONSTRAINT [FK_Acq_Deal_Supplementary_Title] FOREIGN KEY ([Title_code]) REFERENCES [dbo].[Title] ([Title_Code])
);

