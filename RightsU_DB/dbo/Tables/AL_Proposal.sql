CREATE TABLE [dbo].[AL_Proposal] (
    [AL_Proposal_Code]  INT          IDENTITY (1, 1) NOT NULL,
    [Vendor_Code]       INT          NULL,
    [Start_Date]        DATE         NULL,
    [End_Date]          DATE         NULL,
    [Proposal_No]       VARCHAR (50) NULL,
    [Version_No]        VARCHAR (5)  NULL,
    [Workflow_Status]   VARCHAR (5)  NULL,
    [Refresh_Cycle]     INT          NULL,
    [Inserted_By]       INT          NULL,
    [Inserted_On]       DATETIME     NULL,
    [Last_Updated_Time] DATETIME     NULL,
    [Last_Action_By]    INT          NULL,
    [Lock_Time]         DATETIME     NULL,
    CONSTRAINT [PK_AL_Proposal] PRIMARY KEY CLUSTERED ([AL_Proposal_Code] ASC),
    CONSTRAINT [FK_AL_Proposal_Vendor] FOREIGN KEY ([Vendor_Code]) REFERENCES [dbo].[Vendor] ([Vendor_Code])
);

