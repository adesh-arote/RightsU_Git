CREATE TABLE [dbo].[MQ_Config] (
    [MQ_Config_Code]  INT           IDENTITY (1, 1) NOT NULL,
    [MQ_Name]         VARCHAR (MAX) NULL,
    [MQ_Manager]      VARCHAR (MAX) NULL,
    [MQ_Channel]      VARCHAR (MAX) NULL,
    [Config_For]      CHAR (1)      NULL,
    [Config_Type]     VARCHAR (MAX) NULL,
    [Execution_Order] INT           NULL,
    [Is_Active]       CHAR (1)      NULL,
    PRIMARY KEY CLUSTERED ([MQ_Config_Code] ASC)
);

