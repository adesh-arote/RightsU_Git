CREATE TABLE [dbo].[Deal_Workflow_Status] (
    [Deal_Workflow_Status_Code] INT           IDENTITY (1, 1) NOT NULL,
    [Deal_Workflow_Status_Name] NVARCHAR (50) NULL,
    [Deal_WorkflowFlag]         VARCHAR (3)   NULL,
    [Deal_Type]                 CHAR (1)      NULL,
    CONSTRAINT [PK_Deal_Workflow_Status] PRIMARY KEY CLUSTERED ([Deal_Workflow_Status_Code] ASC)
);

