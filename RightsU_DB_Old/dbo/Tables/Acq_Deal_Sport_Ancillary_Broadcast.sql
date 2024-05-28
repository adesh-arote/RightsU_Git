CREATE TABLE [dbo].[Acq_Deal_Sport_Ancillary_Broadcast] (
    [Acq_Deal_Sport_Ancillary_Broadcast_Code] INT IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Sport_Ancillary_Code]           INT NULL,
    [Sport_Ancillary_Broadcast_Code]          INT NULL,
    CONSTRAINT [PK_Acq_Deal_Sport_Ancillary_Broadcast] PRIMARY KEY CLUSTERED ([Acq_Deal_Sport_Ancillary_Broadcast_Code] ASC),
    CONSTRAINT [FK_Acq_Deal_Sport_Ancillary_Broadcast_Acq_Deal_Sport_Ancillary] FOREIGN KEY ([Acq_Deal_Sport_Ancillary_Code]) REFERENCES [dbo].[Acq_Deal_Sport_Ancillary] ([Acq_Deal_Sport_Ancillary_Code]),
    CONSTRAINT [FK_Acq_Deal_Sport_Ancillary_Broadcast_Sport_Ancillary_Broadcast] FOREIGN KEY ([Sport_Ancillary_Broadcast_Code]) REFERENCES [dbo].[Sport_Ancillary_Broadcast] ([Sport_Ancillary_Broadcast_Code])
);

