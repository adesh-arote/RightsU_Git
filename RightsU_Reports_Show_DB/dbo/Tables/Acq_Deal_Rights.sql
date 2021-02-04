﻿CREATE TABLE [dbo].[Acq_Deal_Rights] (
    [Acq_Deal_Rights_Code]    INT             IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Code]           INT             NOT NULL,
    [Is_Exclusive]            CHAR (1)        COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Is_Title_Language_Right] CHAR (1)        COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Is_Sub_License]          CHAR (1)        COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Sub_License_Code]        INT             NULL,
    [Is_Theatrical_Right]     CHAR (1)        COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Right_Type]              CHAR (1)        COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Is_Tentative]            CHAR (1)        COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Term]                    VARCHAR (12)    COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Right_Start_Date]        DATETIME        NULL,
    [Right_End_Date]          DATETIME        NULL,
    [Milestone_Type_Code]     INT             NULL,
    [Milestone_No_Of_Unit]    INT             NULL,
    [Milestone_Unit_Type]     INT             NULL,
    [Is_ROFR]                 CHAR (1)        COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [ROFR_Date]               DATETIME        NULL,
    [Restriction_Remarks]     NVARCHAR (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Effective_Start_Date]    DATETIME        NULL,
    [Actual_Right_Start_Date] DATETIME        NULL,
    [Actual_Right_End_Date]   DATETIME        NULL,
    [ROFR_Code]               INT             NULL,
    [Inserted_By]             INT             NULL,
    [Inserted_On]             DATETIME        NULL,
    [Last_Updated_Time]       DATETIME        NULL,
    [Last_Action_By]          INT             NULL,
    [Is_Verified]             CHAR (1)        COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Original_Right_Type]     CHAR (1)        COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Promoter_Flag]           CHAR (1)        COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Right_Status]            CHAR (1)        COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    CONSTRAINT [PK_Acq_Deal_Rights_Code] PRIMARY KEY CLUSTERED ([Acq_Deal_Rights_Code] ASC)
);

