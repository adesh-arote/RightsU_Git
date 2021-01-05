﻿CREATE TABLE [dbo].[BV_Schedule_Transaction] (
    [BV_Schedule_Transaction_Code]        NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [Program_Episode_ID]                  VARCHAR (1000) NULL,
    [Program_Version_ID]                  VARCHAR (1000) NULL,
    [Program_Episode_Title]               VARCHAR (250)  NULL,
    [Program_Episode_Number]              VARCHAR (100)  NULL,
    [Program_Title]                       VARCHAR (250)  NULL,
    [Program_Category]                    VARCHAR (250)  NULL,
    [Schedule_Item_Log_Date]              VARCHAR (50)   NULL,
    [Schedule_Item_Log_Time]              VARCHAR (50)   NULL,
    [Schedule_Item_Duration]              VARCHAR (100)  NULL,
    [Scheduled_Version_House_Number_List] VARCHAR (1000) NULL,
    [Found_Status]                        CHAR (1)       NULL,
    [File_Code]                           BIGINT         NULL,
    [Channel_Code]                        INT            NULL,
    [IsProcessed]                         CHAR (1)       NULL,
    [Inserted_By]                         INT            NULL,
    [Inserted_On]                         DATETIME       NULL,
    [Title_Code]                          NUMERIC (18)   NULL,
    [Deal_Movie_Code]                     NUMERIC (18)   NULL,
    [Deal_Movie_Rights_Code]              NUMERIC (18)   NULL,
    [IsRevertCnt_OnAsRunLoad]             CHAR (1)       NULL,
    [IsException]                         CHAR (1)       NULL,
    [IsDealApproved]                      CHAR (1)       NULL,
    [IsIgnore]                            CHAR (1)       NULL,
    [Record_Type]                         CHAR (1)       NULL,
    [Play_Day]                            INT            NULL,
    [Play_Run]                            INT            NULL,
    [Acq_Deal_Run_Code]                   INT            NULL,
    [Timeline_ID]                         INT            NULL,
    [Delete_Flag]                         BIT            NULL,
    [SYSLookupId_PlayCountError]          INT            NULL,
    [Acq_Deal_Code]                       INT            NULL,
    [DealContent_RightId]                 INT            NULL,
    [Last_Updated_Time]                   DATETIME       NULL,
    [Content_Channel_Run_Code]            INT            NULL,
    [IsPrime]                             CHAR (1)       NULL,
    [Ref_Timeline_ID]                     INT            NULL,
    [Deal_Type]                           CHAR (1)       NULL,
    [Deal_Code]                           INT            NULL,
    CONSTRAINT [PK_BV_Schedule_Transaction] PRIMARY KEY CLUSTERED ([BV_Schedule_Transaction_Code] ASC)
);








