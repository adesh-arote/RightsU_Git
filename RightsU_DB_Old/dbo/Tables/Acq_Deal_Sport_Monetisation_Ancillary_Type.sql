CREATE TABLE [dbo].[Acq_Deal_Sport_Monetisation_Ancillary_Type] (
    [Acq_Deal_Sport_Monetisation_Ancillary_Type_Code] INT IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Sport_Monetisation_Ancillary_Code]      INT NULL,
    [Monetisation_Type_Code]                          INT NULL,
    [Monetisation_Rights]                             INT NULL,
    CONSTRAINT [PK_Acq_Deal_Sport_Monetisation_Ancillary_Type] PRIMARY KEY CLUSTERED ([Acq_Deal_Sport_Monetisation_Ancillary_Type_Code] ASC),
    CONSTRAINT [FK_Acq_Deal_Sport_Monetisation_Ancillary_Type_Acq_Deal_Sport_Monetisation_Ancillary] FOREIGN KEY ([Acq_Deal_Sport_Monetisation_Ancillary_Code]) REFERENCES [dbo].[Acq_Deal_Sport_Monetisation_Ancillary] ([Acq_Deal_Sport_Monetisation_Ancillary_Code]),
    CONSTRAINT [FK_Acq_Deal_Sport_Monetisation_Ancillary_Type_Monetisation_Type] FOREIGN KEY ([Monetisation_Type_Code]) REFERENCES [dbo].[Monetisation_Type] ([Monetisation_Type_Code])
);

