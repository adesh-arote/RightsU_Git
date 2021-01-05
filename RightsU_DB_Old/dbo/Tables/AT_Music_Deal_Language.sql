CREATE TABLE [dbo].[AT_Music_Deal_Language] (
    [AT_Music_Deal_Language_Code] INT IDENTITY (1, 1) NOT NULL,
    [AT_Music_Deal_Code]          INT NULL,
    [Music_Language_Code]         INT NULL,
    [Music_Deal_Language_Code]    INT NULL,
    CONSTRAINT [PK_AT_Music_Deal_Language] PRIMARY KEY CLUSTERED ([AT_Music_Deal_Language_Code] ASC),
    CONSTRAINT [FK_AT_Music_Deal_Language_AT_Music_Deal] FOREIGN KEY ([AT_Music_Deal_Code]) REFERENCES [dbo].[AT_Music_Deal] ([AT_Music_Deal_Code]),
    CONSTRAINT [FK_AT_Music_Deal_Language_Music_Language] FOREIGN KEY ([Music_Language_Code]) REFERENCES [dbo].[Music_Language] ([Music_Language_Code])
);

