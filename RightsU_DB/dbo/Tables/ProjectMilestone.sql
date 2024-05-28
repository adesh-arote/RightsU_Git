CREATE TABLE [dbo].[ProjectMilestone] (
    [ProjectMilestoneCode]  INT            IDENTITY (1, 1) NOT NULL,
    [AgreementNo]           VARCHAR (100)  NULL,
    [AgreementDate]         DATETIME       NULL,
    [ProjectName]           NVARCHAR (500) NULL,
    [MileStone_Nature_Code] INT            NULL,
    [TalentCode]            INT            NULL,
    [PeriodType]            CHAR (1)       NULL,
    [StartDate]             DATETIME       NULL,
    [EndDate]               DATETIME       NULL,
    [Milestone_Type_Code]   INT            NULL,
    [Milestone_No_Of_Unit]  INT            NULL,
    [Milestone_Unit_Type]   INT            NULL,
    [IsClosed]              CHAR (1)       NULL,
    [IsTentitive]           CHAR (1)       NULL,
    [Term]                  VARCHAR (12)   NULL,
    [Version]               VARCHAR (50)   NULL,
    [WorkflowStatus]        VARCHAR (50)   NULL,
    PRIMARY KEY CLUSTERED ([ProjectMilestoneCode] ASC),
    CONSTRAINT [FK_MileStone_Nature] FOREIGN KEY ([MileStone_Nature_Code]) REFERENCES [dbo].[Milestone_Nature] ([Milestone_Nature_Code]),
    CONSTRAINT [FK_MileStone_Talent] FOREIGN KEY ([TalentCode]) REFERENCES [dbo].[Talent] ([Talent_Code]),
    CONSTRAINT [FK_MileStone_Type] FOREIGN KEY ([Milestone_Type_Code]) REFERENCES [dbo].[Milestone_Type] ([Milestone_Type_Code])
);

