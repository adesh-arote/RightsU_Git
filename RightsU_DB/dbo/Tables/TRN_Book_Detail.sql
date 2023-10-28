CREATE TABLE [dbo].[TRN_Book_Detail] (
    [Book_Detail_Id]    INT            IDENTITY (1, 1) NOT NULL,
    [Book_Unique_Id]    NVARCHAR (50)  NULL,
    [Book_Name]         NVARCHAR (MAX) NULL,
    [Book_Description]  NVARCHAR (MAX) NULL,
    [Book_Publish_Date] DATETIME       NULL,
    [Book_Type]         NVARCHAR (50)  NULL,
    [Language_Id]       INT            NULL,
    [Author_Id]         INT            NULL,
    CONSTRAINT [PK_TRN_Book_Detail] PRIMARY KEY CLUSTERED ([Book_Detail_Id] ASC),
    CONSTRAINT [FK_TRN_Book_Detail_MST_Language] FOREIGN KEY ([Language_Id]) REFERENCES [dbo].[MST_Language] ([Language_Id]),
    CONSTRAINT [FK_TRN_Book_Detail_TRN_Author] FOREIGN KEY ([Author_Id]) REFERENCES [dbo].[TRN_Author] ([Author_Id])
);

