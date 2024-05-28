CREATE TABLE [dbo].[Users_Configuration] (
    [User_Configuration_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Dashboard_Key]           NVARCHAR (200) NULL,
    [Dashboard_Value]         INT            NULL,
    [Users_Code]              INT            NULL,
    PRIMARY KEY CLUSTERED ([User_Configuration_Code] ASC),
    FOREIGN KEY ([Users_Code]) REFERENCES [dbo].[Users] ([Users_Code])
);

