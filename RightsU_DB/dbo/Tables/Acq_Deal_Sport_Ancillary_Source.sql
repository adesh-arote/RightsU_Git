CREATE TABLE [dbo].[Acq_Deal_Sport_Ancillary_Source] (
    [Acq_Deal_Sport_Ancillary_Source_Code] INT IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Sport_Ancillary_Code]        INT NULL,
    [Sport_Ancillary_Source_Code]          INT NULL,
    CONSTRAINT [PK_Acq_Deal_Sport_Ancillary_Source] PRIMARY KEY CLUSTERED ([Acq_Deal_Sport_Ancillary_Source_Code] ASC),
    CONSTRAINT [FK_Acq_Deal_Sport_Ancillary_Source_Acq_Deal_Sport_Ancillary] FOREIGN KEY ([Acq_Deal_Sport_Ancillary_Code]) REFERENCES [dbo].[Acq_Deal_Sport_Ancillary] ([Acq_Deal_Sport_Ancillary_Code]),
    CONSTRAINT [FK_Acq_Deal_Sport_Ancillary_Source_Sport_Ancillary_Source] FOREIGN KEY ([Sport_Ancillary_Source_Code]) REFERENCES [dbo].[Sport_Ancillary_Source] ([Sport_Ancillary_Source_Code])
);

