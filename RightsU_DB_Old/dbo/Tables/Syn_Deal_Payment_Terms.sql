CREATE TABLE [dbo].[Syn_Deal_Payment_Terms] (
    [Syn_Deal_Payment_Terms_Code] INT             IDENTITY (1, 1) NOT NULL,
    [Syn_Deal_Code]               INT             NOT NULL,
    [Payment_Terms_Code]          INT             NULL,
    [Days_After]                  INT             NULL,
    [Percentage]                  DECIMAL (10, 3) NULL,
    [Due_Date]                    DATETIME        NULL,
    [Cost_Type_Code]              INT             NULL,
    [Inserted_On]                 DATETIME        NOT NULL,
    [Inserted_By]                 INT             NOT NULL,
    [Last_Updated_Time]           DATETIME        NULL,
    [Last_Action_By]              INT             NULL,
    CONSTRAINT [PK_Syn_Deal_Payment_Terms] PRIMARY KEY CLUSTERED ([Syn_Deal_Payment_Terms_Code] ASC),
    CONSTRAINT [FK_Syn_Deal_Payment_Terms_Cost_Type] FOREIGN KEY ([Cost_Type_Code]) REFERENCES [dbo].[Cost_Type] ([Cost_Type_Code]),
    CONSTRAINT [FK_Syn_Deal_Payment_Terms_Payment_Terms] FOREIGN KEY ([Payment_Terms_Code]) REFERENCES [dbo].[Payment_Terms] ([Payment_Terms_Code]),
    CONSTRAINT [FK_Syn_Deal_Payment_Terms_Syn_Deal] FOREIGN KEY ([Syn_Deal_Code]) REFERENCES [dbo].[Syn_Deal] ([Syn_Deal_Code])
);

