﻿CREATE TABLE [dbo].[Syn_Deal_Rights] (
    [Syn_Deal_Rights_Code]    INT             IDENTITY (1, 1) NOT NULL,
    [Syn_Deal_Code]           INT             NOT NULL,
    [Is_Exclusive]            CHAR (1)        NULL,
    [Is_Title_Language_Right] CHAR (1)        NULL,
    [Is_Sub_License]          CHAR (1)        NULL,
    [Sub_License_Code]        INT             NULL,
    [Is_Theatrical_Right]     CHAR (1)        NULL,
    [Right_Type]              CHAR (1)        NULL,
    [Is_Tentative]            CHAR (1)        NULL,
    [Term]                    VARCHAR (12)    NULL,
    [Right_Start_Date]        DATETIME        NULL,
    [Right_End_Date]          DATETIME        NULL,
    [Milestone_Type_Code]     INT             NULL,
    [Milestone_No_Of_Unit]    INT             NULL,
    [Milestone_Unit_Type]     INT             NULL,
    [Is_ROFR]                 CHAR (1)        NULL,
    [ROFR_Date]               DATETIME        NULL,
    [Restriction_Remarks]     NVARCHAR (4000) NULL,
    [Effective_Start_Date]    DATETIME        NULL,
    [Actual_Right_Start_Date] DATETIME        NULL,
    [Actual_Right_End_Date]   DATETIME        NULL,
    [Is_Pushback]             CHAR (1)        NULL,
    [ROFR_Code]               INT             NULL,
    [Inserted_By]             INT             NULL,
    [Inserted_On]             DATETIME        NULL,
    [Last_Updated_Time]       DATETIME        NULL,
    [Last_Action_By]          INT             NULL,
    [Right_Status]            CHAR (1)        NULL,
    [Is_Verified]             CHAR (1)        NULL,
    [Original_Right_Type]     CHAR (1)        NULL,
    [Promoter_Flag]           CHAR (1)        NULL,
    [CoExclusive_Remarks]     NVARCHAR (4000) NULL,
    CONSTRAINT [PK_Syn_Deal_Rights_Code] PRIMARY KEY CLUSTERED ([Syn_Deal_Rights_Code] ASC)
);



