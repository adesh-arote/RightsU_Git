CREATE TABLE [dbo].[Syn_Deal_Revenue_Variable_Cost] (
    [Syn_Deal_Revenue_Variable_Cost_Code] INT             IDENTITY (1, 1) NOT NULL,
    [Syn_Deal_Revenue_Code]               INT             NULL,
    [Entity_Code]                         INT             NULL,
    [Vendor_Code]                         INT             NULL,
    [Percentage]                          NUMERIC (18, 2) NULL,
    [Amount]                              NUMERIC (30, 8) NULL,
    [Inserted_On]                         DATETIME        NOT NULL,
    [Inserted_By]                         INT             NOT NULL,
    [Last_Updated_Time]                   DATETIME        NULL,
    [Last_Action_By]                      INT             NULL,
    CONSTRAINT [PK_Syn_Deal_Revenue_Variable_Cost] PRIMARY KEY CLUSTERED ([Syn_Deal_Revenue_Variable_Cost_Code] ASC),
    CONSTRAINT [FK_Syn_Deal_Revenue_Variable_Cost_Entity] FOREIGN KEY ([Entity_Code]) REFERENCES [dbo].[Entity] ([Entity_Code]),
    CONSTRAINT [FK_Syn_Deal_Revenue_Variable_Cost_Syn_Deal_Revenue] FOREIGN KEY ([Syn_Deal_Revenue_Code]) REFERENCES [dbo].[Syn_Deal_Revenue] ([Syn_Deal_Revenue_Code]),
    CONSTRAINT [FK_Syn_Deal_Revenue_Variable_Cost_Vendor] FOREIGN KEY ([Vendor_Code]) REFERENCES [dbo].[Vendor] ([Vendor_Code])
);

