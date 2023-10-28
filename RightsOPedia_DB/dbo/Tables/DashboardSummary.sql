CREATE TABLE [dbo].[DashboardSummary] (
    [DashboardSummaryId]   INT         IDENTITY (1, 1) NOT NULL,
    [Period]               VARCHAR (1) NOT NULL,
    [ReportDate]           DATE        NOT NULL,
    [DepartmentId]         INT         NOT NULL,
    [NumberOfVisits]       INT         CONSTRAINT [DF_DashboardSummary_NumberOfVisits] DEFAULT ((0)) NOT NULL,
    [NumberOfUniqueVisits] INT         CONSTRAINT [DF_DashboardSummary_NumberOfUniqueVisits] DEFAULT ((0)) NOT NULL,
    [NumberOfNewVisits]    INT         CONSTRAINT [DF_DashboardSummary_NumberOfNewVisits] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_DashboardSummary] PRIMARY KEY CLUSTERED ([DashboardSummaryId] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UIDX_Period_ReportDate_DepartmentId]
    ON [dbo].[DashboardSummary]([Period] ASC, [ReportDate] ASC, [DepartmentId] ASC);

