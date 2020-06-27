CREATE TABLE [dbo].[Title_Audio_Details] (
    [Title_Audio_Details_Code] INT           IDENTITY (1, 1) NOT NULL,
    [Title_Code]               INT           NULL,
    [Song_Name]                VARCHAR (500) NULL,
    [Movie_Name]               VARCHAR (500) NULL,
    [Duration]                 INT           NULL,
    [Language_Code]            INT           NULL,
    [Geners_Code]              INT           NULL,
    CONSTRAINT [PK_Title_Audio_Details] PRIMARY KEY CLUSTERED ([Title_Audio_Details_Code] ASC),
    CONSTRAINT [FK_Title_Audio_Details_Title1] FOREIGN KEY ([Title_Code]) REFERENCES [dbo].[Title] ([Title_Code])
);

