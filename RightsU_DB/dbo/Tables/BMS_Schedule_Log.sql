CREATE TABLE [dbo].[BMS_Schedule_Log] (
    [BMS_Schedule_Log_Code] INT           IDENTITY (1, 1) NOT NULL,
    [Channel_Code]          INT           NULL,
    [Data_Since]            DATETIME      NULL,
    [Method_Type]           VARCHAR (5)   NULL,
    [Request_Time]          DATETIME      NULL,
    [Response_Time]         DATETIME      NULL,
    [Request_Xml]           VARCHAR (MAX) NULL,
    [Response_Xml]          VARCHAR (MAX) NULL,
    [Record_Status]         CHAR (1)      NULL,
    [Error_Description]     VARCHAR (MAX) NULL,
    [Start_Date]            DATETIME      NULL,
    [End_Date]              DATETIME      NULL,
    [Response_Message]      VARCHAR (MAX) NULL,
    PRIMARY KEY CLUSTERED ([BMS_Schedule_Log_Code] ASC),
    CONSTRAINT [FK_BMS_Schedule_Log_Channel] FOREIGN KEY ([Channel_Code]) REFERENCES [dbo].[Channel] ([Channel_Code])
);

