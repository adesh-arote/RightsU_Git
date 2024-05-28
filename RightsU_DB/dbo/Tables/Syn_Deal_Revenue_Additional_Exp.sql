CREATE TABLE [dbo].[Syn_Deal_Revenue_Additional_Exp] (
    [Syn_Deal_Revenue_Additional_Exp_Code] INT             IDENTITY (1, 1) NOT NULL,
    [Syn_Deal_Revenue_Code]                INT             NULL,
    [Additional_Expense_Code]              INT             NULL,
    [Amount]                               DECIMAL (38, 3) NULL,
    [Min_Max]                              CHAR (3)        NULL,
    [Inserted_On]                          DATETIME        NOT NULL,
    [Inserted_By]                          INT             NOT NULL,
    [Last_Updated_Time]                    DATETIME        NULL,
    [Last_Action_By]                       INT             NULL,
    CONSTRAINT [PK_Syn_Deal_Revenue_Additional_Exp] PRIMARY KEY CLUSTERED ([Syn_Deal_Revenue_Additional_Exp_Code] ASC),
    CONSTRAINT [FK_Syn_Deal_Revenue_Additional_Exp_Additional_Expense] FOREIGN KEY ([Additional_Expense_Code]) REFERENCES [dbo].[Additional_Expense] ([Additional_Expense_Code]),
    CONSTRAINT [FK_Syn_Deal_Revenue_Additional_Exp_Syn_Deal_Revenue] FOREIGN KEY ([Syn_Deal_Revenue_Code]) REFERENCES [dbo].[Syn_Deal_Revenue] ([Syn_Deal_Revenue_Code])
);

