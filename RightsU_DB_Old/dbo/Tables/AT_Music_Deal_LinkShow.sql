CREATE TABLE [dbo].[AT_Music_Deal_LinkShow] (
    [AT_Music_Deal_LinkShow_Code] INT IDENTITY (1, 1) NOT NULL,
    [AT_Music_Deal_Code]          INT NULL,
    [Title_Code]                  INT NULL,
    [Music_Deal_LinkShow_Code]    INT NULL,
    CONSTRAINT [PK_AT_Music_Deal_LinkShow] PRIMARY KEY CLUSTERED ([AT_Music_Deal_LinkShow_Code] ASC),
    CONSTRAINT [FK_AT_Music_Deal_LinkShow_AT_Music_Deal] FOREIGN KEY ([AT_Music_Deal_Code]) REFERENCES [dbo].[AT_Music_Deal] ([AT_Music_Deal_Code]),
    CONSTRAINT [FK_AT_Music_Deal_LinkShow_Title] FOREIGN KEY ([Title_Code]) REFERENCES [dbo].[Title] ([Title_Code])
);

