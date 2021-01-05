﻿CREATE TABLE [dbo].[BMS_Deal] (
    [BMS_Deal_Code]     INT             IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Code]     INT             NULL,
    [BMS_Deal_Ref_Key]  DECIMAL (38)    NULL,
    [Is_Archived]       VARCHAR (5)     NULL,
    [RU_Licensor_Code]  INT             NULL,
    [RU_Payee_Code]     INT             NULL,
    [RU_Currency_Code]  INT             NULL,
    [RU_Licensee_Code]  INT             NULL,
    [RU_Category_Code]  INT             NULL,
    [BMS_Licensor_Code] INT             NULL,
    [BMS_Payee_Code]    INT             NULL,
    [BMS_Currency_Code] INT             NULL,
    [BMS_Licensee_Code] INT             NULL,
    [BMS_Category_Code] INT             NULL,
    [License_Fees]      DECIMAL (18, 3) NULL,
    [Description]       VARCHAR (80)    NULL,
    [Contact]           VARCHAR (80)    NULL,
    [Lic_Ref_No]        VARCHAR (20)    NULL,
    [Revision]          VARCHAR (40)    NULL,
    [Start_Date]        DATETIME        NULL,
    [End_Date]          DATETIME        NULL,
    [Status_SLUId]      INT             NULL,
    [Type_SLUId]        INT             NULL,
    [Acquisition_Date]  DATETIME        NULL,
    [Request_Time]      DATETIME        NULL,
    [Response_Time]     DATETIME        NULL,
    [Record_Status]     VARCHAR (5)     NULL,
    [Error_Description] VARCHAR (4000)  NULL,
    CONSTRAINT [PK_BV_Deal] PRIMARY KEY CLUSTERED ([BMS_Deal_Code] ASC)
);

