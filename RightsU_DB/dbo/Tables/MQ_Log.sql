CREATE TABLE [dbo].[MQ_Log] (
    [MQ_Log_Code]    INT            IDENTITY (1, 1) NOT NULL,
    [MQ_Config_Code] INT            NULL,
    [Message_Key]    NVARCHAR (MAX) NULL,
    [Request_Text]   NVARCHAR (MAX) NULL,
    [Request_Time]   DATETIME       NULL,
    [Module_Code]    INT            NULL,
    [Record_Code]    INT            NULL,
    [Record_Status]  NVARCHAR (MAX) NULL,
    PRIMARY KEY CLUSTERED ([MQ_Log_Code] ASC)
);

