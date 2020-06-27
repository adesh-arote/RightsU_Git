CREATE TABLE [dbo].[BMS_Schedule_Runs] (
    [BMS_Schedule_Runs_Code]         INT      IDENTITY (1, 1) NOT NULL,
    [BMS_Schedule_Process_Data_Code] INT      NULL,
    [Timeline_ID]                    INT      NULL,
    [BMS_Asset_Ref_Key]              INT      NULL,
    [Log_Date]                       DATETIME NULL,
    [Date_Time]                      DATETIME NULL,
    [Is_Prime]                       CHAR (1) NULL,
    [Channel_Code]                   INT      NULL,
    [Acq_Deal_Run_Code]              INT      NULL,
    [Inserted_On]                    DATETIME NULL,
    [Is_Ignore]                      CHAR (1) CONSTRAINT [DF_BMS_Schedule_Runs_Is_Ignore] DEFAULT ('N') NULL,
    [Delete_Flag]                    CHAR (1) CONSTRAINT [DF_BMS_Schedule_Runs_Delete_Flag] DEFAULT ('N') NULL,
    [Record_Type]                    CHAR (1) NULL,
    [Ref_Timeline_ID]                INT      NULL,
    CONSTRAINT [PK_BMS_Schedule_Runs] PRIMARY KEY CLUSTERED ([BMS_Schedule_Runs_Code] ASC)
);





GO


GO


GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'P- Prime, O - Offprime, N -No' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BMS_Schedule_Runs', @level2type=N'COLUMN',@level2name=N'Is_Prime'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'S- Schedule, A- AsRun' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BMS_Schedule_Runs', @level2type=N'COLUMN',@level2name=N'Record_Type'
GO
