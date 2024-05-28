CREATE TABLE [dbo].[AT_Acq_Deal_Rights_Holdback] (
    [AT_Acq_Deal_Rights_Holdback_Code] INT             IDENTITY (1, 1) NOT NULL,
    [AT_Acq_Deal_Rights_Code]          INT             NOT NULL,
    [Holdback_Type]                    CHAR (1)        NULL,
    [HB_Run_After_Release_No]          INT             NULL,
    [HB_Run_After_Release_Units]       CHAR (1)        NULL,
    [Holdback_On_Platform_Code]        INT             NULL,
    [Holdback_Release_Date]            DATETIME        NULL,
    [Holdback_Comment]                 NVARCHAR (4000) NULL,
    [Is_Title_Language_Right]          CHAR (1)        NULL,
    [Acq_Deal_Rights_Holdback_Code]    INT             NULL,
    CONSTRAINT [PK_AT_Acq_Deal_Rights_Holdback] PRIMARY KEY CLUSTERED ([AT_Acq_Deal_Rights_Holdback_Code] ASC),
    CONSTRAINT [FK_AT_Acq_Deal_Rights_Holdback_AT_Acq_Deal_Rights] FOREIGN KEY ([AT_Acq_Deal_Rights_Code]) REFERENCES [dbo].[AT_Acq_Deal_Rights] ([AT_Acq_Deal_Rights_Code])
);

