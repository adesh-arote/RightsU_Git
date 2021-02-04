﻿CREATE TABLE [dbo].[Acq_Deal] (
    [Acq_Deal_Code]                 INT             IDENTITY (1, 1) NOT NULL,
    [Agreement_No]                  VARCHAR (50)    COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Version]                       VARCHAR (50)    COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Agreement_Date]                DATETIME        NULL,
    [Deal_Desc]                     NVARCHAR (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Deal_Type_Code]                INT             NULL,
    [Year_Type]                     CHAR (2)        COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Entity_Code]                   INT             NULL,
    [Is_Master_Deal]                CHAR (1)        COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Category_Code]                 INT             NULL,
    [Vendor_Code]                   INT             NULL,
    [Vendor_Contacts_Code]          INT             NOT NULL,
    [Currency_Code]                 INT             NULL,
    [Exchange_Rate]                 NUMERIC (10, 3) NULL,
    [Ref_No]                        NVARCHAR (100)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Attach_Workflow]               CHAR (1)        COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Deal_Workflow_Status]          VARCHAR (50)    COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Parent_Deal_Code]              INT             NULL,
    [Work_Flow_Code]                INT             NULL,
    [Amendment_Date]                DATETIME        NULL,
    [Is_Released]                   CHAR (1)        COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Release_On]                    DATETIME        NULL,
    [Release_By]                    INT             NULL,
    [Is_Completed]                  CHAR (1)        COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Is_Active]                     CHAR (1)        COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Content_Type]                  CHAR (2)        COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Payment_Terms_Conditions]      NVARCHAR (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Status]                        CHAR (1)        COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Is_Auto_Generated]             CHAR (1)        COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Is_Migrated]                   CHAR (1)        COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Cost_Center_Id]                INT             NULL,
    [Master_Deal_Movie_Code_ToLink] INT             NULL,
    [BudgetWise_Costing_Applicable] VARCHAR (2)     COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Validate_CostWith_Budget]      VARCHAR (2)     COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Deal_Tag_Code]                 INT             NULL,
    [Business_Unit_Code]            INT             NULL,
    [Ref_BMS_Code]                  VARCHAR (100)   COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Remarks]                       NVARCHAR (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Rights_Remarks]                NVARCHAR (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Payment_Remarks]               NVARCHAR (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Deal_Complete_Flag]            VARCHAR (100)   COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Inserted_By]                   INT             NULL,
    [Inserted_On]                   DATETIME        NULL,
    [Last_Updated_Time]             DATETIME        NULL,
    [Last_Action_By]                INT             NULL,
    [Lock_Time]                     DATETIME        NULL,
    [All_Channel]                   VARCHAR (1)     COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Role_Code]                     INT             NULL,
    [Channel_Cluster_Code]          INT             NULL,
    [Is_Auto_Push]                  CHAR (1)        COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Deal_Segment_Code]             INT             NULL,
    [Revenue_Vertical_Code]         INT             NULL,
    CONSTRAINT [PK_Acq_Deal] PRIMARY KEY CLUSTERED ([Acq_Deal_Code] ASC)
);

