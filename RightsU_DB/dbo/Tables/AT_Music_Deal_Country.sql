CREATE TABLE [dbo].[AT_Music_Deal_Country] (
    [AT_Music_Deal_Country_Code] INT IDENTITY (1, 1) NOT NULL,
    [AT_Music_Deal_Code]         INT NULL,
    [Country_Code]               INT NULL,
    [Music_Deal_Country_Code]    INT NULL,
    CONSTRAINT [PK_AT_Music_Deal_Country] PRIMARY KEY CLUSTERED ([AT_Music_Deal_Country_Code] ASC),
    CONSTRAINT [FK_AT_Music_Deal_Country_AT_Music_Deal] FOREIGN KEY ([AT_Music_Deal_Code]) REFERENCES [dbo].[AT_Music_Deal] ([AT_Music_Deal_Code]),
    CONSTRAINT [FK_AT_Music_Deal_Country_Country] FOREIGN KEY ([Country_Code]) REFERENCES [dbo].[Country] ([Country_Code])
);

