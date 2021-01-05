CREATE TABLE [dbo].[Acq_Deal_Promoter_Import_Data] (
    [Acq_Deal_Promoter_Import_Data_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Agreement_No]                       VARCHAR (100)  NULL,
    [Promoter_Group_Level_1]             NVARCHAR (MAX) NULL,
    [Promoter_Group_Level_2]             NVARCHAR (MAX) NULL,
    [Promoter_Remarks]                   NVARCHAR (MAX) NULL,
    [ErrorMsg]                           VARCHAR (100)  NULL,
    [Is_Valid]                           CHAR (1)       NULL
);

