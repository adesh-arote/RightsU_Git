CREATE TABLE [dbo].[BMS_WBS] (
    [BMS_WBS_Code]      INT            IDENTITY (1, 1) NOT NULL,
    [SAP_WBS_Code]      INT            NULL,
    [WBS_Code]          VARCHAR (50)   NULL,
    [WBS_Description]   VARCHAR (100)  NULL,
    [Short_ID]          VARCHAR (20)   NULL,
    [Is_Archive]        CHAR (1)       NULL,
    [Status]            VARCHAR (5)    NULL,
    [Error_Details]     VARCHAR (150)  NULL,
    [Is_Process]        CHAR (1)       NULL,
    [File_Code]         BIGINT         NULL,
    [BMS_Key]           INT            NULL,
    [Response_Type]     VARCHAR (1000) NULL,
    [Response_Status]   VARCHAR (1000) NULL,
    [Request_Time]      DATETIME       NULL,
    [Response_Time]     DATETIME       NULL,
    [Error_Description] VARCHAR (MAX)  NULL,
    CONSTRAINT [PK_BMS_WBS] PRIMARY KEY CLUSTERED ([BMS_WBS_Code] ASC),
    CONSTRAINT [FK_BMS_WBS_SAP_WBS] FOREIGN KEY ([SAP_WBS_Code]) REFERENCES [dbo].[SAP_WBS] ([SAP_WBS_Code])
);

