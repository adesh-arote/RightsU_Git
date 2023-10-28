CREATE TABLE [dbo].[UserCreationEmail] (
    [UserCreationEmailCode] INT            IDENTITY (1, 1) NOT NULL,
    [Users_Code]            INT            NULL,
    [MailSentStatus]        NVARCHAR (50)  NULL,
    [EmailSentOn]           NVARCHAR (50)  NULL,
    [ErrorMsg]              NVARCHAR (MAX) NULL,
    [Created_On]            NVARCHAR (50)  NULL,
    CONSTRAINT [PK_UserCreationEmail] PRIMARY KEY CLUSTERED ([UserCreationEmailCode] ASC)
);

