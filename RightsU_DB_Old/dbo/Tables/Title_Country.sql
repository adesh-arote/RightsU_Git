CREATE TABLE [dbo].[Title_Country] (
    [Title_Country_Code] INT IDENTITY (1, 1) NOT NULL,
    [Title_Code]         INT NULL,
    [Country_Code]       INT NULL,
    CONSTRAINT [PK_Title_Country] PRIMARY KEY CLUSTERED ([Title_Country_Code] ASC),
    CONSTRAINT [FK_Title_Country_Country] FOREIGN KEY ([Country_Code]) REFERENCES [dbo].[Country] ([Country_Code]),
    CONSTRAINT [FK_Title_Country_Title] FOREIGN KEY ([Title_Code]) REFERENCES [dbo].[Title] ([Title_Code])
);

