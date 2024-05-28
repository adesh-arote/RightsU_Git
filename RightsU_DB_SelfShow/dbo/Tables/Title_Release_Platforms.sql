CREATE TABLE [dbo].[Title_Release_Platforms] (
    [Title_Release_Platforms_Code] INT IDENTITY (1, 1) NOT NULL,
    [Title_Release_Code]           INT NULL,
    [Platform_Code]                INT NULL,
    CONSTRAINT [PK_Title_Release_Platforms] PRIMARY KEY CLUSTERED ([Title_Release_Platforms_Code] ASC)
);

