CREATE TABLE [dbo].[Syn_Deal_Rights_Holdback] (
    [Syn_Deal_Rights_Holdback_Code] INT             IDENTITY (1, 1) NOT NULL,
    [Syn_Deal_Rights_Code]          INT             NOT NULL,
    [Holdback_Type]                 CHAR (1)        NULL,
    [HB_Run_After_Release_No]       INT             NULL,
    [HB_Run_After_Release_Units]    CHAR (1)        NULL,
    [Holdback_On_Platform_Code]     INT             NULL,
    [Holdback_Release_Date]         DATETIME        NULL,
    [Holdback_Comment]              NVARCHAR (4000) NULL,
    [Is_Original_Language]          CHAR (1)        NULL,
    [Acq_Deal_Rights_Holdback_Code] INT             NULL,
    CONSTRAINT [PK_Syn_Deal_Rights_Holdback] PRIMARY KEY CLUSTERED ([Syn_Deal_Rights_Holdback_Code] ASC),
    CONSTRAINT [FK_Syn_Deal_Rights_Holdback_Syn_Deal_Rights] FOREIGN KEY ([Syn_Deal_Rights_Code]) REFERENCES [dbo].[Syn_Deal_Rights] ([Syn_Deal_Rights_Code])
);

