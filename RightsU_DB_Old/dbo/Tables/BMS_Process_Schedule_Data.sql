CREATE TABLE [dbo].[BMS_Process_Schedule_Data] (
    [BMS_Process_Schedule_Data_Code] INT          IDENTITY (1, 1) NOT NULL,
    [Timeline_ID]                    INT          NULL,
    [Delete_Flag]                    BIT          NULL,
    [Program_AssetId]                INT          NULL,
    [Program_VersionId]              INT          NULL,
    [Log_Date]                       DATE         NULL,
    [Date_Time]                      VARCHAR (50) NULL,
    [SYSLookupId_PlayCountError]     INT          NULL,
    [DealContent_RightId]            INT          NULL,
    [Play_Day]                       INT          NULL,
    [Play_Run]                       INT          NULL,
    [Title_Code]                     INT          NULL,
    [Acq_Deal_Movie_Code]            INT          NULL,
    [Is_Deal_Approved]               CHAR (1)     NULL,
    [Inserted_On]                    DATETIME     NULL,
    [Is_Error]                       CHAR (1)     NULL,
    [Is_Processed]                   CHAR (1)     NULL,
    [Is_Ignore]                      CHAR (1)     NULL,
    PRIMARY KEY CLUSTERED ([BMS_Process_Schedule_Data_Code] ASC)
);

