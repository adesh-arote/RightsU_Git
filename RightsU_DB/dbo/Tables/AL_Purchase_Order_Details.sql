CREATE TABLE [dbo].[AL_Purchase_Order_Details] (
    [AL_Purchase_Order_Details_Code] INT           IDENTITY (1, 1) NOT NULL,
    [AL_Proposal_Code]               INT           NULL,
    [PO_Number]                      VARCHAR (50)  NULL,
    [LP_Start]                       DATE          NULL,
    [LP_End]                         DATE          NULL,
    [Title_Code]                     INT           NULL,
    [Title_Content_Code]             INT           NULL,
    [Vendor_Code]                    INT           NULL,
    [Status]                         CHAR (1)      NULL,
    [Excel_File_Name]                VARCHAR (200) NULL,
    [PDF_File_Name]                  VARCHAR (200) NULL,
    [Generated_On]                   DATETIME      NULL,
    CONSTRAINT [PK_AL_Purchase_Order_Details] PRIMARY KEY CLUSTERED ([AL_Purchase_Order_Details_Code] ASC),
    CONSTRAINT [FK_AL_Purchase_Order_Details_AL_Proposal] FOREIGN KEY ([AL_Proposal_Code]) REFERENCES [dbo].[AL_Proposal] ([AL_Proposal_Code]),
    CONSTRAINT [FK_AL_Purchase_Order_Details_Title] FOREIGN KEY ([Title_Code]) REFERENCES [dbo].[Title] ([Title_Code]),
    CONSTRAINT [FK_AL_Purchase_Order_Details_Title_Content] FOREIGN KEY ([Title_Content_Code]) REFERENCES [dbo].[Title_Content] ([Title_Content_Code]),
    CONSTRAINT [FK_AL_Purchase_Order_Details_Vendor] FOREIGN KEY ([Vendor_Code]) REFERENCES [dbo].[Vendor] ([Vendor_Code])
);

