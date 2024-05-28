CREATE TABLE [dbo].[Music_Title_Theme] (
    [Music_Title_Theme_Code] INT IDENTITY (1, 1) NOT NULL,
    [Music_Title_Code]       INT NULL,
    [Music_Theme_Code]       INT NULL,
    CONSTRAINT [PK_Music_Title_Theme] PRIMARY KEY CLUSTERED ([Music_Title_Theme_Code] ASC),
    CONSTRAINT [FK_Music_Title_Theme_Music_Theme] FOREIGN KEY ([Music_Theme_Code]) REFERENCES [dbo].[Music_Theme] ([Music_Theme_Code]),
    CONSTRAINT [FK_Music_Title_Theme_Music_Title] FOREIGN KEY ([Music_Title_Code]) REFERENCES [dbo].[Music_Title] ([Music_Title_Code])
);

