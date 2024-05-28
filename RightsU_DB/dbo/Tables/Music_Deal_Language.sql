CREATE TABLE [dbo].[Music_Deal_Language] (
    [Music_Deal_Language_Code] INT IDENTITY (1, 1) NOT NULL,
    [Music_Deal_Code]          INT NULL,
    [Music_Language_Code]      INT NULL,
    CONSTRAINT [PK_Music_Deal_Language] PRIMARY KEY CLUSTERED ([Music_Deal_Language_Code] ASC),
    CONSTRAINT [FK_Music_Deal_Language_Music_Deal] FOREIGN KEY ([Music_Deal_Code]) REFERENCES [dbo].[Music_Deal] ([Music_Deal_Code]),
    CONSTRAINT [FK_Music_Deal_Language_Music_Language] FOREIGN KEY ([Music_Language_Code]) REFERENCES [dbo].[Music_Language] ([Music_Language_Code])
);

