CREATE TABLE [dbo].[Integration_Acq_Run_Yearwise] (
    [Integration_Acq_Run_Yearwise_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Integration_Acq_Run_Code]          INT      NULL,
    [Start_Date]                        DATETIME NULL,
    [End_Date]                          DATETIME NULL,
    [No_Of_Runs]                        INT      NULL,
    [Process_Date]                      DATETIME NULL,
    [Inserted_On]                       DATETIME NULL,
    [Record_Status]                     CHAR (1) NULL,
    [Is_Archive]                        CHAR (1) NULL,
    CONSTRAINT [PK_Integration_Acq_Run_Yearwise] PRIMARY KEY CLUSTERED ([Integration_Acq_Run_Yearwise_Code] ASC),
    CONSTRAINT [FK_Integration_Acq_Run_Yearwise_Integration_Acq_Run] FOREIGN KEY ([Integration_Acq_Run_Code]) REFERENCES [dbo].[Integration_Acq_Run] ([Integration_Acq_Run_Code])
);



