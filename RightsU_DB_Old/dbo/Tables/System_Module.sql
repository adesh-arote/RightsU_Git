CREATE TABLE [dbo].[System_Module] (
    [Module_Code]         INT            NOT NULL,
    [Module_Name]         VARCHAR (100)  NULL,
    [Module_Position]     VARCHAR (10)   NULL,
    [Parent_Module_Code]  INT            NULL,
    [Is_Sub_Module]       CHAR (1)       NULL,
    [Url]                 VARCHAR (1000) NULL,
    [Target]              VARCHAR (50)   NULL,
    [Css]                 VARCHAR (50)   NULL,
    [Can_Workflow_Assign] CHAR (1)       CONSTRAINT [DF_System_Module_Can_Workflow_Assign] DEFAULT ('N') NULL,
    [Is_Active]           CHAR (1)       NULL,
    CONSTRAINT [PK_System_Module] PRIMARY KEY CLUSTERED ([Module_Code] ASC)
);

