﻿CREATE TYPE [dbo].[BMS_Process_UDT] AS TABLE (
    [Acq_Deal_Code]                 INT          NULL,
    [Acq_Deal_Rights_Code]          INT          NULL,
    [Acq_Deal_Run_Code]             INT          NULL,
    [Agreement_Date]                DATETIME     NULL,
    [BMS_Asset_Ref_Key]             INT          NULL,
    [BMS_Schedule_Log_Code]         INT          NULL,
    [Channel_Code]                  INT          NULL,
    [ChannelWise_NoOfRuns]          INT          NULL,
    [ChannelWise_NoOfRuns_Schedule] INT          NULL,
    [Delete_Flag]                   BIT          NULL,
    [Is_In_BlackOut_Period]         VARCHAR (3)  NULL,
    [Is_In_Right_Perod]             VARCHAR (3)  NULL,
    [Is_Yearwise_Definition]        VARCHAR (10) NULL,
    [No_Of_Runs]                    INT          NULL,
    [No_Of_Runs_Sched]              INT          NULL,
    [Right_Start_Date]              DATETIME     NULL,
    [Right_End_Date]                DATETIME     NULL,
    [Right_Type]                    VARCHAR (3)  NULL,
    [Run_Definition_Type]           VARCHAR (3)  NULL,
    [Run_Type]                      CHAR (1)     NULL,
    [Schedule_Log_Date]             DATE         NULL,
    [Schedule_Log_Time]             DATETIME     NULL,
    [Timeline_ID]                   INT          NULL,
    [Title_Code]                    INT          NULL,
    [Content_Channel_Run_Code]      INT          NULL);

