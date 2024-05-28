CREATE TABLE [dbo].[Workflow_Module_BU_Role] (
    [Workflow_Module_BU_Role_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Workflow_Module_BU_Code]      INT      NULL,
    [Workflow_BU_Role_Code]        INT      NULL,
    [Group_Level]                  SMALLINT NULL,
    [Security_Group_Code]          INT      NULL,
    CONSTRAINT [PK_Workflow_Module_BU_Role] PRIMARY KEY CLUSTERED ([Workflow_Module_BU_Role_Code] ASC),
    CONSTRAINT [FK_Workflow_Module_BU_Role_Security_Group] FOREIGN KEY ([Security_Group_Code]) REFERENCES [dbo].[Security_Group] ([Security_Group_Code]),
    CONSTRAINT [FK_Workflow_Module_BU_Role_Workflow_BU_Role] FOREIGN KEY ([Workflow_BU_Role_Code]) REFERENCES [dbo].[Workflow_BU_Role] ([Workflow_BU_Role_Code]),
    CONSTRAINT [FK_Workflow_Module_BU_Role_Workflow_Module_BU] FOREIGN KEY ([Workflow_Module_BU_Code]) REFERENCES [dbo].[Workflow_Module_BU] ([Workflow_Module_BU_Code])
);

