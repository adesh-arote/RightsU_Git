﻿CREATE TABLE [dbo].[Acq_Deal_Cost] (
    [Acq_Deal_Cost_Code]         INT             IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Code]              INT             NULL,
    [Currency_Code]              INT             NULL,
    [Currency_Exchange_Rate]     DECIMAL (18, 3) NULL,
    [Deal_Cost]                  DECIMAL (38, 3) NULL,
    [Deal_Cost_Per_Episode]      DECIMAL (38, 3) NULL,
    [Cost_Center_Id]             INT             NULL,
    [Additional_Cost]            DECIMAL (38, 3) NULL,
    [Catchup_Cost]               DECIMAL (38, 3) NULL,
    [Variable_Cost_Type]         CHAR (1)        CONSTRAINT [DF_Acq_Deal_Cost_Variable_Cost_Type] DEFAULT ('N') NULL,
    [Variable_Cost_Sharing_Type] CHAR (1)        NULL,
    [Royalty_Recoupment_Code]    INT             NULL,
    [Inserted_On]                DATETIME        NOT NULL,
    [Inserted_By]                INT             NOT NULL,
    [Last_Updated_Time]          DATETIME        NULL,
    [Last_Action_By]             INT             NULL,
    [Incentive]                  CHAR (1)        NULL,
    [Remarks]                    NVARCHAR (4000) NULL,
    CONSTRAINT [PK_Acq_Deal_Cost] PRIMARY KEY CLUSTERED ([Acq_Deal_Cost_Code] ASC),
    CONSTRAINT [FK_Acq_Deal_Cost_Acq_Deal] FOREIGN KEY ([Acq_Deal_Code]) REFERENCES [dbo].[Acq_Deal] ([Acq_Deal_Code]),
    CONSTRAINT [FK_Acq_Deal_Cost_Cost_Center] FOREIGN KEY ([Cost_Center_Id]) REFERENCES [dbo].[Cost_Center] ([Cost_Center_Id]),
    CONSTRAINT [FK_Acq_Deal_Cost_Currency] FOREIGN KEY ([Currency_Code]) REFERENCES [dbo].[Currency] ([Currency_Code]),
    CONSTRAINT [FK_Acq_Deal_Cost_Royalty_Recoupment] FOREIGN KEY ([Royalty_Recoupment_Code]) REFERENCES [dbo].[Royalty_Recoupment] ([Royalty_Recoupment_Code])
);



