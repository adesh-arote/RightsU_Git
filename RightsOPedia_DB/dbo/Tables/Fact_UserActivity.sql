CREATE TABLE [dbo].[Fact_UserActivity] (
    [UserActivityId]           INT IDENTITY (1, 1) NOT NULL,
    [TimeId]                   INT NOT NULL,
    [UserId]                   INT NOT NULL,
    [DepartmentId]             INT NOT NULL,
    [SecurityGroupId]          INT NOT NULL,
    [SiteVisits]               INT NOT NULL,
    [NumberOfThumbsUp]         INT NOT NULL,
    [NumberOfThumbsDown]       INT NOT NULL,
    [NumberOfFeedbackMessages] INT NOT NULL,
    CONSTRAINT [PK_Fact_UserActivity] PRIMARY KEY CLUSTERED ([UserActivityId] ASC)
);

