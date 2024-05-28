CREATE TABLE [dbo].[AT_Syn_Deal] (
    [AT_Syn_Deal_Code]         INT             IDENTITY (1, 1) NOT NULL,
    [Syn_Deal_Code]            INT             NULL,
    [Deal_Type_Code]           INT             NULL,
    [Business_Unit_Code]       INT             NULL,
    [Other_Deal]               VARCHAR (100)   NULL,
    [Agreement_No]             VARCHAR (50)    NULL,
    [Version]                  VARCHAR (50)    NULL,
    [Agreement_Date]           DATETIME        NULL,
    [Deal_Description]         NVARCHAR (250)  NULL,
    [Status]                   CHAR (1)        NULL,
    [Total_Sale]               FLOAT (53)      NULL,
    [Year_Type]                CHAR (2)        NULL,
    [Customer_Type]            INT             NULL,
    [Vendor_Code]              INT             NULL,
    [Vendor_Contact_Code]      INT             NULL,
    [Sales_Agent_Code]         INT             NULL,
    [Sales_Agent_Contact_Code] INT             NULL,
    [Entity_Code]              INT             NULL,
    [Currency_Code]            INT             NULL,
    [Exchange_Rate]            NUMERIC (10, 3) NULL,
    [Ref_No]                   NVARCHAR (50)   NULL,
    [Attach_Workflow]          CHAR (1)        CONSTRAINT [DF_AT_Syn_Deal_Attach_Workflow] DEFAULT ('N') NULL,
    [Deal_Workflow_Status]     VARCHAR (50)    CONSTRAINT [DF_AT_Syn_Deal_Deal_Workflow_Status] DEFAULT ('N') NULL,
    [Work_Flow_Code]           INT             NULL,
    [Is_Completed]             CHAR (1)        CONSTRAINT [DF_AT_Syn_Deal_Is_Completed] DEFAULT ('N') NULL,
    [Category_Code]            INT             NULL,
    [Parent_AT_Syn_Deal_Code]  INT             NULL,
    [Is_Migrated]              CHAR (1)        CONSTRAINT [DF_AT_Syn_Deal_Is_Migrated] DEFAULT ('N') NULL,
    [Payment_Terms_Conditions] NVARCHAR (4000) NULL,
    [Deal_Tag_Code]            INT             NULL,
    [Ref_BMS_Code]             VARCHAR (100)   NULL,
    [Remarks]                  NVARCHAR (4000) NULL,
    [Rights_Remarks]           NVARCHAR (4000) NULL,
    [Payment_Remarks]          NVARCHAR (4000) NULL,
    [Is_Active]                CHAR (1)        NULL,
    [Inserted_On]              DATETIME        NULL,
    [Inserted_By]              INT             NULL,
    [Lock_Time]                DATETIME        NULL,
    [Last_Updated_Time]        DATETIME        NULL,
    [Last_Action_By]           INT             NULL,
    [Deal_Complete_Flag]       VARCHAR (100)   NULL,
    CONSTRAINT [PK_AT_Syn_Deal] PRIMARY KEY CLUSTERED ([AT_Syn_Deal_Code] ASC),
    CONSTRAINT [FK_AT_Syn_Deal_Business_Unit] FOREIGN KEY ([Business_Unit_Code]) REFERENCES [dbo].[Business_Unit] ([Business_Unit_Code]),
    CONSTRAINT [FK_AT_Syn_Deal_Category] FOREIGN KEY ([Category_Code]) REFERENCES [dbo].[Category] ([Category_Code]),
    CONSTRAINT [FK_AT_Syn_Deal_Currency] FOREIGN KEY ([Currency_Code]) REFERENCES [dbo].[Currency] ([Currency_Code]),
    CONSTRAINT [FK_AT_Syn_Deal_Deal_Tag] FOREIGN KEY ([Deal_Tag_Code]) REFERENCES [dbo].[Deal_Tag] ([Deal_Tag_Code]),
    CONSTRAINT [FK_AT_Syn_Deal_Deal_Type] FOREIGN KEY ([Deal_Type_Code]) REFERENCES [dbo].[Deal_Type] ([Deal_Type_Code]),
    CONSTRAINT [FK_AT_Syn_Deal_Entity] FOREIGN KEY ([Entity_Code]) REFERENCES [dbo].[Entity] ([Entity_Code]),
    CONSTRAINT [FK_AT_Syn_Deal_Vendor] FOREIGN KEY ([Vendor_Code]) REFERENCES [dbo].[Vendor] ([Vendor_Code]),
    CONSTRAINT [FK_AT_Syn_Deal_Vendor_Contacts] FOREIGN KEY ([Vendor_Contact_Code]) REFERENCES [dbo].[Vendor_Contacts] ([Vendor_Contacts_Code]),
    CONSTRAINT [FK_AT_Syn_Deal_Workflow] FOREIGN KEY ([Work_Flow_Code]) REFERENCES [dbo].[Workflow] ([Workflow_Code])
);


GO
ALTER TABLE [dbo].[AT_Syn_Deal] NOCHECK CONSTRAINT [FK_AT_Syn_Deal_Deal_Type];




GO
ALTER TABLE [dbo].[AT_Syn_Deal] NOCHECK CONSTRAINT [FK_AT_Syn_Deal_Deal_Type];


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Added by Gajanan for workflow and set at the time of insert deal from globalParam.deal_AttachWorkFlow_Yes ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'AT_Syn_Deal', @level2type = N'COLUMN', @level2name = N'Attach_Workflow';

