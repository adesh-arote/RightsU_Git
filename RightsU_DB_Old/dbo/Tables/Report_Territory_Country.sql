CREATE TABLE [dbo].[Report_Territory_Country] (
    [Report_Territory_Country_Code] INT IDENTITY (1, 1) NOT NULL,
    [Report_Territory_Code]         INT NULL,
    [Country_Code]                  INT NULL,
    CONSTRAINT [PK_Report_Territory_Country] PRIMARY KEY CLUSTERED ([Report_Territory_Country_Code] ASC),
    CONSTRAINT [FK_Report_Territory_Country_Country] FOREIGN KEY ([Country_Code]) REFERENCES [dbo].[Country] ([Country_Code]),
    CONSTRAINT [FK_Report_Territory_Country_Report_Territory] FOREIGN KEY ([Report_Territory_Code]) REFERENCES [dbo].[Report_Territory] ([Report_Territory_Code])
);

