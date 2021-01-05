CREATE TABLE [dbo].[Content_Category] (
    [Content_Category_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Content_Category_Name] NVARCHAR (100) NULL,
    CONSTRAINT [PK_Content_Category] PRIMARY KEY CLUSTERED ([Content_Category_Code] ASC)
);

