CREATE TABLE [dbo].[Acq_Deal_Run_Shows] (
    [Acq_Deal_Run_Shows_Code] INT         IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Run_Code]       INT         NULL,
    [Data_For]                VARCHAR (2) NULL,
    [Title_Code]              INT         NULL,
    [Episode_From]            INT         NULL,
    [Episode_To]              INT         NULL,
    [Acq_Deal_Movie_Code]     INT         NULL,
    [Inserted_By]             INT         NULL,
    [Inserted_On]             DATETIME    NULL,
    CONSTRAINT [PK_Acq_Deal_Run_Shows] PRIMARY KEY CLUSTERED ([Acq_Deal_Run_Shows_Code] ASC),
    CONSTRAINT [FK_Acq_Deal_Run_Shows_Acq_Deal_Run] FOREIGN KEY ([Acq_Deal_Run_Code]) REFERENCES [dbo].[Acq_Deal_Run] ([Acq_Deal_Run_Code])
);





