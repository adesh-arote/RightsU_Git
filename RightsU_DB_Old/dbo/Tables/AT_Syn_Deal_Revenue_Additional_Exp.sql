CREATE TABLE [dbo].[AT_Syn_Deal_Revenue_Additional_Exp] (
    [AT_Syn_Deal_Revenue_Additional_Exp_Code] INT             IDENTITY (1, 1) NOT NULL,
    [AT_Syn_Deal_Revenue_Code]                INT             NULL,
    [Additional_Expense_Code]                 INT             NULL,
    [Amount]                                  DECIMAL (38, 3) NULL,
    [Min_Max]                                 CHAR (3)        NULL,
    [Inserted_On]                             DATETIME        NOT NULL,
    [Inserted_By]                             INT             NOT NULL,
    [Last_Updated_Time]                       DATETIME        NULL,
    [Last_Action_By]                          INT             NULL,
    [Syn_Deal_Revenue_Additional_Exp_Code]    INT             NULL,
    CONSTRAINT [PK_AT_Syn_Deal_Revenue_Additional_Exp] PRIMARY KEY CLUSTERED ([AT_Syn_Deal_Revenue_Additional_Exp_Code] ASC),
    CONSTRAINT [FK_AT_Syn_Deal_Revenue_Additional_Exp_Additional_Expense] FOREIGN KEY ([Additional_Expense_Code]) REFERENCES [dbo].[Additional_Expense] ([Additional_Expense_Code]),
    CONSTRAINT [FK_AT_Syn_Deal_Revenue_Additional_Exp_AT_Syn_Deal_Revenue] FOREIGN KEY ([AT_Syn_Deal_Revenue_Code]) REFERENCES [dbo].[AT_Syn_Deal_Revenue] ([AT_Syn_Deal_Revenue_Code])
);

