CREATE TABLE [dbo].[Title_Alternate_Genres] (
    [Title_Alternate_Genres_Code] INT IDENTITY (1, 1) NOT NULL,
    [Title_Alternate_Code]        INT NULL,
    [Genres_Code]                 INT NULL,
    CONSTRAINT [PK_Title_Alternate_Genres] PRIMARY KEY CLUSTERED ([Title_Alternate_Genres_Code] ASC),
    CONSTRAINT [FK_Title_Alternate_Genres_Genres] FOREIGN KEY ([Genres_Code]) REFERENCES [dbo].[Genres] ([Genres_Code]),
    CONSTRAINT [FK_Title_Alternate_Genres_Title_Alternate] FOREIGN KEY ([Title_Alternate_Code]) REFERENCES [dbo].[Title_Alternate] ([Title_Alternate_Code])
);

