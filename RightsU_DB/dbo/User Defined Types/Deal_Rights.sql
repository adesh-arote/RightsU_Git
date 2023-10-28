CREATE TYPE [dbo].[Deal_Rights] AS TABLE (
    [Deal_Rights_Code]        INT            NULL,
    [Deal_Code]               INT            NOT NULL,
    [Is_Exclusive]            CHAR (1)       NULL,
    [Is_Title_Language_Right] CHAR (1)       NULL,
    [Is_Sub_License]          CHAR (1)       NULL,
    [Sub_License_Code]        INT            NULL,
    [Is_Theatrical_Right]     CHAR (1)       NULL,
    [Right_Type]              CHAR (1)       NULL,
    [Is_Tentative]            CHAR (1)       NULL,
    [Term]                    VARCHAR (12)   NULL,
    [Milestone_Type_Code]     INT            NULL,
    [Milestone_No_Of_Unit]    INT            NULL,
    [Milestone_Unit_Type]     INT            NULL,
    [Is_ROFR]                 CHAR (1)       NULL,
    [ROFR_Date]               DATETIME       NULL,
    [Restriction_Remarks]     VARCHAR (5000) NULL,
    [Right_Start_Date]        DATETIME       NULL,
    [Right_End_Date]          DATETIME       NULL,
    [Title_Code]              INT            NULL,
    [Platform_Code]           INT            NULL,
    [Check_For]               VARCHAR (10)   NULL,
    [Buyback_Syn_Rights_Code] NVARCHAR (MAX) NULL);



