CREATE TABLE [dbo].[MST_Language] (
    [Language_Id]       INT            IDENTITY (1, 1) NOT NULL,
    [Language_Name]     NVARCHAR (MAX) NULL,
    [Language_Group_Id] INT            NULL,
    CONSTRAINT [PK_MST_Language] PRIMARY KEY CLUSTERED ([Language_Id] ASC),
    CONSTRAINT [FK_MST_Language_MST_Language_Group] FOREIGN KEY ([Language_Group_Id]) REFERENCES [dbo].[MST_Language_Group] ([Language_Group_Id])
);

