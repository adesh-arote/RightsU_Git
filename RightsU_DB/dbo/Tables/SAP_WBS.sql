CREATE TABLE [dbo].[SAP_WBS] (
    [SAP_WBS_Code]    INT            IDENTITY (1, 1) NOT NULL,
    [WBS_Code]        VARCHAR (50)   NULL,
    [WBS_Description] NVARCHAR (200) NULL,
    [Studio_Vendor]   NVARCHAR (300) NULL,
    [Original_Dubbed] VARCHAR (50)   NULL,
    [Status]          VARCHAR (10)   NULL,
    [Sport_Type]      VARCHAR (50)   NULL,
    [Insert_On]       DATETIME       NULL,
    [File_Code]       INT            NULL,
    [Short_ID]        VARCHAR (16)   NULL,
    [BMS_Key]         INT            NULL,
    CONSTRAINT [PK_SAP_WBS_Log] PRIMARY KEY CLUSTERED ([SAP_WBS_Code] ASC)
);

