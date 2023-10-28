CREATE TABLE [dbo].[ReportFeedback] (
    [ReportFeedbackID] INT           IDENTITY (1, 1) NOT NULL,
    [ReportCode]       INT           NULL,
    [Request]          VARCHAR (MAX) NULL,
    [RequestTime]      DATETIME      NULL,
    [IsSatisfied]      CHAR (2)      NULL,
    [UserComments]     VARCHAR (MAX) NULL,
    [UsersCode]        INT           NULL,
    PRIMARY KEY CLUSTERED ([ReportFeedbackID] ASC)
);

