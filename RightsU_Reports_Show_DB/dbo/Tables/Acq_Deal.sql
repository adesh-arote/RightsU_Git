﻿CREATE TABLE [dbo].[Acq_Deal] (
    [Acq_Deal_Code]                 INT             IDENTITY (1, 1) NOT NULL,
    [Agreement_No]                  VARCHAR (50)    NULL,
    [Version]                       VARCHAR (50)    NULL,
    [Agreement_Date]                DATETIME        NULL,
    [Deal_Desc]                     NVARCHAR (1000) NULL,
    [Deal_Type_Code]                INT             NULL,
    [Year_Type]                     CHAR (2)        NULL,
    [Entity_Code]                   INT             NULL,
    [Is_Master_Deal]                CHAR (1)        NULL,
    [Category_Code]                 INT             NULL,
    [Vendor_Code]                   INT             NULL,
    [Vendor_Contacts_Code]          INT             NOT NULL,
    [Currency_Code]                 INT             NULL,
    [Exchange_Rate]                 NUMERIC (10, 3) NULL,
    [Ref_No]                        NVARCHAR (100)  NULL,
    [Attach_Workflow]               CHAR (1)        NULL,
    [Deal_Workflow_Status]          VARCHAR (50)    NULL,
    [Parent_Deal_Code]              INT             NULL,
    [Work_Flow_Code]                INT             NULL,
    [Amendment_Date]                DATETIME        NULL,
    [Is_Released]                   CHAR (1)        NULL,
    [Release_On]                    DATETIME        NULL,
    [Release_By]                    INT             NULL,
    [Is_Completed]                  CHAR (1)        NULL,
    [Is_Active]                     CHAR (1)        NULL,
    [Content_Type]                  CHAR (2)        NULL,
    [Payment_Terms_Conditions]      NVARCHAR (4000) NULL,
    [Status]                        CHAR (1)        NULL,
    [Is_Auto_Generated]             CHAR (1)        NULL,
    [Is_Migrated]                   CHAR (1)        NULL,
    [Cost_Center_Id]                INT             NULL,
    [Master_Deal_Movie_Code_ToLink] INT             NULL,
    [BudgetWise_Costing_Applicable] VARCHAR (2)     NULL,
    [Validate_CostWith_Budget]      VARCHAR (2)     NULL,
    [Deal_Tag_Code]                 INT             NULL,
    [Business_Unit_Code]            INT             NULL,
    [Ref_BMS_Code]                  VARCHAR (100)   NULL,
    [Remarks]                       NVARCHAR (4000) NULL,
    [Rights_Remarks]                NVARCHAR (4000) NULL,
    [Payment_Remarks]               NVARCHAR (4000) NULL,
    [Deal_Complete_Flag]            VARCHAR (100)   NULL,
    [Inserted_By]                   INT             NULL,
    [Inserted_On]                   DATETIME        NULL,
    [Last_Updated_Time]             DATETIME        NULL,
    [Last_Action_By]                INT             NULL,
    [Lock_Time]                     DATETIME        NULL,
    [All_Channel]                   VARCHAR (1)     NULL,
    [Role_Code]                     INT             NULL,
    [Channel_Cluster_Code]          INT             NULL,
    [Is_Auto_Push]                  CHAR (1)        NULL,
    [Deal_Segment_Code]             INT             NULL,
    [Revenue_Vertical_Code]         INT             NULL,
    [Confirming_Party]              NVARCHAR (MAX)  NULL,
    CONSTRAINT [PK_Acq_Deal] PRIMARY KEY CLUSTERED ([Acq_Deal_Code] ASC)
);



