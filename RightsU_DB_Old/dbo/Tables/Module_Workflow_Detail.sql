CREATE TABLE [dbo].[Module_Workflow_Detail] (
    [Module_Workflow_Detail_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Module_Code]                 INT      NULL,
    [Record_Code]                 INT      NULL,
    [Group_Code]                  INT      NULL,
    [Primary_User_Code]           INT      NULL,
    [Role_Level]                  SMALLINT NULL,
    [Is_Done]                     CHAR (1) CONSTRAINT [DF_Module_Workflow_Detail_Is_Done] DEFAULT ('N') NULL,
    [Next_Level_Group]            INT      NULL,
    [Entry_Date]                  DATETIME NULL,
    CONSTRAINT [PK_Module_Workflow_Detail] PRIMARY KEY CLUSTERED ([Module_Workflow_Detail_Code] ASC),
    CONSTRAINT [FK_Module_Workflow_Detail_Security_Group] FOREIGN KEY ([Group_Code]) REFERENCES [dbo].[Security_Group] ([Security_Group_Code]),
    CONSTRAINT [FK_Module_Workflow_Detail_Security_Group1] FOREIGN KEY ([Next_Level_Group]) REFERENCES [dbo].[Security_Group] ([Security_Group_Code]),
    CONSTRAINT [FK_Module_Workflow_Detail_System_Module] FOREIGN KEY ([Module_Code]) REFERENCES [dbo].[System_Module] ([Module_Code]),
    CONSTRAINT [FK_Module_Workflow_Detail_User_Master] FOREIGN KEY ([Primary_User_Code]) REFERENCES [dbo].[Users] ([Users_Code])
);

