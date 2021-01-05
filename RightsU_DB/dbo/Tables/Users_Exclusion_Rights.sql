CREATE TABLE [dbo].[Users_Exclusion_Rights] (
    [Users_Exclusion_Rights_Code] INT IDENTITY (1, 1) NOT NULL,
    [Users_Code]                  INT NULL,
    [Module_Right_Code]           INT NULL,
    PRIMARY KEY CLUSTERED ([Users_Exclusion_Rights_Code] ASC),
    FOREIGN KEY ([Module_Right_Code]) REFERENCES [dbo].[System_Module_Right] ([Module_Right_Code]),
    FOREIGN KEY ([Users_Code]) REFERENCES [dbo].[Users] ([Users_Code])
);

