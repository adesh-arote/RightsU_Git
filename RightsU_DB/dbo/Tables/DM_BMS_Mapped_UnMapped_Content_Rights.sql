﻿CREATE TABLE [dbo].[DM_BMS_Mapped_UnMapped_Content_Rights] (
    [DM_BMS_Mapped_UnMapped_Content_Rights_Code] INT             IDENTITY (1, 1) NOT NULL,
    [BMS_Deal_Content_Rights_Code]               INT             NULL,
    [BMS_Deal_Content_Code]                      INT             NULL,
    [BMS_Deal_Content_Ref_Key]                   INT             NULL,
    [RU_Channel_Code]                            INT             NULL,
    [BMS_Deal_Content_Rights_Ref_Key]            INT             NULL,
    [BMS_Station_Code]                           INT             NULL,
    [RU_Right_Rule_Code]                         INT             NULL,
    [BMS_Right_Rule_Ref_Key]                     INT             NULL,
    [SAP_WBS_Code]                               INT             NULL,
    [SAP_WBS_Ref_Key]                            INT             NULL,
    [BMS_Asset_Code]                             INT             NULL,
    [BMS_Asset_Ref_Key]                          INT             NULL,
    [Asset_Type]                                 VARCHAR (3)     NULL,
    [Title]                                      VARCHAR (80)    NULL,
    [License_Fees]                               DECIMAL (18, 3) NULL,
    [Total_Runs]                                 INT             NULL,
    [Utilised_Run]                               INT             NULL,
    [Start_Date]                                 DATETIME        NULL,
    [End_Date]                                   DATETIME        NULL,
    [Request_Time]                               DATETIME        NULL,
    [Response_Time]                              DATETIME        NULL,
    [Record_Status]                              VARCHAR (5)     NULL,
    [Is_Archived]                                VARCHAR (5)     NULL,
    [YearWise_No]                                INT             NULL,
    [Min_Runs]                                   INT             NULL,
    [Max_Runs]                                   INT             NULL,
    [DCO_ID]                                     INT             NULL,
    [DCO_Asset_ID]                               INT             NULL,
    [DCO_Deal_ID]                                VARCHAR (MAX)   NULL,
    [DCO_ID_RIGHTSHEADER]                        VARCHAR (MAX)   NULL,
    [DCO_Channel_ID]                             VARCHAR (MAX)   NULL,
    [DCO_ARR_ID]                                 VARCHAR (MAX)   NULL,
    [DCO_ASSETTYPE]                              VARCHAR (MAX)   NULL,
    [DCO_TITLE]                                  VARCHAR (MAX)   NULL,
    [DCO_LICENSEFEE]                             VARCHAR (MAX)   NULL,
    [DCO_DAYSAVAILABLE]                          VARCHAR (MAX)   NULL,
    [DCO_DAYSUSED]                               VARCHAR (MAX)   NULL,
    [DCO_Start_Date]                             VARCHAR (100)   NULL,
    [DCO_End_Date]                               VARCHAR (100)   NULL,
    [DCO_BUC_ID]                                 INT             NULL,
    [IS_Mapped]                                  CHAR (1)        NULL,
    [IS_Error]                                   VARCHAR (2000)  NULL,
    [Exact_Deal_Match]                           VARCHAR (100)   NULL,
    [Error_Description]                          VARCHAR (MAX)   NULL,
    [DCO_FOREIGNID]                              VARCHAR (MAX)   NULL,
    [BU_Rights_Count]                            INT             NULL,
    [RU_Rights_Count]                            INT             NULL,
    [Acq_Deal_Rights_Code]                       INT             NULL,
    [Acq_Deal_Run_Code]                          INT             NULL,
    [Acq_Deal_Run_Channel_Code]                  INT             NULL,
    [Acq_Deal_Run_YearWise_Run_Code]             INT             NULL
);

