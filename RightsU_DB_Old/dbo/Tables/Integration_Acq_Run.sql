﻿CREATE TABLE [dbo].[Integration_Acq_Run] (
    [Integration_Acq_Run_Code]     INT            IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Run_Code]            INT            NULL,
    [Foreign_System_Code]          INT            NULL,
    [Integration_Title_Code]       INT            NULL,
    [Run_Type]                     CHAR (1)       NULL,
    [No_Of_Runs]                   INT            NULL,
    [Is_Yearwise_Definition]       CHAR (1)       NULL,
    [Is_Rule_Right]                CHAR (1)       NULL,
    [Right_Rule_Code]              INT            NULL,
    [Repeat_Within_Days_Hrs]       CHAR (1)       NULL,
    [No_Of_Days_Hrs]               INT            NULL,
    [Is_Channel_Definition_Rights] CHAR (1)       NULL,
    [Primary_Channel_Code]         INT            NULL,
    [Run_Definition_Type]          CHAR (1)       NULL,
    [Prime_Start_Time]             TIME (7)       NULL,
    [Prime_End_Time]               TIME (7)       NULL,
    [Off_Prime_Start_Time]         TIME (7)       NULL,
    [Off_Prime_End_Time]           TIME (7)       NULL,
    [Time_Lag_Simulcast]           TIME (7)       NULL,
    [Prime_Run]                    INT            NULL,
    [Off_Prime_Run]                INT            NULL,
    [Repeat_On_Day]                VARCHAR (100)  NULL,
    [Rights_Start_Date]            DATETIME       NULL,
    [Rights_End_Date]              DATETIME       NULL,
    [Acq_Deal_Code]                INT            NULL,
    [Deal_Description]             VARCHAR (1000) NULL,
    [Licensor_Code]                INT            NULL,
    [Title_Type]                   CHAR (1)       NULL,
    [Process_Date]                 DATETIME       NULL,
    [Inserted_On]                  DATETIME       NULL,
    [Record_Status]                CHAR (1)       NULL,
    [Is_Archive]                   CHAR (1)       NULL,
    CONSTRAINT [PK_Integration_Acq_Run] PRIMARY KEY CLUSTERED ([Integration_Acq_Run_Code] ASC),
    CONSTRAINT [FK_Integration_Acq_Run_Integration_Title] FOREIGN KEY ([Integration_Title_Code]) REFERENCES [dbo].[Integration_Title] ([Integration_Title_Code])
);

