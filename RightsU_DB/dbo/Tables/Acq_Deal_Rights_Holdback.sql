CREATE TABLE [dbo].[Acq_Deal_Rights_Holdback] (
    [Acq_Deal_Rights_Holdback_Code] INT             IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Rights_Code]          INT             NOT NULL,
    [Holdback_Type]                 CHAR (1)        NULL,
    [HB_Run_After_Release_No]       INT             NULL,
    [HB_Run_After_Release_Units]    CHAR (1)        NULL,
    [Holdback_On_Platform_Code]     INT             NULL,
    [Holdback_Release_Date]         DATETIME        NULL,
    [Holdback_Comment]              NVARCHAR (4000) NULL,
    [Is_Title_Language_Right]       CHAR (1)        NULL,
    CONSTRAINT [PK_Acq_Deal_Rights_Holdback] PRIMARY KEY CLUSTERED ([Acq_Deal_Rights_Holdback_Code] ASC),
    CONSTRAINT [FK_Acq_Deal_Rights_Holdback_Acq_Deal_Rights] FOREIGN KEY ([Acq_Deal_Rights_Code]) REFERENCES [dbo].[Acq_Deal_Rights] ([Acq_Deal_Rights_Code])
);


GO
CREATE NONCLUSTERED INDEX [IX_Acq_Deal_Rights_Holdback_1]
    ON [dbo].[Acq_Deal_Rights_Holdback]([Acq_Deal_Rights_Code] ASC);

