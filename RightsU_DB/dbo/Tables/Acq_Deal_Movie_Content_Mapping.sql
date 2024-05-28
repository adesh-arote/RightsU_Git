CREATE TABLE [dbo].[Acq_Deal_Movie_Content_Mapping] (
    [Acq_Deal_Movie_Content_Mapping_Code] INT IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Movie_Code]                 INT NULL,
    [Title_Content_Code]                  INT NULL,
    CONSTRAINT [PK_Acq_Deal_Movie_Content_Mapping] PRIMARY KEY CLUSTERED ([Acq_Deal_Movie_Content_Mapping_Code] ASC),
    CONSTRAINT [FK_Acq_Deal_Movie_Content_Mapping_Acq_Deal_Movie] FOREIGN KEY ([Acq_Deal_Movie_Code]) REFERENCES [dbo].[Acq_Deal_Movie] ([Acq_Deal_Movie_Code]),
    CONSTRAINT [FK_Acq_Deal_Movie_Content_Mapping_Title_Content] FOREIGN KEY ([Title_Content_Code]) REFERENCES [dbo].[Title_Content] ([Title_Content_Code])
);

