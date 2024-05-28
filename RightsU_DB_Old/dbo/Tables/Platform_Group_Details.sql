CREATE TABLE [dbo].[Platform_Group_Details] (
    [Platform_Group_Details_Code] INT IDENTITY (1, 1) NOT NULL,
    [Platform_Code]               INT NULL,
    [Platform_Group_Code]         INT NULL,
    CONSTRAINT [PK_Platform_Group_Details] PRIMARY KEY CLUSTERED ([Platform_Group_Details_Code] ASC),
    CONSTRAINT [FK_Platform_Group_Details_Platform] FOREIGN KEY ([Platform_Code]) REFERENCES [dbo].[Platform] ([Platform_Code]),
    CONSTRAINT [FK_Platform_Group_Details_Platform_Group] FOREIGN KEY ([Platform_Group_Code]) REFERENCES [dbo].[Platform_Group] ([Platform_Group_Code])
);

