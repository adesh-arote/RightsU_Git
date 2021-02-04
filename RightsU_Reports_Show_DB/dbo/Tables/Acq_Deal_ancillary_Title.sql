CREATE TABLE [dbo].[Acq_Deal_ancillary_Title] (
    [Acq_Deal_Ancillary_Title_Code] INT IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Ancillary_Code]       INT NULL,
    [Title_Code]                    INT NULL,
    [Episode_From]                  INT NULL,
    [Episode_To]                    INT NULL,
    CONSTRAINT [PK_Acq_Deal_ancillary_Title] PRIMARY KEY CLUSTERED ([Acq_Deal_Ancillary_Title_Code] ASC)
);

