CREATE TABLE [dbo].[System_Language_Message] (
    [System_Language_Message_Code] INT            IDENTITY (1, 1) NOT NULL,
    [System_Language_Code]         INT            NULL,
    [System_Module_Message_Code]   INT            NULL,
    [Message_Desc]                 NVARCHAR (MAX) NULL,
    [Inserted_On]                  DATETIME       NULL,
    [Inserted_By]                  INT            NULL,
    [Last_Updated_Time]            DATETIME       NULL,
    [Last_Action_By]               INT            NULL,
    CONSTRAINT [PK_System_Message_Language] PRIMARY KEY CLUSTERED ([System_Language_Message_Code] ASC),
    CONSTRAINT [FK_System_Message_Language_System_Language] FOREIGN KEY ([System_Language_Code]) REFERENCES [dbo].[System_Language] ([System_Language_Code]),
    CONSTRAINT [FK_System_Message_Language_System_Message_Type] FOREIGN KEY ([System_Module_Message_Code]) REFERENCES [dbo].[System_Module_Message] ([System_Module_Message_Code])
);



