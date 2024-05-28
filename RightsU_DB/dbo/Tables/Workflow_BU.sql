CREATE TABLE [dbo].[Workflow_BU] (
    [Workflow_BU_Code]   INT IDENTITY (1, 1) NOT NULL,
    [Workflow_Code]      INT NULL,
    [Business_Unit_Code] INT NULL,
    CONSTRAINT [PK_Workflow_BU] PRIMARY KEY CLUSTERED ([Workflow_BU_Code] ASC),
    CONSTRAINT [FK_Workflow_BU_Business_Unit] FOREIGN KEY ([Business_Unit_Code]) REFERENCES [dbo].[Business_Unit] ([Business_Unit_Code]),
    CONSTRAINT [FK_Workflow_BU_Workflow] FOREIGN KEY ([Workflow_Code]) REFERENCES [dbo].[Workflow] ([Workflow_Code])
);

