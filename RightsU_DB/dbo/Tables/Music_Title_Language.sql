CREATE TABLE [dbo].[Music_Title_Language] (
    [Music_Title_Language_Code] INT IDENTITY (1, 1) NOT NULL,
    [Music_Title_Code]          INT NULL,
    [Music_Language_Code]       INT NULL,
    CONSTRAINT [PK_Music_Title_Language] PRIMARY KEY CLUSTERED ([Music_Title_Language_Code] ASC),
    CONSTRAINT [FK_Music_Title_Language_Music_Language] FOREIGN KEY ([Music_Language_Code]) REFERENCES [dbo].[Music_Language] ([Music_Language_Code]),
    CONSTRAINT [FK_Music_Title_Language_Music_Title] FOREIGN KEY ([Music_Title_Code]) REFERENCES [dbo].[Music_Title] ([Music_Title_Code])
);

