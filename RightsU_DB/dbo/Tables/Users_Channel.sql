CREATE TABLE [dbo].[Users_Channel] (
    [Users_Channel_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Users_Code]         INT      NULL,
    [Channel_Code]       INT      NULL,
    [S_Default]          CHAR (1) NULL,
    CONSTRAINT [PK_User_Channel] PRIMARY KEY CLUSTERED ([Users_Channel_Code] ASC),
    CONSTRAINT [FK_Users_Channel_Users] FOREIGN KEY ([Users_Code]) REFERENCES [dbo].[Users] ([Users_Code])
);

