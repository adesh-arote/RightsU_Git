CREATE TABLE [dbo].[Report_Territory] (
    [Report_Territory_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Report_Territory_Name] VARCHAR (1000) NULL,
    [Is_Active]             CHAR (1)       NULL,
    CONSTRAINT [PK_Report_Territory] PRIMARY KEY CLUSTERED ([Report_Territory_Code] ASC)
);

