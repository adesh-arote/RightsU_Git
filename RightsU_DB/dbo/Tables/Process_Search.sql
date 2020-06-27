CREATE TABLE [dbo].[Process_Search] (
    [Process_Search_Code] INT         IDENTITY (1, 1) NOT NULL,
    [Record_Code]         INT         NULL,
    [Module_Name]         VARCHAR (5) NULL,
    [Created_On]          DATETIME    NULL,
    CONSTRAINT [PK_Process_Search] PRIMARY KEY CLUSTERED ([Process_Search_Code] ASC)
);

