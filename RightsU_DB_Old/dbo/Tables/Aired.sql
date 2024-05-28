CREATE TABLE [dbo].[Aired] (
    [Aired_Code]          INT      IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Movie_Code] INT      NULL,
    [Episode_No]          INT      NULL,
    [First_Aired_On]      DATETIME NULL,
    [Latest_Aired_On]     DATETIME NULL,
    [Total_Runs]          INT      NULL,
    CONSTRAINT [PK_Aired] PRIMARY KEY CLUSTERED ([Aired_Code] ASC),
    CONSTRAINT [FK_Aired_Deal_Movie] FOREIGN KEY ([Acq_Deal_Movie_Code]) REFERENCES [dbo].[Acq_Deal_Movie] ([Acq_Deal_Movie_Code])
);

