CREATE TABLE [dbo].[TRN_Author] (
    [Author_Id]      INT            IDENTITY (1, 1) NOT NULL,
    [Author_Name]    NVARCHAR (50)  NULL,
    [Author_Address] NVARCHAR (50)  NULL,
    [Email]          NVARCHAR (100) NULL,
    CONSTRAINT [PK_TRN_Author] PRIMARY KEY CLUSTERED ([Author_Id] ASC)
);

