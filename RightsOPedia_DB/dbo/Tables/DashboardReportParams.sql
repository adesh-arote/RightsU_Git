CREATE TABLE [dbo].[DashboardReportParams] (
    [DashboardReportParamsId]           INT      IDENTITY (1, 1) NOT NULL,
    [LastComputedAt]                    DATETIME CONSTRAINT [DF_DashboardReportParams_LastComputedAt] DEFAULT ('1-MAR-2020') NOT NULL,
    [LastComputedAtUser]                DATETIME NOT NULL,
    [LastComputedAtUserActivity]        DATETIME NOT NULL,
    [LastComputationTimeInMilliseconds] INT      NULL,
    CONSTRAINT [PK_DashboardReportParams] PRIMARY KEY CLUSTERED ([DashboardReportParamsId] ASC)
);

