CREATE TABLE [dbo].[System_Module_Message] (
    [System_Module_Message_Code] INT          IDENTITY (1, 1) NOT NULL,
    [Module_Code]                INT          NULL,
    [Form_ID]                    VARCHAR (50) NULL,
    [System_Message_Code]        INT          NULL,
    [Inserted_On]                DATETIME     NULL,
    [Inserted_By]                INT          NULL,
    [Last_Updated_Time]          DATETIME     NULL,
    [Last_Action_By]             INT          NULL,
    CONSTRAINT [PK_System_Module_Message] PRIMARY KEY CLUSTERED ([System_Module_Message_Code] ASC),
    CONSTRAINT [FK_System_Module_Message_System_Message] FOREIGN KEY ([System_Message_Code]) REFERENCES [dbo].[System_Message] ([System_Message_Code]),
    CONSTRAINT [FK_System_Module_Message_System_Module] FOREIGN KEY ([Module_Code]) REFERENCES [dbo].[System_Module] ([Module_Code])
);

