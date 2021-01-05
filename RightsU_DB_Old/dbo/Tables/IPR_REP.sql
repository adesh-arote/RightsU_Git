CREATE TABLE [dbo].[IPR_REP] (
    [IPR_Rep_Code]                     INT             IDENTITY (1, 1) NOT NULL,
    [Trademark_No]                     VARCHAR (20)    NULL,
    [Trademark]                        NVARCHAR (100)  NULL,
    [IPR_Type_Code]                    INT             NULL,
    [Application_No]                   NVARCHAR (50)   NULL,
    [Application_Date]                 DATETIME        NULL,
    [Country_Code]                     INT             NULL,
    [Proposed_Or_Date]                 CHAR (1)        NULL,
    [Date_Of_Use]                      DATETIME        NULL,
    [Application_Status_Code]          INT             NULL,
    [Renewed_Until]                    DATETIME        NULL,
    [Applicant_Code]                   INT             NULL,
    [Trademark_Attorney]               NVARCHAR (100)  NULL,
    [Comments]                         NVARCHAR (1000) NULL,
    [Creation_Date]                    DATETIME        NULL,
    [Created_By]                       INT             NULL,
    [Version]                          VARCHAR (20)    NULL,
    [Workflow_Status]                  VARCHAR (50)    NULL,
    [Class_Comments]                   NVARCHAR (2000) NULL,
    [Date_Of_Actual_Use]               DATETIME        NULL,
    [International_Trademark_Attorney] NVARCHAR (MAX)  NULL,
    [Date_Of_Registration]             DATETIME        NULL,
    [Registration_No]                  NVARCHAR (200)  NULL,
    [IPR_For]                          CHAR (1)        NULL,
    CONSTRAINT [PK_IPR_REP] PRIMARY KEY CLUSTERED ([IPR_Rep_Code] ASC),
    CONSTRAINT [FK_IPR_REP_IPR_APP_STATUS] FOREIGN KEY ([Application_Status_Code]) REFERENCES [dbo].[IPR_APP_STATUS] ([IPR_App_Status_Code]),
    CONSTRAINT [FK_IPR_REP_IPR_Country] FOREIGN KEY ([Country_Code]) REFERENCES [dbo].[IPR_Country] ([IPR_Country_Code]),
    CONSTRAINT [FK_IPR_REP_IPR_ENTITY] FOREIGN KEY ([Applicant_Code]) REFERENCES [dbo].[IPR_ENTITY] ([IPR_Entity_Code]),
    CONSTRAINT [FK_IPR_REP_IPR_TYPE] FOREIGN KEY ([IPR_Type_Code]) REFERENCES [dbo].[IPR_TYPE] ([IPR_Type_Code])
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'It contains ''D'' for ''Domestic'', ''I'' for ''International''', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IPR_REP', @level2type = N'COLUMN', @level2name = N'IPR_For';

