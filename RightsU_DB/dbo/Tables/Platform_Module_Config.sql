CREATE TABLE [dbo].[Platform_Module_Config] (
    [Platform_Module_Config_Code] INT           IDENTITY (1, 1) NOT NULL,
    [System_Module_Code]          INT           NULL,
    [Platform_Code]               INT           NULL,
    [Flag]                        CHAR (1)      NULL,
    [Platform_Type]               VARCHAR (100) NULL,
    CONSTRAINT [PK_Platform_Group_Config] PRIMARY KEY CLUSTERED ([Platform_Module_Config_Code] ASC),
    CONSTRAINT [FK_Platform_Group_Config_Platform] FOREIGN KEY ([Platform_Code]) REFERENCES [dbo].[Platform] ([Platform_Code]),
    CONSTRAINT [FK_Platform_Group_Config_System_Module] FOREIGN KEY ([System_Module_Code]) REFERENCES [dbo].[System_Module] ([Module_Code])
);

