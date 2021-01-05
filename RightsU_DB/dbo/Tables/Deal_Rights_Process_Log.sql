CREATE TABLE [dbo].[Deal_Rights_Process_Log] (
    [Deal_Rights_Process_Log_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Deal_Code]                    INT            NULL,
    [Right_Codes]                  VARCHAR (MAX)  NULL,
    [Rights_Bulk_Update_Code]      VARCHAR (MAX)  NULL,
    [Record_Status]                CHAR (1)       NULL,
    [Description]                  NVARCHAR (MAX) NULL,
    [Created_Date]                 DATETIME       NULL,
    [DRPL_Code]                    INT            NULL
);

