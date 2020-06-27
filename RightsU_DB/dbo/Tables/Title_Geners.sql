CREATE TABLE [dbo].[Title_Geners] (
    [Title_Geners_Code] INT IDENTITY (1, 1) NOT NULL,
    [Title_Code]        INT NULL,
    [Genres_Code]       INT NULL,
    CONSTRAINT [PK_Title_Geners] PRIMARY KEY CLUSTERED ([Title_Geners_Code] ASC),
    CONSTRAINT [FK_Title_Geners_Genres] FOREIGN KEY ([Genres_Code]) REFERENCES [dbo].[Genres] ([Genres_Code]),
    CONSTRAINT [FK_Title_Geners_Title] FOREIGN KEY ([Title_Code]) REFERENCES [dbo].[Title] ([Title_Code])
);

