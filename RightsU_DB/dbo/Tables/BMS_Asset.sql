CREATE TABLE [dbo].[BMS_Asset] (
    [BMS_Asset_Code]          DECIMAL (38)   IDENTITY (1, 1) NOT NULL,
    [BMS_Deal_Code]           INT            NULL,
    [BMS_Asset_Ref_Key]       INT            NULL,
    [Duration]                TIME (7)       NULL,
    [RU_Title_Code]           INT            NULL,
    [Episode_No]              INT            NULL,
    [Title]                   VARCHAR (80)   NULL,
    [Title_Listing]           VARCHAR (80)   NULL,
    [Language_Code]           INT            NULL,
    [Ref_Language_Key]        INT            NULL,
    [Ref_BMS_ProgramCategroy] INT            NULL,
    [Episode_Title]           VARCHAR (80)   NULL,
    [Episode_Season]          VARCHAR (20)   NULL,
    [Episode_Number]          VARCHAR (20)   NULL,
    [Synopsis]                VARCHAR (MAX)  NULL,
    [Is_Archived]             BIT            NULL,
    [Request_Time]            DATETIME       NULL,
    [Response_Time]           DATETIME       NULL,
    [Record_Status]           VARCHAR (5)    NULL,
    [Error_Description]       VARCHAR (4000) NULL,
    [RU_ProgramCategory_Code] INT            NULL,
    [IS_Consider]             CHAR (1)       DEFAULT ('Y') NULL,
    CONSTRAINT [PK_BV_Asset] PRIMARY KEY CLUSTERED ([BMS_Asset_Code] ASC)
);



