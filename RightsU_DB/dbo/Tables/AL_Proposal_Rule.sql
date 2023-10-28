CREATE TABLE [dbo].[AL_Proposal_Rule] (
    [AL_Proposal_Rule_Code] INT IDENTITY (1, 1) NOT NULL,
    [AL_Proposal_Code]      INT NULL,
    [AL_Vendor_Rule_Code]   INT NULL,
    [No_Of_Content]         INT NULL,
    CONSTRAINT [PK_AL_Proposal_Rule] PRIMARY KEY CLUSTERED ([AL_Proposal_Rule_Code] ASC),
    CONSTRAINT [FK_AL_Proposal_Rule_AL_Proposal] FOREIGN KEY ([AL_Proposal_Code]) REFERENCES [dbo].[AL_Proposal] ([AL_Proposal_Code]),
    CONSTRAINT [FK_AL_Proposal_Rule_AL_Vendor_Rule] FOREIGN KEY ([AL_Vendor_Rule_Code]) REFERENCES [dbo].[AL_Vendor_Rule] ([AL_Vendor_Rule_Code])
);

