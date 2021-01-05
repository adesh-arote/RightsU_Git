CREATE TABLE [dbo].[Users_Password_Detail] (
    [Users_Password_Detail_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Users_Code]                 INT            NULL,
    [Users_Passwords]            NVARCHAR (200) NULL,
    [Password_Change_Date]       DATETIME       NULL,
    CONSTRAINT [PK_Users_Password_Detail] PRIMARY KEY CLUSTERED ([Users_Password_Detail_Code] ASC),
    CONSTRAINT [FK_Users_Password_Detail_Users] FOREIGN KEY ([Users_Code]) REFERENCES [dbo].[Users] ([Users_Code])
);

