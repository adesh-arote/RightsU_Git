CREATE TABLE [dbo].[Import_Log] (
    [Import_Log_Code]       INT          IDENTITY (1, 1) NOT NULL,
    [Record_Code]           INT          NULL,
    [Record_Type]           CHAR (1)     NULL,
    [Process_Start]         DATETIME     NULL,
    [Process_End]           DATETIME     NULL,
    [Short_Status_Code]     VARCHAR (20) NULL,
    [Sub_Short_Status_Code] VARCHAR (20) NULL,
    [Last_Update_On]        DATETIME     NULL,
    [Is_Reprocessed]        CHAR (1)     NULL,
    PRIMARY KEY CLUSTERED ([Import_Log_Code] ASC)
);

