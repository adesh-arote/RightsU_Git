CREATE TABLE [dbo].[Workflow_BU_Role] (
    [Workflow_BU_Role_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Group_Level]           SMALLINT NULL,
    [Workflow_BU_Code]      INT      NULL,
    [Security_Group_Code]   INT      NULL,
    CONSTRAINT [PK_Workflow_BU_Role] PRIMARY KEY CLUSTERED ([Workflow_BU_Role_Code] ASC),
    CONSTRAINT [FK_Workflow_BU_Role_Security_Group] FOREIGN KEY ([Security_Group_Code]) REFERENCES [dbo].[Security_Group] ([Security_Group_Code]),
    CONSTRAINT [FK_Workflow_BU_Role_Workflow_BU] FOREIGN KEY ([Workflow_BU_Code]) REFERENCES [dbo].[Workflow_BU] ([Workflow_BU_Code])
);

