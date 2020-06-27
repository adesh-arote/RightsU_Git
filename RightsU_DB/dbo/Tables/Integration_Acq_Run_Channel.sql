CREATE TABLE [dbo].[Integration_Acq_Run_Channel] (
    [Integration_Acq_Run_Channel_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Integration_Acq_Run_Code]         INT      NULL,
    [Channel_Code]                     INT      NULL,
    [Min_Runs]                         INT      NULL,
    [Max_Runs]                         INT      NULL,
    [Process_Date]                     DATETIME NULL,
    [Inserted_On]                      DATETIME NULL,
    [Record_Status]                    CHAR (1) NULL,
    [Is_Archive]                       CHAR (1) NULL,
    CONSTRAINT [PK_Integration_Acq_Run_Channel] PRIMARY KEY CLUSTERED ([Integration_Acq_Run_Channel_Code] ASC),
    CONSTRAINT [FK_Integration_Acq_Run_Channel_Integration_Acq_Run] FOREIGN KEY ([Integration_Acq_Run_Code]) REFERENCES [dbo].[Integration_Acq_Run] ([Integration_Acq_Run_Code])
);



