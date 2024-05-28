CREATE TABLE [dbo].[System_Module_Right] (
    [Module_Right_Code] INT IDENTITY (1, 1) NOT NULL,
    [Module_Code]       INT NOT NULL,
    [Right_Code]        INT NOT NULL,
    CONSTRAINT [PK_System_Module_Right] PRIMARY KEY CLUSTERED ([Module_Right_Code] ASC),
    CONSTRAINT [FK_System_Module_Right_System_Module] FOREIGN KEY ([Module_Code]) REFERENCES [dbo].[System_Module] ([Module_Code]),
    CONSTRAINT [FK_System_Module_Right_System_Right] FOREIGN KEY ([Right_Code]) REFERENCES [dbo].[System_Right] ([Right_Code])
);

