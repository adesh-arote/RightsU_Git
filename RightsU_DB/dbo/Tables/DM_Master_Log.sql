CREATE TABLE [dbo].[DM_Master_Log] (
    [DM_Master_Log_Code]    INT            IDENTITY (1, 1) NOT NULL,
    [DM_Master_Import_Code] VARCHAR (500)  NULL,
    [Name]                  NVARCHAR (200) NULL,
    [Master_Type]           VARCHAR (100)  NULL,
    [Master_Code]           INT            NULL,
    [User_Action]           VARCHAR (2)    NULL,
    [Action_By]             INT            NULL,
    [Action_On]             DATETIME       NULL,
    [Roles]                 VARCHAR (500)  NULL,
    [Is_Ignore]             CHAR (1)       NULL,
    [Mapped_By]             CHAR (1)       NULL,
    CONSTRAINT [PK_DM_Master_Log] PRIMARY KEY CLUSTERED ([DM_Master_Log_Code] ASC)
);

