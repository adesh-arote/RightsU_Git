CREATE TABLE [dbo].[Integration_SDM_Log] (
    [Integration_SDM_Log_Code] NUMERIC (8)   IDENTITY (1, 1) NOT NULL,
    [Integration_Config_Code]  NUMERIC (8)   NULL,
    [Request_Type]             VARCHAR (100) NULL,
    [Request_Client_IP]        VARCHAR (100) NULL,
    [Request_DateTime]         DATETIME      NULL,
    [Response_DateTime]        DATETIME      NULL,
    [Response_XML]             VARCHAR (MAX) NULL,
    [Request_XML]              VARCHAR (MAX) NULL,
    [Error_Message]            VARCHAR (MAX) NULL,
    [Record_Status]            VARCHAR (10)  NULL,
    CONSTRAINT [PK_Integration_SDM_Log] PRIMARY KEY CLUSTERED ([Integration_SDM_Log_Code] ASC),
    CONSTRAINT [FK_Integration_SDM_Log_Integration_Config] FOREIGN KEY ([Integration_Config_Code]) REFERENCES [dbo].[Integration_Config] ([Integration_Config_Code])
);

