CREATE TABLE [dbo].[Acq_Deal_Mass_Update_ErrorLog] (
    [Error_Log_Code]            INT           IDENTITY (1, 1) NOT NULL,
    [Error_Message]             VARCHAR (MAX) NULL,
    [Acq_Deal_Mass_Update_Code] INT           NULL,
    [Error_Date]                DATETIME      NULL,
    CONSTRAINT [PK_Deal_Mass_Update_ErrorLog] PRIMARY KEY CLUSTERED ([Error_Log_Code] ASC),
    CONSTRAINT [FK_Acq_Deal_Mass_Update_ErrorLog_Acq_Deal_Mass_Territory_Update] FOREIGN KEY ([Acq_Deal_Mass_Update_Code]) REFERENCES [dbo].[Acq_Deal_Mass_Territory_Update] ([Acq_Deal_Mass_Update_Code])
);

