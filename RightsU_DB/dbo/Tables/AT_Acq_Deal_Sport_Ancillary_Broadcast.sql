CREATE TABLE [dbo].[AT_Acq_Deal_Sport_Ancillary_Broadcast] (
    [AT_Acq_Deal_Sport_Ancillary_Broadcast_Code] INT IDENTITY (1, 1) NOT NULL,
    [AT_Acq_Deal_Sport_Ancillary_Code]           INT NULL,
    [Sport_Ancillary_Broadcast_Code]             INT NULL,
    [Acq_Deal_Sport_Ancillary_Broadcast_Code]    INT NOT NULL,
    CONSTRAINT [PK_AT_Acq_Deal_Sport_Ancillary_Broadcast] PRIMARY KEY CLUSTERED ([AT_Acq_Deal_Sport_Ancillary_Broadcast_Code] ASC),
    CONSTRAINT [FK_AT_Acq_Deal_Sport_Ancillary_Broadcast_AT_Acq_Deal_Sport_Ancillary] FOREIGN KEY ([AT_Acq_Deal_Sport_Ancillary_Code]) REFERENCES [dbo].[AT_Acq_Deal_Sport_Ancillary] ([AT_Acq_Deal_Sport_Ancillary_Code]),
    CONSTRAINT [FK_AT_Acq_Deal_Sport_Ancillary_Broadcast_Sport_Ancillary_Broadcast] FOREIGN KEY ([Sport_Ancillary_Broadcast_Code]) REFERENCES [dbo].[Sport_Ancillary_Broadcast] ([Sport_Ancillary_Broadcast_Code])
);

