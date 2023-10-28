CREATE TABLE [dbo].[Syn_Deal_Supplementary] (
    [Syn_Deal_Supplementary_Code] INT           IDENTITY (1, 1) NOT NULL,
    [Syn_Deal_Code]               INT           NULL,
    [Title_code]                  INT           NULL,
    [Episode_From]                INT           NULL,
    [Episode_To]                  INT           NULL,
    [Remarks]                     VARCHAR (MAX) NULL,
    CONSTRAINT [PK_Syn_Deal_Supplementary] PRIMARY KEY CLUSTERED ([Syn_Deal_Supplementary_Code] ASC),
    CONSTRAINT [FK_Syn_Deal_Supplementary_Syn_Deal] FOREIGN KEY ([Syn_Deal_Code]) REFERENCES [dbo].[Syn_Deal] ([Syn_Deal_Code]),
    CONSTRAINT [FK_Syn_Deal_Supplementary_Title] FOREIGN KEY ([Title_code]) REFERENCES [dbo].[Title] ([Title_Code])
);

