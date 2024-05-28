CREATE TABLE [dbo].[AT_Acq_Deal_Cost_Costtype] (
    [AT_Acq_Deal_Cost_Costtype_Code] INT             IDENTITY (1, 1) NOT NULL,
    [AT_Acq_Deal_Cost_Code]          INT             NULL,
    [Cost_Type_Code]                 INT             NULL,
    [Amount]                         DECIMAL (38, 3) NULL,
    [Consumed_Amount]                DECIMAL (38, 3) NULL,
    [Inserted_On]                    DATETIME        NOT NULL,
    [Inserted_By]                    INT             NOT NULL,
    [Last_Updated_Time]              DATETIME        NULL,
    [Last_Action_By]                 INT             NULL,
    [Acq_Deal_Cost_Costtype_Code]    INT             NULL,
    CONSTRAINT [PK_AT_Acq_Deal_Costtype] PRIMARY KEY CLUSTERED ([AT_Acq_Deal_Cost_Costtype_Code] ASC),
    CONSTRAINT [FK_AT_Acq_Deal_Cost_Costtype_AT_Acq_Deal_Cost] FOREIGN KEY ([AT_Acq_Deal_Cost_Code]) REFERENCES [dbo].[AT_Acq_Deal_Cost] ([AT_Acq_Deal_Cost_Code]),
    CONSTRAINT [FK_AT_Acq_Deal_Costtype_Cost_Type] FOREIGN KEY ([Cost_Type_Code]) REFERENCES [dbo].[Cost_Type] ([Cost_Type_Code])
);

