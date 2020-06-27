CREATE TABLE [dbo].[Avail_ExportJob] (
    [Avail_ExportJob_Code]        NUMERIC (38)   IDENTITY (1, 1) NOT NULL,
    [Avail_ExportJob_Description] VARCHAR (500)  NULL,
    [File_Name]                   VARCHAR (500)  NULL,
    [SPName]                      VARCHAR (500)  NULL,
    [P_strSearch]                 VARCHAR (8000) NULL,
    [P_strSearchDate]             VARCHAR (5000) NULL,
    [P_colCount]                  INT            NULL,
    [P_strColumnList]             VARCHAR (1000) NULL,
    [Created_By]                  INT            NULL,
    [Created_On]                  DATETIME       DEFAULT (getdate()) NULL,
    [Completed_On]                DATETIME       NULL,
    [IS_Processed]                CHAR (1)       DEFAULT ('N') NULL,
    CONSTRAINT [Avail_ExportJob_Code] PRIMARY KEY CLUSTERED ([Avail_ExportJob_Code] ASC)
);

