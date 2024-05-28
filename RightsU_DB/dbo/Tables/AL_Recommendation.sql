CREATE TABLE [dbo].[AL_Recommendation] (
    [AL_Recommendation_Code] INT            IDENTITY (1, 1) NOT NULL,
    [AL_Proposal_Code]       INT            NULL,
    [Start_Date]             DATE           NULL,
    [End_Date]               DATE           NULL,
    [Refresh_Cycle_No]       INT            NULL,
    [Version_No]             VARCHAR (5)    NULL,
    [Finally_Closed]         CHAR (1)       NULL,
    [Remarks]                NVARCHAR (MAX) NULL,
    [Workflow_Status]        VARCHAR (5)    NULL,
    [Workflow_Code]          INT            NULL,
    [Excel_File]             VARCHAR (100)  NULL,
    [PDF_File]               VARCHAR (100)  NULL,
    [Inserted_By]            INT            NULL,
    [Inserted_On]            DATETIME       NULL,
    [Last_Updated_Time]      DATETIME       NULL,
    [Last_Action_By]         INT            NULL,
    [Lock_Time]              DATETIME       NULL,
    CONSTRAINT [PK_AL_Recommendation] PRIMARY KEY CLUSTERED ([AL_Recommendation_Code] ASC),
    CONSTRAINT [FK_AL_Recommendation_AL_Proposal] FOREIGN KEY ([AL_Proposal_Code]) REFERENCES [dbo].[AL_Proposal] ([AL_Proposal_Code])
);

