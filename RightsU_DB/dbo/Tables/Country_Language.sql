CREATE TABLE [dbo].[Country_Language] (
    [Country_Language_Code] INT IDENTITY (1, 1) NOT NULL,
    [Country_Code]          INT NULL,
    [Language_Code]         INT NULL,
    CONSTRAINT [PK_Country_Language] PRIMARY KEY CLUSTERED ([Country_Language_Code] ASC),
    CONSTRAINT [FK_Country_Language_Country] FOREIGN KEY ([Country_Code]) REFERENCES [dbo].[Country] ([Country_Code]),
    CONSTRAINT [FK_Country_Language_Language] FOREIGN KEY ([Language_Code]) REFERENCES [dbo].[Language] ([Language_Code])
);

