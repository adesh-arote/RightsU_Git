CREATE TABLE [dbo].[Report_Format] (
    [Report_Format_Code] INT           IDENTITY (1, 1) NOT NULL,
    [Format]             VARCHAR (100) NULL,
    [Format_Type]        CHAR (1)      NULL,
    [Result]             VARCHAR (100) NULL,
    [Order_By]           INT           NULL,
    CONSTRAINT [PK_Report_Format] PRIMARY KEY CLUSTERED ([Report_Format_Code] ASC)
);

