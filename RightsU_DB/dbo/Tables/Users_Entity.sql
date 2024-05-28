CREATE TABLE [dbo].[Users_Entity] (
    [Users_Entity_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Users_Code]        INT      NULL,
    [Entity_Code]       INT      NULL,
    [Is_Default]        CHAR (1) NULL,
    CONSTRAINT [PK_User_Entity] PRIMARY KEY CLUSTERED ([Users_Entity_Code] ASC),
    CONSTRAINT [FK_Users_Entity_Users] FOREIGN KEY ([Users_Code]) REFERENCES [dbo].[Users] ([Users_Code])
);

