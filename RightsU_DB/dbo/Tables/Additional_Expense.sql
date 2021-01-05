CREATE TABLE [dbo].[Additional_Expense] (
    [Additional_Expense_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Additional_Expense_Name] NVARCHAR (200) NULL,
    [SAP_GL_Group_Code]       NVARCHAR (200) NULL,
    [Inserted_On]             DATETIME       NULL,
    [Inserted_By]             INT            NULL,
    [Lock_Time]               DATETIME       NULL,
    [Last_Updated_Time]       DATETIME       NULL,
    [Last_Action_By]          INT            NULL,
    [Is_Active]               CHAR (1)       CONSTRAINT [DF_Additional_Expense_Is_Active] DEFAULT ('Y') NULL,
    CONSTRAINT [PK_Additional_Expense] PRIMARY KEY CLUSTERED ([Additional_Expense_Code] ASC)
);

