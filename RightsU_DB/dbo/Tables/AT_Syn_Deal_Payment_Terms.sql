CREATE TABLE [dbo].[AT_Syn_Deal_Payment_Terms] (
    [AT_Syn_Deal_Payment_Terms_Code] INT             IDENTITY (1, 1) NOT NULL,
    [AT_Syn_Deal_Code]               INT             NOT NULL,
    [Payment_Terms_Code]             INT             NULL,
    [Days_After]                     INT             NULL,
    [Percentage]                     DECIMAL (10, 3) NULL,
    [Due_Date]                       DATETIME        NULL,
    [Cost_Type_Code]                 INT             NULL,
    [Inserted_On]                    DATETIME        NOT NULL,
    [Inserted_By]                    INT             NOT NULL,
    [Last_Updated_Time]              DATETIME        NULL,
    [Last_Action_By]                 INT             NULL,
    [Syn_Deal_Payment_Terms_Code]    INT             NULL,
    CONSTRAINT [PK_AT_Syn_Deal_Payment_Terms] PRIMARY KEY CLUSTERED ([AT_Syn_Deal_Payment_Terms_Code] ASC),
    CONSTRAINT [FK_AT_Syn_Deal_Payment_Terms_AT_Syn_Deal] FOREIGN KEY ([AT_Syn_Deal_Code]) REFERENCES [dbo].[AT_Syn_Deal] ([AT_Syn_Deal_Code]),
    CONSTRAINT [FK_AT_Syn_Deal_Payment_Terms_Cost_Type] FOREIGN KEY ([Cost_Type_Code]) REFERENCES [dbo].[Cost_Type] ([Cost_Type_Code]),
    CONSTRAINT [FK_AT_Syn_Deal_Payment_Terms_Payment_Terms] FOREIGN KEY ([Payment_Terms_Code]) REFERENCES [dbo].[Payment_Terms] ([Payment_Terms_Code])
);

