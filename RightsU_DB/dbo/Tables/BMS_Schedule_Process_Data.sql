CREATE TABLE [dbo].[BMS_Schedule_Process_Data] (
    [BMS_Schedule_Process_Data_Code] INT          IDENTITY (1, 1) NOT NULL,
    [BMS_Schedule_Log_Code]          INT          NULL,
    [Timeline_ID]                    INT          NULL,
    [Delete_Flag]                    BIT          NULL,
    [BMS_Asset_Ref_Key]              INT          NULL,
    [Program_VersionId]              INT          NULL,
    [Log_Date]                       DATE         NULL,
    [Date_Time]                      VARCHAR (50) NULL,
    [SYSLookupId_PlayCountError]     INT          NULL,
    [DealContent_RightId]            INT          NULL,
    [Play_Day]                       INT          NULL,
    [Play_Run]                       INT          NULL,
    [Title_Code]                     INT          NULL,
    [Acq_Deal_Code]                  INT          NULL,
    [Acq_Deal_Run_Code]              INT          NULL,
    [Inserted_On]                    DATETIME     NULL,
    [Is_Error]                       CHAR (1)     NULL,
    [Is_Processed]                   CHAR (1)     NULL,
    [Record_Type]                    CHAR (1)     NULL,
    CONSTRAINT [PK__BMS_Sche__8E56271CAF0C06EB] PRIMARY KEY CLUSTERED ([BMS_Schedule_Process_Data_Code] ASC),
    CONSTRAINT [FK_BMS_Schedule_Process_Data_BMS_Schedule_Log] FOREIGN KEY ([BMS_Schedule_Log_Code]) REFERENCES [dbo].[BMS_Schedule_Log] ([BMS_Schedule_Log_Code])
);

