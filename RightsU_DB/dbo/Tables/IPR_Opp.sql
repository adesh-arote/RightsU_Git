CREATE TABLE [dbo].[IPR_Opp] (
    [IPR_Opp_Code]               INT             IDENTITY (1, 1) NOT NULL,
    [Version]                    VARCHAR (20)    NULL,
    [IPR_For]                    CHAR (1)        NULL,
    [Opp_No]                     NVARCHAR (100)  NULL,
    [IPR_Rep_Code]               INT             NULL,
    [Party_Name]                 NVARCHAR (500)  NULL,
    [Trademark]                  NVARCHAR (50)   NULL,
    [Application_No]             NVARCHAR (50)   NULL,
    [IPR_Class_Code]             INT             NULL,
    [IPR_App_Status_Code]        INT             NULL,
    [Journal_No]                 NVARCHAR (100)  NULL,
    [Publication_Date]           DATETIME        NULL,
    [Page_No]                    VARCHAR (50)    NULL,
    [Date_Counter_Statement]     DATETIME        NULL,
    [Date_Evidence_UR50]         DATETIME        NULL,
    [Date_Evidence_UR51]         DATETIME        NULL,
    [Date_Opposition_Notice]     DATETIME        NULL,
    [Date_Rebuttal_UR52]         DATETIME        NULL,
    [Deadline_Counter_Statement] DATETIME        NULL,
    [Deadline_Evidence_UR50]     DATETIME        NULL,
    [Deadline_Evidence_UR51]     DATETIME        NULL,
    [Deadline_Opposition_Notice] DATETIME        NULL,
    [Deadline_Rebuttal_UR52]     DATETIME        NULL,
    [Order_Date]                 DATETIME        NULL,
    [Outcomes]                   NVARCHAR (1000) NULL,
    [Comments]                   NVARCHAR (1000) NULL,
    [Creation_Date]              DATETIME        NULL,
    [Created_By]                 INT             NULL,
    [Workflow_Status]            VARCHAR (50)    NULL,
    [IPR_Opp_Status_Code]        INT             NULL,
    CONSTRAINT [PK_IPR_Opp] PRIMARY KEY CLUSTERED ([IPR_Opp_Code] ASC),
    CONSTRAINT [FK_IPR_Opp_IPR_APP_STATUS] FOREIGN KEY ([IPR_App_Status_Code]) REFERENCES [dbo].[IPR_APP_STATUS] ([IPR_App_Status_Code]),
    CONSTRAINT [FK_IPR_Opp_IPR_CLASS] FOREIGN KEY ([IPR_Class_Code]) REFERENCES [dbo].[IPR_CLASS] ([IPR_Class_Code]),
    CONSTRAINT [FK_IPR_Opp_IPR_Opp_Status] FOREIGN KEY ([IPR_Opp_Status_Code]) REFERENCES [dbo].[IPR_Opp_Status] ([IPR_Opp_Status_Code]),
    CONSTRAINT [FK_IPR_Opp_IPR_REP] FOREIGN KEY ([IPR_Rep_Code]) REFERENCES [dbo].[IPR_REP] ([IPR_Rep_Code])
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IPR_Opp', @level2type = N'COLUMN', @level2name = N'IPR_Opp_Code';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'It contains ''B'' for ''Opposite By'', ''A'' for ''Opposite Against''', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IPR_Opp', @level2type = N'COLUMN', @level2name = N'IPR_For';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'It will contain value of ''Date of Receipt of Counter Statement'' for ''Oposition By'' and ''Date of filling of Counter Statement'' for ''Opposition Against''', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IPR_Opp', @level2type = N'COLUMN', @level2name = N'Date_Counter_Statement';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'It will contain value of ''Date of filing Evidence u/r 50'' for ''Oposition By'' and ''Date of receipt of Evidence u/r 50'' for ''Opposition Against''', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IPR_Opp', @level2type = N'COLUMN', @level2name = N'Date_Evidence_UR50';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'It will contain value of ''Date of receipt of Evidence u/r 51'' for ''Oposition By'' and ''Date of filling Evidence u/r 51'' for ''Opposition Against''', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IPR_Opp', @level2type = N'COLUMN', @level2name = N'Date_Evidence_UR51';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'It will contain value of ''Date of filing of Notice of Opposition'' for ''Oposition By'' and ''Date of Receipt of Notice of Opposition'' for ''Opposition Against''', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IPR_Opp', @level2type = N'COLUMN', @level2name = N'Date_Opposition_Notice';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'It will contain value of ''Date of filling Rebuttal u/r 52'' for ''Oposition By'' and ''Date of receipt of Rebuttal u/r 52'' for ''Opposition Against''', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IPR_Opp', @level2type = N'COLUMN', @level2name = N'Date_Rebuttal_UR52';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'It will contain value of ''Deadline for filing Counter Statement'' for ''Oposition By'' and ''Deadline for filing Counter Statement'' for ''Opposition Against''', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IPR_Opp', @level2type = N'COLUMN', @level2name = N'Deadline_Counter_Statement';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'It will contain value of ''Deadline for filing Evidence u/r 50'' for ''Oposition By'' and ''Deadline to file Evidence u/r 50'' for ''Opposition Against''', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IPR_Opp', @level2type = N'COLUMN', @level2name = N'Deadline_Evidence_UR50';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'It will contain value of ''Deadline to file Evidence u/r 51'' for ''Oposition By'' and ''Deadline for filing Evidence u/r 51'' for ''Opposition Against''', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IPR_Opp', @level2type = N'COLUMN', @level2name = N'Deadline_Evidence_UR51';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'It will contain value of ''Deadline for filing of Notice of Opposition'' for ''Opposition Against''', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IPR_Opp', @level2type = N'COLUMN', @level2name = N'Deadline_Opposition_Notice';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'It will contain value of ''Deadline to file Rebuttal u/r 52'' for ''Oposition By'' and ''Deadline to file Rebuttal u/r 52'' for ''Opposition Against''', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IPR_Opp', @level2type = N'COLUMN', @level2name = N'Deadline_Rebuttal_UR52';

