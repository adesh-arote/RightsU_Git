CREATE TABLE [dbo].[DashboardUserSummary] (
    [DashboardUserSummaryId]   INT         IDENTITY (1, 1) NOT NULL,
    [UserId]                   INT         NOT NULL,
    [ReportType]               VARCHAR (1) NULL,
    [Year]                     INT         NULL,
    [Month]                    INT         NULL,
    [UnitNumber]               INT         NULL,
    [NumberOfLogins]           INT         CONSTRAINT [DF_DashboardUserSummary_NumberOfLogins] DEFAULT ((0)) NULL,
    [NumberOfUniqueLogins]     INT         CONSTRAINT [DF_DashboardUserSummary_NumberOfUniqueLogins] DEFAULT ((0)) NULL,
    [LastLoggedInAt]           DATETIME    NULL,
    [NumberOfThumbsUp]         INT         CONSTRAINT [DF_DashboardUserSummary_NumberOfThumbsUp] DEFAULT ((0)) NULL,
    [NumberOfThumbsDown]       INT         CONSTRAINT [DF_DashboardUserSummary_NumberOfThumbsDown] DEFAULT ((0)) NULL,
    [NumberOfFeedbackMessages] INT         CONSTRAINT [DF_DashboardUserSummary_NumberOfFeedbackMessages] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_DashboardUserSummary] PRIMARY KEY CLUSTERED ([DashboardUserSummaryId] ASC)
);

