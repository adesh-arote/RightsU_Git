CREATE TABLE [dbo].[AT_Syn_Deal_Revenue_Costtype] (
    [AT_Syn_Deal_Revenue_Costtype_Code] INT             IDENTITY (1, 1) NOT NULL,
    [AT_Syn_Deal_Revenue_Code]          INT             NULL,
    [Cost_Type_Code]                    INT             NULL,
    [Amount]                            DECIMAL (38, 3) NULL,
    [Consumed_Amount]                   DECIMAL (38, 3) NULL,
    [Inserted_On]                       DATETIME        NOT NULL,
    [Inserted_By]                       INT             NOT NULL,
    [Last_Updated_Time]                 DATETIME        NULL,
    [Last_Action_By]                    INT             NULL,
    [Syn_Deal_Revenue_Costtype_Code]    INT             NULL,
    CONSTRAINT [PK_AT_Syn_Deal_Revenuetype] PRIMARY KEY CLUSTERED ([AT_Syn_Deal_Revenue_Costtype_Code] ASC),
    CONSTRAINT [FK_AT_Syn_Deal_Revenue_Costtype_AT_Syn_Deal_Revenue] FOREIGN KEY ([AT_Syn_Deal_Revenue_Code]) REFERENCES [dbo].[AT_Syn_Deal_Revenue] ([AT_Syn_Deal_Revenue_Code]),
    CONSTRAINT [FK_AT_Syn_Deal_Revenuetype_Cost_Type] FOREIGN KEY ([Cost_Type_Code]) REFERENCES [dbo].[Cost_Type] ([Cost_Type_Code])
);

