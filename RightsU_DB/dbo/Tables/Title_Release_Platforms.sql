CREATE TABLE [dbo].[Title_Release_Platforms] (
    [Title_Release_Platforms_Code] INT IDENTITY (1, 1) NOT NULL,
    [Title_Release_Code]           INT NULL,
    [Platform_Code]                INT NULL,
    CONSTRAINT [PK_Title_Release_Platforms] PRIMARY KEY CLUSTERED ([Title_Release_Platforms_Code] ASC),
    CONSTRAINT [FK_Title_Release_Platforms_Platform] FOREIGN KEY ([Platform_Code]) REFERENCES [dbo].[Platform] ([Platform_Code]),
    CONSTRAINT [FK_Title_Release_Platforms_Title_Release] FOREIGN KEY ([Title_Release_Code]) REFERENCES [dbo].[Title_Release] ([Title_Release_Code])
);

