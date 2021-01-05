CREATE TABLE [dbo].[AT_Acq_Deal_Movie_Content_Mapping] (
    [AT_Acq_Deal_Movie_Content_Mapping_Code] INT IDENTITY (1, 1) NOT NULL,
    [AT_Acq_Deal_Movie_Code]                 INT NULL,
    [Title_Content_Code]                     INT NULL,
    [Acq_Deal_Movie_Content_Mapping_Code]    INT NULL,
    CONSTRAINT [PK_AT_Acq_Deal_Movie_Content_Mapping] PRIMARY KEY CLUSTERED ([AT_Acq_Deal_Movie_Content_Mapping_Code] ASC),
    CONSTRAINT [FK_AT_Acq_Deal_Movie_Content_Mapping_Acq_Deal_Movie] FOREIGN KEY ([AT_Acq_Deal_Movie_Code]) REFERENCES [dbo].[AT_Acq_Deal_Movie] ([AT_Acq_Deal_Movie_Code])
);

