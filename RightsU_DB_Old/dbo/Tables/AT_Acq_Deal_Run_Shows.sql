CREATE TABLE [dbo].[AT_Acq_Deal_Run_Shows] (
    [AT_Acq_Deal_Run_Shows_Code] INT         IDENTITY (1, 1) NOT NULL,
    [AT_Acq_Deal_Run_Code]       INT         NULL,
    [Data_For]                   VARCHAR (2) NULL,
    [Title_Code]                 INT         NULL,
    [Episode_From]               INT         NULL,
    [Episode_To]                 INT         NULL,
    [AT_Acq_Deal_Movie_Code]     INT         NULL,
    [Inserted_By]                INT         NULL,
    [Inserted_On]                DATETIME    NULL,
    [Acq_Deal_Run_Shows_Code]    INT         NULL,
    CONSTRAINT [PK_AT_Acq_Deal_Run_Shows] PRIMARY KEY CLUSTERED ([AT_Acq_Deal_Run_Shows_Code] ASC),
    CONSTRAINT [FK_AT_Acq_Deal_Run_Shows_Acq_Deal_Run] FOREIGN KEY ([AT_Acq_Deal_Run_Code]) REFERENCES [dbo].[AT_Acq_Deal_Run] ([AT_Acq_Deal_Run_Code])
);





