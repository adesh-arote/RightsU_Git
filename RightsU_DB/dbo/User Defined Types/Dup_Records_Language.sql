﻿CREATE TYPE [dbo].[Dup_Records_Language] AS TABLE (
    [id]                      INT           NULL,
    [Title_Code]              INT           NULL,
    [Platform_Code]           INT           NULL,
    [Territory_Code]          INT           NULL,
    [Country_Code]            INT           NULL,
    [Right_Start_Date]        DATETIME      NULL,
    [Right_End_Date]          DATETIME      NULL,
    [Right_Type]              VARCHAR (50)  NULL,
    [Territory_Type]          CHAR (1)      NULL,
    [Is_Sub_License]          CHAR (1)      NULL,
    [Is_Title_Language_Right] CHAR (1)      NULL,
    [Subtitling_Language]     INT           NULL,
    [Dubbing_Language]        INT           NULL,
    [Deal_Code]               INT           NULL,
    [Deal_Rights_Code]        INT           NULL,
    [Deal_Pushback_Code]      INT           NULL,
    [Agreement_No]            VARCHAR (MAX) NULL,
    [ErrorMSG]                VARCHAR (MAX) NULL,
    [Episode_From]            INT           NULL,
    [Episode_To]              INT           NULL,
    [IsPushback]              CHAR (1)      NULL);

