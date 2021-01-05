CREATE TABLE [dbo].[Music_Deal_Country] (
    [Music_Deal_Country_Code] INT IDENTITY (1, 1) NOT NULL,
    [Music_Deal_Code]         INT NULL,
    [Country_Code]            INT NULL,
    CONSTRAINT [PK_Music_Deal_Country] PRIMARY KEY CLUSTERED ([Music_Deal_Country_Code] ASC),
    CONSTRAINT [FK_Music_Deal_Country_Country] FOREIGN KEY ([Country_Code]) REFERENCES [dbo].[Country] ([Country_Code]),
    CONSTRAINT [FK_Music_Deal_Country_Music_Deal] FOREIGN KEY ([Music_Deal_Code]) REFERENCES [dbo].[Music_Deal] ([Music_Deal_Code])
);

