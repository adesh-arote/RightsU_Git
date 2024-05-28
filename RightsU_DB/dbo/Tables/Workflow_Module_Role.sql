CREATE TABLE [dbo].[Workflow_Module_Role] (
    [Workflow_Module_Role_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Workflow_Module_Code]      INT      NULL,
    [Workflow_Role_Code]        INT      NULL,
    [Group_Level]               SMALLINT NULL,
    [Group_Code]                INT      NULL,
    [Reminder_Days]             SMALLINT NULL,
    CONSTRAINT [PK_Workflow_Module_Role] PRIMARY KEY CLUSTERED ([Workflow_Module_Role_Code] ASC),
    CONSTRAINT [FK_Workflow_Module_Role_Workflow_Module] FOREIGN KEY ([Workflow_Module_Code]) REFERENCES [dbo].[Workflow_Module] ([Workflow_Module_Code]),
    CONSTRAINT [FK_Workflow_Module_Role_Workflow_Role] FOREIGN KEY ([Workflow_Role_Code]) REFERENCES [dbo].[Workflow_Role] ([Workflow_Role_Code])
);

