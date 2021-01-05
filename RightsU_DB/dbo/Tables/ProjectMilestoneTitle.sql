CREATE TABLE [dbo].[ProjectMilestoneTitle] (
    [ProjectMilestoneTitleCode] INT            IDENTITY (1, 1) NOT NULL,
    [ProjectMilestoneCode]      INT            NULL,
    [ProspectTitleName]         NVARCHAR (500) NULL,
    PRIMARY KEY CLUSTERED ([ProjectMilestoneTitleCode] ASC),
    CONSTRAINT [FK_ProjectMilestoneTitle] FOREIGN KEY ([ProjectMilestoneCode]) REFERENCES [dbo].[ProjectMilestone] ([ProjectMilestoneCode])
);

