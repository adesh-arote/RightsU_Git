CREATE TABLE [dbo].[Workflow_Module_BU] (
    [Workflow_Module_BU_Code] INT IDENTITY (1, 1) NOT NULL,
    [Workflow_Module_Code]    INT NULL,
    [Workflow_BU_Code]        INT NULL,
    [Business_Unit_Code]      INT NULL,
    CONSTRAINT [PK_Workflow_Module_BU] PRIMARY KEY CLUSTERED ([Workflow_Module_BU_Code] ASC),
    CONSTRAINT [FK_Workflow_Module_BU_Business_Unit] FOREIGN KEY ([Business_Unit_Code]) REFERENCES [dbo].[Business_Unit] ([Business_Unit_Code]),
    CONSTRAINT [FK_Workflow_Module_BU_Workflow_BU] FOREIGN KEY ([Workflow_BU_Code]) REFERENCES [dbo].[Workflow_BU] ([Workflow_BU_Code]),
    CONSTRAINT [FK_Workflow_Module_BU_Workflow_Module] FOREIGN KEY ([Workflow_Module_Code]) REFERENCES [dbo].[Workflow_Module] ([Workflow_Module_Code])
);

