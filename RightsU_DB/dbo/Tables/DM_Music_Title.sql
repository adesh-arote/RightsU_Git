﻿CREATE TABLE [dbo].[DM_Music_Title] (
    [IntCode]               INT             IDENTITY (1, 1) NOT NULL,
    [Music_Title_Name]      NVARCHAR (4000) NULL,
    [Duration]              VARCHAR (100)   NULL,
    [Movie_Album]           NVARCHAR (2000) NULL,
    [Singers]               NVARCHAR (4000) NULL,
    [Lyricist]              NVARCHAR (4000) NULL,
    [Music_Director]        NVARCHAR (4000) NULL,
    [Title_Language]        NVARCHAR (200)  NULL,
    [Music_Label]           NVARCHAR (2000) NULL,
    [Year_of_Release]       VARCHAR (100)   NULL,
    [Title_Type]            VARCHAR (100)   NULL,
    [Record_Status]         VARCHAR (2)     NULL,
    [Error_Message]         NVARCHAR (MAX)  NULL,
    [Genres]                NVARCHAR (200)  NULL,
    [Star_Cast]             NVARCHAR (2000) NULL,
    [Music_Version]         VARCHAR (1000)  NULL,
    [Effective_Start_Date]  VARCHAR (100)   NULL,
    [Theme]                 NVARCHAR (4000) NULL,
    [Music_Tag]             NVARCHAR (200)  NULL,
    [Movie_Star_Cast]       NVARCHAR (1000) NULL,
    [Music_Album_Type]      VARCHAR (100)   NULL,
    [DM_Master_Import_Code] INT             NULL,
    [Excel_Line_No]         VARCHAR (50)    NULL,
    [Is_Ignore]             VARCHAR (1)     NULL,
    CONSTRAINT [PK__DM_Music__C067FC3019BD0DBD] PRIMARY KEY CLUSTERED ([IntCode] ASC)
);














