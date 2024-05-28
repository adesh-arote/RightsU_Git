CREATE TABLE [dbo].[AT_Syn_Deal_Digital] (
    [AT_Syn_Deal_Digital_Code] INT           IDENTITY (1, 1) NOT NULL,
    [AT_Syn_Deal_Code]         INT           NULL,
    [Title_code]               INT           NULL,
    [Episode_From]             INT           NULL,
    [Episode_To]               INT           NULL,
    [Remarks]                  VARCHAR (MAX) NULL,
    [Syn_Deal_Digital_Code]    INT           NULL,
    CONSTRAINT [PK_AT_Syn_Deal_Digital] PRIMARY KEY CLUSTERED ([AT_Syn_Deal_Digital_Code] ASC),
    CONSTRAINT [FK_AT_Syn_Deal_Digital_AT_Syn_Deal] FOREIGN KEY ([AT_Syn_Deal_Code]) REFERENCES [dbo].[AT_Syn_Deal] ([AT_Syn_Deal_Code]),
    CONSTRAINT [FK_AT_Syn_Deal_Digital_Title] FOREIGN KEY ([Title_code]) REFERENCES [dbo].[Title] ([Title_Code])
);

