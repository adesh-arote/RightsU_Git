CREATE TABLE [dbo].[Acq_Deal_Cost_Costtype] (
    [Acq_Deal_Cost_Costtype_Code] INT             IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Cost_Code]          INT             NULL,
    [Cost_Type_Code]              INT             NULL,
    [Amount]                      DECIMAL (38, 3) NULL,
    [Consumed_Amount]             DECIMAL (38, 3) NULL,
    [Inserted_On]                 DATETIME        NOT NULL,
    [Inserted_By]                 INT             NOT NULL,
    [Last_Updated_Time]           DATETIME        NULL,
    [Last_Action_By]              INT             NULL,
    CONSTRAINT [PK_Acq_Deal_Costtype] PRIMARY KEY CLUSTERED ([Acq_Deal_Cost_Costtype_Code] ASC),
    CONSTRAINT [FK_Acq_Deal_Cost_Costtype_Acq_Deal_Cost] FOREIGN KEY ([Acq_Deal_Cost_Code]) REFERENCES [dbo].[Acq_Deal_Cost] ([Acq_Deal_Cost_Code]),
    CONSTRAINT [FK_Acq_Deal_Costtype_Cost_Type] FOREIGN KEY ([Cost_Type_Code]) REFERENCES [dbo].[Cost_Type] ([Cost_Type_Code])
);

