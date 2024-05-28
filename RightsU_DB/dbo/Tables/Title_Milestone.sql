CREATE TABLE [dbo].[Title_Milestone] (
    [Title_Milestone_Code]  INT            IDENTITY (1, 1) NOT NULL,
    [Title_Code]            INT            NULL,
    [Talent_Code]           INT            NULL,
    [Milestone_Nature_Code] INT            NULL,
    [Expiry_Date]           DATETIME       NULL,
    [Milestone]             NVARCHAR (MAX) NULL,
    [Action_Item]           NVARCHAR (MAX) NULL,
    [Is_Abandoned]          CHAR (1)       NULL,
    [Remarks]               NVARCHAR (MAX) NULL,
    [Inserted_On]           DATETIME       NULL,
    [Inserted_by]           INT            NULL,
    [Last_Updated_Time]     DATETIME       NULL,
    [Last_Action_By]        INT            NULL,
    [Is_Active]             CHAR (1)       NULL,
    [Lock_Time]             TIME (7)       NULL,
    PRIMARY KEY CLUSTERED ([Title_Milestone_Code] ASC),
    FOREIGN KEY ([Milestone_Nature_Code]) REFERENCES [dbo].[Milestone_Nature] ([Milestone_Nature_Code]),
    FOREIGN KEY ([Talent_Code]) REFERENCES [dbo].[Talent] ([Talent_Code]),
    FOREIGN KEY ([Title_Code]) REFERENCES [dbo].[Title] ([Title_Code])
);

