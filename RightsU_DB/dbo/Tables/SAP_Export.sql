CREATE TABLE [dbo].[SAP_Export] (
    [SAP_Export_Code]        INT           IDENTITY (1, 1) NOT NULL,
    [WBS_Code]               VARCHAR (MAX) NULL,
    [File_Code]              INT           NULL,
    [WBS_Start_Date]         DATETIME      NULL,
    [WBS_End_Date]           DATETIME      NULL,
    [Acknowledgement_Status] CHAR (10)     NULL,
    [Error_Details]          VARCHAR (MAX) NULL,
    [Acq_Deal_Code]          INT           NULL,
    [Version_No]             INT           NULL,
    PRIMARY KEY CLUSTERED ([SAP_Export_Code] ASC)
);

