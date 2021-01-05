CREATE TABLE [dbo].[IT_CuratedReports] (
    [ReportId]       INT            IDENTITY (1, 1) NOT NULL,
    [ReportName]     NVARCHAR (MAX) NULL,
    [Users_Code]     INT            NULL,
    [Visibility]     VARCHAR (10)   NULL,
    [Criteria]       NVARCHAR (MAX) NULL,
    [CreatedOn]      DATETIME       NULL,
    [ShowCriteria]   NVARCHAR (MAX) NULL,
    [DealFor]        VARCHAR (50)   NULL,
    [BVCode]         NVARCHAR (MAX) NULL,
    [DealType]       NVARCHAR (MAX) NULL,
    [IncludeExpired] VARCHAR (10)   NULL,
    CONSTRAINT [PK_IT_CuratedReports] PRIMARY KEY CLUSTERED ([ReportId] ASC)
);

