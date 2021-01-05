﻿CREATE TABLE [dbo].[Provisional_Deal] (
    [Provisional_Deal_Code]      INT            IDENTITY (1, 1) NOT NULL,
    [Provisional_Deal_Type_Code] INT            NULL,
    [Agreement_No]               VARCHAR (50)   NULL,
    [Version]                    VARCHAR (50)   NULL,
    [Content_Type]               VARCHAR (2)    NULL,
    [Agreement_Date]             DATETIME       NULL,
    [Deal_Type_Code]             INT            NULL,
    [Entity_Code]                INT            NULL,
    [Deal_Workflow_Status]       VARCHAR (3)    NULL,
    [Is_Active]                  CHAR (1)       NULL,
    [Business_Unit_Code]         INT            NULL,
    [Remarks]                    NVARCHAR (MAX) NULL,
    [Deal_Desc]                  NVARCHAR (MAX) NULL,
    [Right_Start_Date]           DATETIME       NULL,
    [Right_End_Date]             DATETIME       NULL,
    [Term]                       VARCHAR (12)   NULL,
    [Acq_Deal_Code]              INT            NULL,
    [Inserted_By]                INT            NULL,
    [Inserted_On]                DATETIME       NULL,
    [Last_Updated_Time]          DATETIME       NULL,
    [Last_Action_By]             INT            NULL,
    [Lock_Time]                  DATETIME       NULL,
    CONSTRAINT [PK_Provisional_Deal] PRIMARY KEY CLUSTERED ([Provisional_Deal_Code] ASC),
    CONSTRAINT [FK_Provisional_Deal_Acq_Deal] FOREIGN KEY ([Acq_Deal_Code]) REFERENCES [dbo].[Acq_Deal] ([Acq_Deal_Code]),
    CONSTRAINT [FK_Provisional_Deal_Business_Unit] FOREIGN KEY ([Business_Unit_Code]) REFERENCES [dbo].[Business_Unit] ([Business_Unit_Code]),
    CONSTRAINT [FK_Provisional_Deal_Deal_Type] FOREIGN KEY ([Deal_Type_Code]) REFERENCES [dbo].[Deal_Type] ([Deal_Type_Code]),
    CONSTRAINT [FK_Provisional_Deal_Provisional_Deal_Type] FOREIGN KEY ([Provisional_Deal_Type_Code]) REFERENCES [dbo].[Provisional_Deal_Type] ([Provisional_Deal_Type_Code]),
    CONSTRAINT [FK_Provisional_Deal_Vendor] FOREIGN KEY ([Entity_Code]) REFERENCES [dbo].[Entity] ([Entity_Code])
);

