CREATE TABLE [dbo].[Report_Condition] (
    [Report_Condition_Code] BIGINT         IDENTITY (1, 1) NOT NULL,
    [Query_Code]            INT            NOT NULL,
    [Left_Col_Dbname]       VARCHAR (50)   NULL,
    [Right_Value]           NVARCHAR (MAX) NULL,
    [The_Op]                VARCHAR (10)   NULL,
    [Logical_Connect]       VARCHAR (3)    NULL,
    CONSTRAINT [PK_Report_Condition] PRIMARY KEY CLUSTERED ([Report_Condition_Code] ASC)
);

