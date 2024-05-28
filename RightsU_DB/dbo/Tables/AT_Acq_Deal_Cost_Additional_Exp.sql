CREATE TABLE [dbo].[AT_Acq_Deal_Cost_Additional_Exp] (
    [AT_Acq_Deal_Cost_Additional_Exp_Code] INT             IDENTITY (1, 1) NOT NULL,
    [AT_Acq_Deal_Cost_Code]                INT             NULL,
    [Additional_Expense_Code]              INT             NULL,
    [Amount]                               DECIMAL (38, 3) NULL,
    [Min_Max]                              CHAR (3)        NULL,
    [Inserted_On]                          DATETIME        NOT NULL,
    [Inserted_By]                          INT             NOT NULL,
    [Last_Updated_Time]                    DATETIME        NULL,
    [Last_Action_By]                       INT             NULL,
    [Acq_Deal_Cost_Additional_Exp_Code]    INT             NULL,
    CONSTRAINT [PK_AT_Acq_Deal_Cost_Additional_Exp] PRIMARY KEY CLUSTERED ([AT_Acq_Deal_Cost_Additional_Exp_Code] ASC),
    CONSTRAINT [FK_AT_Acq_Deal_Cost_Additional_Exp_Additional_Expense] FOREIGN KEY ([Additional_Expense_Code]) REFERENCES [dbo].[Additional_Expense] ([Additional_Expense_Code]),
    CONSTRAINT [FK_AT_Acq_Deal_Cost_Additional_Exp_AT_Acq_Deal_Cost] FOREIGN KEY ([AT_Acq_Deal_Cost_Code]) REFERENCES [dbo].[AT_Acq_Deal_Cost] ([AT_Acq_Deal_Cost_Code])
);

