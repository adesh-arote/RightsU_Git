CREATE TABLE [dbo].[Acq_Deal_Cost_Additional_Exp] (
    [Acq_Deal_Cost_Additional_Exp_Code] INT             IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Cost_Code]                INT             NULL,
    [Additional_Expense_Code]           INT             NULL,
    [Amount]                            DECIMAL (38, 3) NULL,
    [Min_Max]                           CHAR (3)        NULL,
    [Inserted_On]                       DATETIME        NOT NULL,
    [Inserted_By]                       INT             NOT NULL,
    [Last_Updated_Time]                 DATETIME        NULL,
    [Last_Action_By]                    INT             NULL,
    CONSTRAINT [PK_Acq_Deal_Cost_Additional_Exp] PRIMARY KEY CLUSTERED ([Acq_Deal_Cost_Additional_Exp_Code] ASC),
    CONSTRAINT [FK_Acq_Deal_Cost_Additional_Exp_Acq_Deal_Cost] FOREIGN KEY ([Acq_Deal_Cost_Code]) REFERENCES [dbo].[Acq_Deal_Cost] ([Acq_Deal_Cost_Code]),
    CONSTRAINT [FK_Acq_Deal_Cost_Additional_Exp_Additional_Expense] FOREIGN KEY ([Additional_Expense_Code]) REFERENCES [dbo].[Additional_Expense] ([Additional_Expense_Code])
);

