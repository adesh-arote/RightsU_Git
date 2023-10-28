CREATE TABLE [dbo].[AL_Purchase_Order] (
    [AL_Purchase_Order_Code] INT            IDENTITY (1, 1) NOT NULL,
    [AL_Booking_Sheet_Code]  INT            NULL,
    [AL_Proposal_Code]       INT            NULL,
    [Remarks]                VARCHAR (4000) NULL,
    [Status]                 CHAR (1)       NULL,
    [Workflow_Status]        VARCHAR (5)    NULL,
    [Workflow_Code]          INT            NULL,
    [Inserted_By]            INT            NULL,
    [Inserted_On]            DATETIME       NULL,
    [Updated_By]             INT            NULL,
    [Updated_On]             DATETIME       NULL,
    [Lock_Time]              DATETIME       NULL,
    CONSTRAINT [PK_AL_Purchase_Order] PRIMARY KEY CLUSTERED ([AL_Purchase_Order_Code] ASC),
    CONSTRAINT [FK_AL_Purchase_Order_AL_Booking_Sheet] FOREIGN KEY ([AL_Booking_Sheet_Code]) REFERENCES [dbo].[AL_Booking_Sheet] ([AL_Booking_Sheet_Code]),
    CONSTRAINT [FK_AL_Purchase_Order_AL_Proposal] FOREIGN KEY ([AL_Proposal_Code]) REFERENCES [dbo].[AL_Proposal] ([AL_Proposal_Code])
);

