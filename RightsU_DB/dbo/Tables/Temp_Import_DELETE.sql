CREATE TABLE [dbo].[Temp_Import_DELETE] (
    [ID]                    INT           IDENTITY (1, 1) NOT NULL,
    [DM_Master_Import_Code] INT           NULL,
    [Name]                  VARCHAR (100) NULL,
    [Master_Type]           VARCHAR (100) NULL,
    [Action_By]             INT           NULL,
    [Action_On]             DATETIME      NULL,
    [Roles]                 VARCHAR (100) NULL
);

