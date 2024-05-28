CREATE TABLE [dbo].[Title_Content_Mapping] (
    [Title_Content_Mapping_Code]  INT      IDENTITY (1, 1) NOT NULL,
    [Title_Content_Code]          INT      NULL,
    [Deal_For]                    CHAR (1) NULL,
    [Acq_Deal_Movie_Code]         INT      NULL,
    [Provisional_Deal_Title_Code] INT      NULL,
    CONSTRAINT [PK_Title_Content_Mapping] PRIMARY KEY CLUSTERED ([Title_Content_Mapping_Code] ASC),
    CONSTRAINT [FK_Title_Content_Mapping_Acq_Deal_Movie] FOREIGN KEY ([Acq_Deal_Movie_Code]) REFERENCES [dbo].[Acq_Deal_Movie] ([Acq_Deal_Movie_Code]),
    CONSTRAINT [FK_Title_Content_Mapping_Provisional_Deal_Title] FOREIGN KEY ([Provisional_Deal_Title_Code]) REFERENCES [dbo].[Provisional_Deal_Title] ([Provisional_Deal_Title_Code]),
    CONSTRAINT [FK_Title_Content_Mapping_Title_Content] FOREIGN KEY ([Title_Content_Code]) REFERENCES [dbo].[Title_Content] ([Title_Content_Code])
);

