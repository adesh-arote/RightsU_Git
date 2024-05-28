CREATE TABLE [dbo].[Security_Group_Rel] (
    [Security_Rel_Code]         INT IDENTITY (1, 1) NOT NULL,
    [Security_Group_Code]       INT NULL,
    [System_Module_Rights_Code] INT NULL,
    CONSTRAINT [PK_Security_Group_Rel] PRIMARY KEY CLUSTERED ([Security_Rel_Code] ASC),
    CONSTRAINT [FK_Security_Group_Rel_Security_Group] FOREIGN KEY ([Security_Group_Code]) REFERENCES [dbo].[Security_Group] ([Security_Group_Code]),
    CONSTRAINT [FK_Security_Group_Rel_System_Module_Right] FOREIGN KEY ([System_Module_Rights_Code]) REFERENCES [dbo].[System_Module_Right] ([Module_Right_Code])
);

