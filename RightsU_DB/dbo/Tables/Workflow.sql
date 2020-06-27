CREATE TABLE [dbo].[Workflow] (
    [Workflow_Code]      INT             IDENTITY (1, 1) NOT NULL,
    [Workflow_Name]      NVARCHAR (150)  NULL,
    [Workflow_Type]      CHAR (1)        NULL,
    [Business_Unit_Code] INT             NULL,
    [Remarks]            NVARCHAR (2000) NULL,
    [Last_Action_By]     INT             NULL,
    [Lock_Time]          DATETIME        NULL,
    [Last_Updated_Time]  DATETIME        NULL,
    CONSTRAINT [PK_Workflow] PRIMARY KEY CLUSTERED ([Workflow_Code] ASC),
    CONSTRAINT [FK_Workflow_Business_Unit] FOREIGN KEY ([Business_Unit_Code]) REFERENCES [dbo].[Business_Unit] ([Business_Unit_Code])
);



