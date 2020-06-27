CREATE TABLE [dbo].[Workflow_Role] (
    [Workflow_Role_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Group_Level]        SMALLINT NULL,
    [Workflow_Code]      INT      NULL,
    [Group_Code]         INT      NULL,
    [Primary_User_Code]  INT      NULL,
    CONSTRAINT [PK_Workflow_Role] PRIMARY KEY CLUSTERED ([Workflow_Role_Code] ASC),
    CONSTRAINT [FK_Workflow_Role_Security_Group] FOREIGN KEY ([Group_Code]) REFERENCES [dbo].[Security_Group] ([Security_Group_Code]),
    CONSTRAINT [FK_Workflow_Role_Workflow] FOREIGN KEY ([Workflow_Code]) REFERENCES [dbo].[Workflow] ([Workflow_Code])
);

