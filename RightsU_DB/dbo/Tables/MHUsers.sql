CREATE TABLE [dbo].[MHUsers] (
    [MHUsersCode] INT IDENTITY (1, 1) NOT NULL,
    [Users_Code]  INT NULL,
    [Vendor_Code] INT NULL,
    CONSTRAINT [PK_MHUsers] PRIMARY KEY CLUSTERED ([MHUsersCode] ASC),
    CONSTRAINT [FK_MHUsers_Users] FOREIGN KEY ([Users_Code]) REFERENCES [dbo].[Users] ([Users_Code])
);

