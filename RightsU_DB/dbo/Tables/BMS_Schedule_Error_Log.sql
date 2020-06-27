CREATE TABLE [dbo].[BMS_Schedule_Error_Log] (
    [BMS_Schedule_Error_Log_Code]    INT IDENTITY (1, 1) NOT NULL,
    [BMS_Schedule_Log_Code]          INT NULL,
    [BMS_Process_Schedule_Data_Code] INT NULL,
    [Error_Code]                     INT NULL,
    PRIMARY KEY CLUSTERED ([BMS_Schedule_Error_Log_Code] ASC),
    CONSTRAINT [FK_BMS_Schedule_Error_Log_BMS_Process_Schedule_Temp] FOREIGN KEY ([BMS_Process_Schedule_Data_Code]) REFERENCES [dbo].[BMS_Process_Schedule_Data] ([BMS_Process_Schedule_Data_Code]),
    CONSTRAINT [FK_BMS_Schedule_Error_Log_BMS_Schedule_Log] FOREIGN KEY ([BMS_Schedule_Log_Code]) REFERENCES [dbo].[BMS_Schedule_Log] ([BMS_Schedule_Log_Code])
);

