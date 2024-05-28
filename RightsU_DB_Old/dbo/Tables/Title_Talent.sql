CREATE TABLE [dbo].[Title_Talent] (
    [Title_Talent_Code] INT IDENTITY (1, 1) NOT NULL,
    [Title_Code]        INT NULL,
    [Talent_Code]       INT NULL,
    [Role_Code]         INT NULL,
    CONSTRAINT [PK_Title_Star] PRIMARY KEY CLUSTERED ([Title_Talent_Code] ASC),
    CONSTRAINT [FK_Title_Star_Talent] FOREIGN KEY ([Role_Code]) REFERENCES [dbo].[Role] ([Role_Code]),
    CONSTRAINT [FK_Title_Talent_Talent] FOREIGN KEY ([Talent_Code]) REFERENCES [dbo].[Talent] ([Talent_Code]),
    CONSTRAINT [FK_Title_Talent_Title] FOREIGN KEY ([Title_Code]) REFERENCES [dbo].[Title] ([Title_Code])
);

