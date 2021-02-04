CREATE TABLE [dbo].[Acq_Deal_Rights_Holdback] (
    [Acq_Deal_Rights_Holdback_Code] INT             IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Rights_Code]          INT             NOT NULL,
    [Holdback_Type]                 CHAR (1)        COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [HB_Run_After_Release_No]       INT             NULL,
    [HB_Run_After_Release_Units]    CHAR (1)        COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Holdback_On_Platform_Code]     INT             NULL,
    [Holdback_Release_Date]         DATETIME        NULL,
    [Holdback_Comment]              NVARCHAR (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Is_Title_Language_Right]       CHAR (1)        COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    CONSTRAINT [PK_Acq_Deal_Rights_Holdback] PRIMARY KEY CLUSTERED ([Acq_Deal_Rights_Holdback_Code] ASC)
);

