CREATE TABLE [dbo].[AT_Syn_Deal_Revenue_Variable_Cost] (
    [AT_Syn_Deal_Revenue_Variable_Cost_Code] INT             IDENTITY (1, 1) NOT NULL,
    [AT_Syn_Deal_Revenue_Code]               INT             NULL,
    [Entity_Code]                            INT             NULL,
    [Vendor_Code]                            INT             NULL,
    [Percentage]                             NUMERIC (18, 2) NULL,
    [Amount]                                 NUMERIC (30, 8) NULL,
    [Inserted_On]                            DATETIME        NOT NULL,
    [Inserted_By]                            INT             NOT NULL,
    [Last_Updated_Time]                      DATETIME        NULL,
    [Last_Action_By]                         INT             NULL,
    [Syn_Deal_Revenue_Variable_Cost_Code]    INT             NULL,
    CONSTRAINT [PK_AT_Syn_Deal_Revenue_Variable_Cost] PRIMARY KEY CLUSTERED ([AT_Syn_Deal_Revenue_Variable_Cost_Code] ASC),
    CONSTRAINT [FK_AT_Syn_Deal_Revenue_Variable_Cost_AT_Syn_Deal_Revenue] FOREIGN KEY ([AT_Syn_Deal_Revenue_Code]) REFERENCES [dbo].[AT_Syn_Deal_Revenue] ([AT_Syn_Deal_Revenue_Code]),
    CONSTRAINT [FK_AT_Syn_Deal_Revenue_Variable_Cost_Entity] FOREIGN KEY ([Entity_Code]) REFERENCES [dbo].[Entity] ([Entity_Code]),
    CONSTRAINT [FK_AT_Syn_Deal_Revenue_Variable_Cost_Vendor] FOREIGN KEY ([Vendor_Code]) REFERENCES [dbo].[Vendor] ([Vendor_Code])
);

