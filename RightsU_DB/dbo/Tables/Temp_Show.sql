CREATE TABLE [dbo].[Temp_Show] (
    [Title_Code]              INT           NULL,
    [Acq_Deal_Run_Code]       INT           NOT NULL,
    [Acq_Deal_Run_Shows_Code] INT           NULL,
    [Acq_Deal_Movie_Code]     INT           NULL,
    [Title_Name]              VARCHAR (564) NULL,
    [Episode_From]            INT           NULL,
    [Episode_To]              INT           NULL,
    [Channel_Name]            VARCHAR (MAX) NULL,
    [Acq_Deal_Code]           INT           NULL,
    [Agreement_No]            VARCHAR (12)  NULL,
    [Ext_Column_Name]         VARCHAR (50)  NULL,
    [Ext_Column_Value]        VARCHAR (50)  NULL,
    [Is_Select]               CHAR (1)      NULL,
    [Data_For]                VARCHAR (1)   NULL
);

