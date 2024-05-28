CREATE TABLE [dbo].[Milestone_Nature] (
    [Milestone_Nature_Code] INT             IDENTITY (1, 1) NOT NULL,
    [Milestone_Nature_Name] NVARCHAR (2000) NULL,
    [Inserted_On]           DATETIME        NULL,
    [Inserted_by]           INT             NULL,
    [Last_Updated_Time]     DATETIME        NULL,
    [Last_Action_By]        INT             NULL,
    [Is_Active]             CHAR (1)        NULL,
    [Lock_Time]             TIME (7)        NULL,
    PRIMARY KEY CLUSTERED ([Milestone_Nature_Code] ASC)
);

