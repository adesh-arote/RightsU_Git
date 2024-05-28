CREATE TABLE [dbo].[BVException_Users] (
    [Bv_Exception_Users_Code] INT IDENTITY (1, 1) NOT NULL,
    [Bv_Exception_Code]       INT NOT NULL,
    [Users_Code]              INT NOT NULL,
    CONSTRAINT [PK_Exception_Users] PRIMARY KEY CLUSTERED ([Bv_Exception_Users_Code] ASC),
    CONSTRAINT [FK_BVException_Users_BVException] FOREIGN KEY ([Bv_Exception_Code]) REFERENCES [dbo].[BVException] ([Bv_Exception_Code]),
    CONSTRAINT [FK_BVException_Users_Users] FOREIGN KEY ([Users_Code]) REFERENCES [dbo].[Users] ([Users_Code])
);

