CREATE TABLE [dbo].[Users_Activity_Log] (
    [Users_Activity_Log_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Record_Code]             INT            NULL,
    [Class_Name]              NVARCHAR (MAX) NULL,
    [Json_Data]               NVARCHAR (MAX) NULL,
    [Inserted_On]             DATETIME       NULL,
    [Inserted_By]             INT            NULL,
    [Last_Updated_On]         DATETIME       NULL,
    [Last_Updated_By]         INT            NULL,
    [Is_Error]                CHAR (1)       NULL,
    [Error_Message]           NVARCHAR (MAX) NULL,
    [Command_Type]            NVARCHAR (MAX) NULL,
    PRIMARY KEY CLUSTERED ([Users_Activity_Log_Code] ASC)
);

