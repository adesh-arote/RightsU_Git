CREATE TABLE [dbo].[UTO_ExceptionLog] (
    [Exception_Log_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Exception_Log_Date] DATETIME       NOT NULL,
    [Controller_Name]    VARCHAR (1000) NULL,
    [Action_Name]        VARCHAR (1000) NULL,
    [ProcedureName]      VARCHAR (MAX)  NULL,
    [Exception]          VARCHAR (MAX)  NOT NULL,
    [Inner_Exception]    VARCHAR (MAX)  NULL,
    [StackTrace]         VARCHAR (MAX)  NOT NULL,
    [Code_Break]         VARCHAR (10)   NULL
);

