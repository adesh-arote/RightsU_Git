CREATE TABLE [dbo].[ProjectMilestoneDetail] (
    [ProjectMilestoneDetailCode] INT            IDENTITY (1, 1) NOT NULL,
    [ProjectMilestoneCode]       INT            NULL,
    [MilestoneName]              NVARCHAR (500) NULL,
    [MileStoneDate]              DATETIME       NULL,
    [Remarks]                    NVARCHAR (MAX) NULL,
    PRIMARY KEY CLUSTERED ([ProjectMilestoneDetailCode] ASC),
    CONSTRAINT [FK_ProjectMilestoneDetail] FOREIGN KEY ([ProjectMilestoneCode]) REFERENCES [dbo].[ProjectMilestone] ([ProjectMilestoneCode])
);

