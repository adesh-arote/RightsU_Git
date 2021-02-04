CREATE TABLE [dbo].[Report_Territory_Country] (
    [Report_Territory_Country_Code] INT IDENTITY (1, 1) NOT NULL,
    [Report_Territory_Code]         INT NULL,
    [Country_Code]                  INT NULL,
    CONSTRAINT [PK_Report_Territory_Country] PRIMARY KEY CLUSTERED ([Report_Territory_Country_Code] ASC)
);

