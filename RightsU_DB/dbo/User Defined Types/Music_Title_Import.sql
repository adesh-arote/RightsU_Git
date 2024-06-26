﻿CREATE TYPE [dbo].[Music_Title_Import] AS TABLE (
    [Music_Title_Name]      NVARCHAR (1000) NULL,
    [Duration]              NVARCHAR (100)  NULL,
    [Movie_Album]           NVARCHAR (1000) NULL,
    [Singers]               NVARCHAR (2000) NULL,
    [Lyricist]              NVARCHAR (2000) NULL,
    [Music_Director]        NVARCHAR (2000) NULL,
    [Title_Language]        NVARCHAR (100)  NULL,
    [Music_Label]           NVARCHAR (1000) NULL,
    [Year_of_Release]       NVARCHAR (100)  NULL,
    [Title_Type]            NVARCHAR (100)  NULL,
    [Genres]                NVARCHAR (100)  NULL,
    [Star_Cast]             NVARCHAR (1000) NULL,
    [Music_Version]         NVARCHAR (100)  NULL,
    [Effective_Start_Date]  NVARCHAR (100)  NULL,
    [Theme]                 NVARCHAR (100)  NULL,
    [Music_Tag]             NVARCHAR (200)  NULL,
    [Movie_Star_Cast]       NVARCHAR (1000) NULL,
    [Music_Album_Type]      NVARCHAR (100)  NULL,
    [DM_Master_Import_Code] NVARCHAR (100)  NULL,
    [Excel_Line_No]         VARCHAR (50)    NULL,
    [Public_Domain]         VARCHAR (10)    NULL);

