CREATE TABLE [dbo].[Title_Talent] (
    [Title_Talent_Code] INT IDENTITY (1, 1) NOT NULL,
    [Title_Code]        INT NULL,
    [Talent_Code]       INT NULL,
    [Role_Code]         INT NULL,
    CONSTRAINT [PK_Title_Star] PRIMARY KEY CLUSTERED ([Title_Talent_Code] ASC)
);

