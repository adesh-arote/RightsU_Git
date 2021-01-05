CREATE TABLE [dbo].[Title_Alternate_Country] (
    [Title_Alternate_Country_Code] INT IDENTITY (1, 1) NOT NULL,
    [Title_Alternate_Code]         INT NULL,
    [Country_Code]                 INT NULL,
    CONSTRAINT [PK_Title_Alternate_Country] PRIMARY KEY CLUSTERED ([Title_Alternate_Country_Code] ASC),
    CONSTRAINT [FK_Title_Alternate_Country_Country] FOREIGN KEY ([Country_Code]) REFERENCES [dbo].[Country] ([Country_Code]),
    CONSTRAINT [FK_Title_Alternate_Country_Title_Alternate] FOREIGN KEY ([Title_Alternate_Code]) REFERENCES [dbo].[Title_Alternate] ([Title_Alternate_Code])
);

