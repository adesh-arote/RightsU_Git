CREATE TABLE [dbo].[BMS_Log] (
    [BMS_Log_Code]      INT           IDENTITY (1, 1) NOT NULL,
    [Module_Name]       VARCHAR (100) NULL,
    [Method_Type]       VARCHAR (10)  NULL,
    [Request_Time]      DATETIME      NULL,
    [Response_Time]     DATETIME      NULL,
    [Request_Xml]       VARCHAR (MAX) NULL,
    [Response_Xml]      VARCHAR (MAX) NULL,
    [Record_Status]     VARCHAR (5)   NULL,
    [Error_Description] VARCHAR (MAX) NULL,
    [Request_Message]   VARCHAR (MAX) NULL,
    PRIMARY KEY CLUSTERED ([BMS_Log_Code] ASC)
);



