﻿CREATE TABLE [dbo].[Syn_Deal_Movie] (
    [Syn_Deal_Movie_Code] INT             IDENTITY (1, 1) NOT NULL,
    [Syn_Deal_Code]       INT             NULL,
    [Title_Code]          INT             NULL,
    [No_Of_Episode]       INT             NULL,
    [Is_Closed]           CHAR (1)        NULL,
    [Syn_Title_Type]      CHAR (1)        NULL,
    [Remark]              NVARCHAR (4000) NULL,
    [Episode_End_To]      INT             NULL,
    [Episode_From]        INT             NULL,
    CONSTRAINT [PK_Syn_Deal_Movie] PRIMARY KEY CLUSTERED ([Syn_Deal_Movie_Code] ASC),
    CONSTRAINT [FK_Syn_Deal_Movie_Syn_Deal] FOREIGN KEY ([Syn_Deal_Code]) REFERENCES [dbo].[Syn_Deal] ([Syn_Deal_Code]),
    CONSTRAINT [FK_Syn_Deal_Movie_Title] FOREIGN KEY ([Title_Code]) REFERENCES [dbo].[Title] ([Title_Code])
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'P-Premier L-Library', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Syn_Deal_Movie', @level2type = N'COLUMN', @level2name = N'Syn_Title_Type';

