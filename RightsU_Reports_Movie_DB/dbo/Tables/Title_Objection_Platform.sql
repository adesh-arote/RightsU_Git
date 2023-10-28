CREATE TABLE [dbo].[Title_Objection_Platform] (
    [Title_Objection_Platform_Code] INT IDENTITY (1, 1) NOT NULL,
    [Title_Objection_Code]          INT NULL,
    [Platform_Code]                 INT NULL,
    CONSTRAINT [PK_Title_Objection_Platform] PRIMARY KEY CLUSTERED ([Title_Objection_Platform_Code] ASC)
);

