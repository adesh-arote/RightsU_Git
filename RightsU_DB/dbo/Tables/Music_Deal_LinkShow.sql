CREATE TABLE [dbo].[Music_Deal_LinkShow] (
    [Music_Deal_LinkShow_Code] INT IDENTITY (1, 1) NOT NULL,
    [Music_Deal_Code]          INT NULL,
    [Title_Code]               INT NULL,
    CONSTRAINT [PK_Music_Deal_LinkShow] PRIMARY KEY CLUSTERED ([Music_Deal_LinkShow_Code] ASC),
    CONSTRAINT [FK_Music_Deal_LinkShow_Music_Deal] FOREIGN KEY ([Music_Deal_Code]) REFERENCES [dbo].[Music_Deal] ([Music_Deal_Code]),
    CONSTRAINT [FK_Music_Deal_LinkShow_Title] FOREIGN KEY ([Title_Code]) REFERENCES [dbo].[Title] ([Title_Code])
);

