CREATE TABLE [dbo].[Acq_Deal_Ancillary_Import_Data] (
    [Acq_Deal_Ancillary_Import_Data_Code] INT             IDENTITY (1, 1) NOT NULL,
    [Agreement_No]                        VARCHAR (100)   NULL,
    [Ancillary_Type]                      NVARCHAR (1000) NULL,
    [Ancillary_Platform]                  NVARCHAR (4000) NULL,
    [Duration (Secs)]                     VARCHAR (100)   NULL,
    [Period (Days)]                       VARCHAR (100)   NULL,
    [Catch_Up_From]                       VARCHAR (100)   NULL,
    [Remarks]                             NVARCHAR (MAX)  NULL,
    [Error_Message]                       NVARCHAR (MAX)  NULL,
    [IS_Valid]                            CHAR (1)        NULL
);

