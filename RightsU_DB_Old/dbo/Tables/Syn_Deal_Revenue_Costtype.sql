CREATE TABLE [dbo].[Syn_Deal_Revenue_Costtype] (
    [Syn_Deal_Revenue_Costtype_Code] INT             IDENTITY (1, 1) NOT NULL,
    [Syn_Deal_Revenue_Code]          INT             NULL,
    [Cost_Type_Code]                 INT             NULL,
    [Amount]                         DECIMAL (38, 3) NULL,
    [Consumed_Amount]                DECIMAL (38, 3) NULL,
    [Inserted_On]                    DATETIME        NOT NULL,
    [Inserted_By]                    INT             NOT NULL,
    [Last_Updated_Time]              DATETIME        NULL,
    [Last_Action_By]                 INT             NULL,
    CONSTRAINT [PK_Syn_Deal_Revenuetype] PRIMARY KEY CLUSTERED ([Syn_Deal_Revenue_Costtype_Code] ASC),
    CONSTRAINT [FK_Syn_Deal_Revenue_Costtype_Syn_Deal_Revenue] FOREIGN KEY ([Syn_Deal_Revenue_Code]) REFERENCES [dbo].[Syn_Deal_Revenue] ([Syn_Deal_Revenue_Code]),
    CONSTRAINT [FK_Syn_Deal_Revenuetype_Cost_Type] FOREIGN KEY ([Cost_Type_Code]) REFERENCES [dbo].[Cost_Type] ([Cost_Type_Code])
);

