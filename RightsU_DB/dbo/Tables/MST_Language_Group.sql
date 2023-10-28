CREATE TABLE [dbo].[MST_Language_Group] (
    [Language_Group_Id]   INT            IDENTITY (1, 1) NOT NULL,
    [Language_Group_Name] NVARCHAR (100) NULL,
    CONSTRAINT [PK_MST_Language_Group] PRIMARY KEY CLUSTERED ([Language_Group_Id] ASC)
);

