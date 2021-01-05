﻿CREATE TABLE [dbo].[BMS_Schedule_Process_Data_Temp] (
    [BMS_Schedule_Process_Data_Temp_Code] INT          IDENTITY (1, 1) NOT NULL,
    [BMS_Schedule_Log_Code]               INT          NULL,
    [Timeline_ID]                         INT          NULL,
    [Delete_Flag]                         BIT          NULL,
    [BMS_Asset_Ref_Key]                   INT          NULL,
    [Program_VersionId]                   INT          NULL,
    [Log_Date]                            DATE         NULL,
    [Date_Time]                           VARCHAR (50) NULL,
    [SYSLookupId_PlayCountError]          INT          NULL,
    [DealContent_RightId]                 INT          NULL,
    [Play_Day]                            INT          NULL,
    [Play_Run]                            INT          NULL,
    [Title_Code]                          INT          NULL,
    [Is_Deal_Approved]                    CHAR (1)     NULL,
    [Inserted_On]                         DATETIME     NULL,
    [Is_Error]                            CHAR (1)     NULL,
    [Channel_Code]                        INT          NULL,
    [Record_Status]                       CHAR (1)     CONSTRAINT [dt_BMS_Schedule_Process_Data_Temp_Record_Status] DEFAULT ('P') NULL,
    [Acq_Deal_Code]                       INT          NULL,
    [Acq_Deal_Run_Code]                   INT          NULL,
    [Content_Channel_Run_Code]            INT          NULL,
    PRIMARY KEY CLUSTERED ([BMS_Schedule_Process_Data_Temp_Code] ASC),
    CONSTRAINT [FK_BMS_Schedule_Process_Data_Temp_BMS_Schedule_Log] FOREIGN KEY ([BMS_Schedule_Log_Code]) REFERENCES [dbo].[BMS_Schedule_Log] ([BMS_Schedule_Log_Code]),
    CONSTRAINT [FK_BMS_Schedule_Process_Data_Temp_Channel] FOREIGN KEY ([Channel_Code]) REFERENCES [dbo].[Channel] ([Channel_Code])
);







GO


GO


GO


GO


GO

Go

GO