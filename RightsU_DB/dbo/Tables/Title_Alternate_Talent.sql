CREATE TABLE [dbo].[Title_Alternate_Talent] (
    [Title_Alternate_Talent_Code] INT IDENTITY (1, 1) NOT NULL,
    [Title_Alternate_Code]        INT NULL,
    [Talent_Code]                 INT NULL,
    [Role_Code]                   INT NULL,
    CONSTRAINT [PK_Title_Alternate_Talent] PRIMARY KEY CLUSTERED ([Title_Alternate_Talent_Code] ASC),
    CONSTRAINT [FK_Title_Alternate_Talent_Role] FOREIGN KEY ([Role_Code]) REFERENCES [dbo].[Role] ([Role_Code]),
    CONSTRAINT [FK_Title_Alternate_Talent_Talent] FOREIGN KEY ([Talent_Code]) REFERENCES [dbo].[Talent] ([Talent_Code]),
    CONSTRAINT [FK_Title_Alternate_Talent_Title_Alternate] FOREIGN KEY ([Title_Alternate_Code]) REFERENCES [dbo].[Title_Alternate] ([Title_Alternate_Code])
);

