CREATE TABLE [dbo].[Acq_Deal_Mass_Territory_Update] (
    [Acq_Deal_Mass_Update_Code] INT         IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Code]             INT         NULL,
    [Date]                      DATETIME    CONSTRAINT [DF_Acq_Deal_Mass_Territory_Update_Date] DEFAULT (getdate()) NULL,
    [Status]                    VARCHAR (2) NULL,
    [Processed_Date]            DATETIME    NULL,
    [Can_Process]               VARCHAR (2) NULL,
    [Created_By]                INT         NULL,
    CONSTRAINT [PK_Deal_Mass_Territory_Update] PRIMARY KEY CLUSTERED ([Acq_Deal_Mass_Update_Code] ASC),
    CONSTRAINT [FK_Acq_Deal_Mass_Territory_Update_Acq_Deal] FOREIGN KEY ([Acq_Deal_Code]) REFERENCES [dbo].[Acq_Deal] ([Acq_Deal_Code])
);

