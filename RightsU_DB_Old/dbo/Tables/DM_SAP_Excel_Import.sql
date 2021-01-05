CREATE TABLE [dbo].[DM_SAP_Excel_Import] (
    [Deal_Code]          FLOAT (53)     NULL,
    [Deal_No]            NVARCHAR (255) NULL,
    [Title_Code]         FLOAT (53)     NULL,
    [Title]              NVARCHAR (255) NULL,
    [Deal_Title]         NVARCHAR (255) NULL,
    [Episode_No]         FLOAT (53)     NULL,
    [Licensor]           NVARCHAR (255) NULL,
    [Deal Description]   NVARCHAR (255) NULL,
    [Deal_For]           NVARCHAR (255) NULL,
    [Milestone]          NVARCHAR (255) NULL,
    [Rights_Term]        FLOAT (53)     NULL,
    [License_Start_Date] DATETIME       NULL,
    [License_End_Date]   DATETIME       NULL,
    [BV_Program_Item_Id] FLOAT (53)     NULL,
    [Business_Unit]      NVARCHAR (255) NULL,
    [WBS_Code]           NVARCHAR (255) NULL,
    [Is_Valid]           CHAR (1)       NULL,
    [Valid_Data_Flag]    VARCHAR (MAX)  NULL,
    [Error_Message]      VARCHAR (MAX)  NULL
);

