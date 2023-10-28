CREATE TABLE [dbo].[Title_Objection_Platform] (
    [Title_Objection_Platform_Code] INT IDENTITY (1, 1) NOT NULL,
    [Title_Objection_Code]          INT NULL,
    [Platform_Code]                 INT NULL,
    PRIMARY KEY CLUSTERED ([Title_Objection_Platform_Code] ASC),
    CONSTRAINT [FK_Title_Objection_Platform_Title_Objection] FOREIGN KEY ([Title_Objection_Code]) REFERENCES [dbo].[Title_Objection] ([Title_Objection_Code])
);

