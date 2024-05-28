CREATE TABLE [dbo].[Login_Details] (
    [Login_Details_Code]  INT           IDENTITY (1, 1) NOT NULL,
    [Login_Time]          DATETIME      NULL,
    [Logout_Time]         DATETIME      NULL,
    [Description]         VARCHAR (500) NULL,
    [Users_Code]          INT           NULL,
    [Security_Group_Code] INT           NULL,
    CONSTRAINT [PK_Login_Details] PRIMARY KEY CLUSTERED ([Login_Details_Code] ASC)
);

