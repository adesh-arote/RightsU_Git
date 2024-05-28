CREATE TABLE [dbo].[Approval_Email_BU] (
    [Approval_Email_BU_Code] INT           IDENTITY (1, 1) NOT NULL,
    [Business_Unit_Code]     INT           NULL,
    [Email_Id]               VARCHAR (100) NULL,
    CONSTRAINT [PK_Approval_Email_BU] PRIMARY KEY CLUSTERED ([Approval_Email_BU_Code] ASC)
);

