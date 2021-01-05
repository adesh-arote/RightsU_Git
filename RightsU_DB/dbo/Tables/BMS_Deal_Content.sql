CREATE TABLE [dbo].[BMS_Deal_Content] (
    [BMS_Deal_Content_Code]    INT            IDENTITY (1, 1) NOT NULL,
    [BMS_Deal_Code]            INT            NULL,
    [BMS_Deal_Ref_Key]         DECIMAL (38)   NULL,
    [BMS_Deal_Content_Ref_Key] DECIMAL (38)   NULL,
    [BMS_Asset_Code]           INT            NULL,
    [BMS_Asset_Ref_Key]        DECIMAL (38)   NULL,
    [Asset_Type]               VARCHAR (3)    NULL,
    [Title]                    VARCHAR (80)   NULL,
    [Start_Date]               DATETIME       NULL,
    [End_Date]                 DATETIME       NULL,
    [Request_Time]             DATETIME       NULL,
    [Response_Time]            DATETIME       NULL,
    [Record_Status]            VARCHAR (5)    NULL,
    [Error_Description]        VARCHAR (4000) NULL,
    [Is_Archived]              VARCHAR (5)    NULL,
    CONSTRAINT [PK_BV_Deal_Content] PRIMARY KEY CLUSTERED ([BMS_Deal_Content_Code] ASC),
    CONSTRAINT [FK_BV_Deal_Content_BV_Deal] FOREIGN KEY ([BMS_Deal_Code]) REFERENCES [dbo].[BMS_Deal] ([BMS_Deal_Code])
);

