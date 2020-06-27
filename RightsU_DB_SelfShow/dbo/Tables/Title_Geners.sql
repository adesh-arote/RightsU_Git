CREATE TABLE [dbo].[Title_Geners] (
    [Title_Geners_Code] INT IDENTITY (1, 1) NOT NULL,
    [Title_Code]        INT NULL,
    [Genres_Code]       INT NULL,
    CONSTRAINT [PK_Title_Geners] PRIMARY KEY CLUSTERED ([Title_Geners_Code] ASC)
);

