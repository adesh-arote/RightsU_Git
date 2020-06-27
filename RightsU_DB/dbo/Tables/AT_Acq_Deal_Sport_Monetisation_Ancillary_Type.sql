CREATE TABLE [dbo].[AT_Acq_Deal_Sport_Monetisation_Ancillary_Type] (
    [AT_Acq_Deal_Sport_Monetisation_Ancillary_Type_Code] INT IDENTITY (1, 1) NOT NULL,
    [AT_Acq_Deal_Sport_Monetisation_Ancillary_Code]      INT NULL,
    [Monetisation_Type_Code]                             INT NULL,
    [Monetisation_Rights]                                INT NULL,
    [Acq_Deal_Sport_Monetisation_Ancillary_Type_Code]    INT NOT NULL,
    CONSTRAINT [PK_AT_Acq_Deal_Sport_Monetisation_Ancillary_Type] PRIMARY KEY CLUSTERED ([AT_Acq_Deal_Sport_Monetisation_Ancillary_Type_Code] ASC),
    CONSTRAINT [FK_AT_Acq_Deal_Sport_Monetisation_Ancillary_Type_AT_Acq_Deal_Sport_Monetisation_Ancillary] FOREIGN KEY ([AT_Acq_Deal_Sport_Monetisation_Ancillary_Code]) REFERENCES [dbo].[AT_Acq_Deal_Sport_Monetisation_Ancillary] ([AT_Acq_Deal_Sport_Monetisation_Ancillary_Code]),
    CONSTRAINT [FK_AT_Acq_Deal_Sport_Monetisation_Ancillary_Type_Monetisation_Type] FOREIGN KEY ([Monetisation_Type_Code]) REFERENCES [dbo].[Monetisation_Type] ([Monetisation_Type_Code])
);

