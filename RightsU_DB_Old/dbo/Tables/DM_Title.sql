﻿CREATE TABLE [dbo].[DM_Title] (
    [DM_Title_Code]                  INT             IDENTITY (1, 1) NOT NULL,
    [Title Type]                     VARCHAR (1000)  NULL,
    [Original Title (Tanil/Telugu)]  NVARCHAR (2000) NULL,
    [Title/ Dubbed Title (Hindi)]    NVARCHAR (2000) NULL,
    [Type of Film (Original/Dubbed)] NVARCHAR (2000) NULL,
    [Program Category]               NVARCHAR (2000) NULL,
    [Synopsis]                       NVARCHAR (4000) NULL,
    [Producer Name]                  NVARCHAR (2000) NULL,
    [Director Name]                  NVARCHAR (2000) NULL,
    [Banner]                         NVARCHAR (2000) NULL,
    [Key Star Cast]                  NVARCHAR (2000) NULL,
    [Original Language (Hindi)]      NVARCHAR (2000) NULL,
    [Country of Origin]              NVARCHAR (2000) NULL,
    [Title Genres]                   NVARCHAR (2000) NULL,
    [Colour or B&W]                  VARCHAR (100)   NULL,
    [Year of Release]                VARCHAR (10)    NULL,
    [Duration (Min)]                 VARCHAR (10)    NULL,
    [CBFC Rating]                    VARCHAR (100)   NULL,
    [Music Composer]                 NVARCHAR (2000) NULL,
    [Record_Status]                  VARCHAR (2)     NULL,
    [Error_Message]                  NVARCHAR (MAX)  NULL,
    [Music_Label]                    NVARCHAR (4000) NULL,
    [Music_Version]                  NVARCHAR (4000) NULL,
    [DM_Master_Import_Code]          INT             NULL,
    [Excel_Line_No]                  VARCHAR (50)    NULL,
    [Is_Ignore]                      VARCHAR (1)     NULL
);








