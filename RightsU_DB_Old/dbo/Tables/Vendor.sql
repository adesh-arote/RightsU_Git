﻿CREATE TABLE [dbo].[Vendor] (
    [Vendor_Code]       INT             IDENTITY (1, 1) NOT NULL,
    [Vendor_Name]       NVARCHAR (1000) NULL,
    [Address]           NVARCHAR (3000) NULL,
    [Phone_No]          VARCHAR (100)   NULL,
    [Fax_No]            VARCHAR (100)   NULL,
    [ST_No]             VARCHAR (100)   NULL,
    [VAT_No]            VARCHAR (100)   NULL,
    [TIN_No]            VARCHAR (100)   NULL,
    [PAN_No]            VARCHAR (100)   NULL,
    [Inserted_On]       DATETIME        NULL,
    [Inserted_By]       INT             NULL,
    [Lock_Time]         DATETIME        NULL,
    [Last_Updated_Time] DATETIME        NULL,
    [Last_Action_By]    INT             NULL,
    [Is_Active]         CHAR (1)        CONSTRAINT [DF_Vendor_Is_Active] DEFAULT ('Y') NULL,
    [Reference_Id_1]    VARCHAR (50)    NULL,
    [Reference_Id_2]    VARCHAR (50)    NULL,
    [Reference_Id_3]    VARCHAR (50)    NULL,
    [CST_No]            VARCHAR (200)   NULL,
    [SAP_Vendor_Code]   VARCHAR (200)   NULL,
    [Is_External]       CHAR (1)        CONSTRAINT [DF_Vendor_Is_External] DEFAULT ('N') NULL,
    [CIN_No]            VARCHAR (100)   NULL,
    [Ref_Vendor_Key]    INT             NULL,
    [Province]          VARCHAR (40)    NULL,
    [PostalCode]        VARCHAR (20)    NULL,
    [ExternalId]        VARCHAR (20)    NULL,
    [Record_Status]     CHAR (1)        DEFAULT ('P') NULL,
    [Error_Description] VARCHAR (MAX)   NULL,
    [Request_Time]      DATETIME        NULL,
    [Response_Time]     DATETIME        NULL,
    [GST_No]            VARCHAR (50)    NULL,
    [MDM_Code]          NVARCHAR (MAX)  NULL,
    [MQ_Ref_Code]       INT             NULL,
    CONSTRAINT [PK_Vendor] PRIMARY KEY CLUSTERED ([Vendor_Code] ASC)
);










