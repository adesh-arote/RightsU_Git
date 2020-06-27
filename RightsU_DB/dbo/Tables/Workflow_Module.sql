CREATE TABLE [dbo].[Workflow_Module] (
    [Workflow_Module_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Workflow_Code]        INT      NULL,
    [Module_Code]          INT      NULL,
    [Business_Unit_Code]   INT      NULL,
    [Ideal_Process_Days]   SMALLINT NULL,
    [Effective_Start_Date] DATETIME NULL,
    [System_End_Date]      DATETIME NULL,
    [Is_Active]            CHAR (1) CONSTRAINT [DF_Workflow_Module_Is_Active] DEFAULT ('Y') NULL,
    [Last_Action_By]       INT      NULL,
    [Lock_Time]            DATETIME NULL,
    [Last_Updated_Time]    DATETIME NULL,
    CONSTRAINT [PK_Workflow_Module] PRIMARY KEY CLUSTERED ([Workflow_Module_Code] ASC),
    CONSTRAINT [FK_Workflow_Module_Business_Unit] FOREIGN KEY ([Business_Unit_Code]) REFERENCES [dbo].[Business_Unit] ([Business_Unit_Code]),
    CONSTRAINT [FK_Workflow_Module_System_Module] FOREIGN KEY ([Module_Code]) REFERENCES [dbo].[System_Module] ([Module_Code]),
    CONSTRAINT [FK_Workflow_Module_Workflow] FOREIGN KEY ([Workflow_Code]) REFERENCES [dbo].[Workflow] ([Workflow_Code])
);

