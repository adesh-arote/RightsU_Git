CREATE TABLE [dbo].[Users_Business_Unit] (
    [Users_Business_Unit_Code] INT IDENTITY (1, 1) NOT NULL,
    [Users_Code]               INT NULL,
    [Business_Unit_Code]       INT NULL,
    CONSTRAINT [PK_Users_Business_Unit] PRIMARY KEY CLUSTERED ([Users_Business_Unit_Code] ASC),
    CONSTRAINT [FK_Business_Unit_Users_Business_Unit] FOREIGN KEY ([Business_Unit_Code]) REFERENCES [dbo].[Business_Unit] ([Business_Unit_Code]),
    CONSTRAINT [FK_Users_Users_Business_Unit] FOREIGN KEY ([Users_Code]) REFERENCES [dbo].[Users] ([Users_Code])
);

