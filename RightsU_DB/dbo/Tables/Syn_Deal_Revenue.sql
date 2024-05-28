CREATE TABLE [dbo].[Syn_Deal_Revenue] (
    [Syn_Deal_Revenue_Code]      INT             IDENTITY (1, 1) NOT NULL,
    [Syn_Deal_Code]              INT             NULL,
    [Currency_Code]              INT             NULL,
    [Currency_Exchange_Rate]     DECIMAL (18, 3) NULL,
    [Deal_Cost]                  DECIMAL (38, 3) NULL,
    [Deal_Cost_Per_Episode]      DECIMAL (38, 3) NULL,
    [Cost_Center_Id]             INT             NULL,
    [Additional_Cost]            DECIMAL (38, 3) NULL,
    [Catchup_Cost]               DECIMAL (38, 3) NULL,
    [Variable_Cost_Type]         CHAR (1)        CONSTRAINT [DF_Syn_Deal_Revenue_Variable_Cost_Type] DEFAULT ('N') NULL,
    [Variable_Cost_Sharing_Type] CHAR (1)        NULL,
    [Royalty_Recoupment_Code]    INT             NULL,
    [Inserted_On]                DATETIME        NOT NULL,
    [Inserted_By]                INT             NOT NULL,
    [Last_Updated_Time]          DATETIME        NULL,
    [Last_Action_By]             INT             NULL,
    CONSTRAINT [PK_Syn_Deal_Revenue] PRIMARY KEY CLUSTERED ([Syn_Deal_Revenue_Code] ASC),
    CONSTRAINT [FK_Syn_Deal_Revenue_Cost_Center] FOREIGN KEY ([Cost_Center_Id]) REFERENCES [dbo].[Cost_Center] ([Cost_Center_Id]),
    CONSTRAINT [FK_Syn_Deal_Revenue_Currency] FOREIGN KEY ([Currency_Code]) REFERENCES [dbo].[Currency] ([Currency_Code]),
    CONSTRAINT [FK_Syn_Deal_Revenue_Royalty_Recoupment] FOREIGN KEY ([Royalty_Recoupment_Code]) REFERENCES [dbo].[Royalty_Recoupment] ([Royalty_Recoupment_Code]),
    CONSTRAINT [FK_Syn_Deal_Revenue_Syn_Deal] FOREIGN KEY ([Syn_Deal_Code]) REFERENCES [dbo].[Syn_Deal] ([Syn_Deal_Code])
);

