CREATE TABLE [dbo].[Acq_Deal_Sport_Broadcast] (
    [Acq_Deal_Sport_Broadcast_Code] INT         IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Sport_Code]           INT         NULL,
    [Broadcast_Mode_Code]           INT         NOT NULL,
    [Type]                          VARCHAR (2) NULL,
    CONSTRAINT [PK_Acq_Deal_Sport_Broadcast] PRIMARY KEY CLUSTERED ([Acq_Deal_Sport_Broadcast_Code] ASC),
    CONSTRAINT [FK_Acq_Deal_Sport_Broadcast_Acq_Deal_Sport] FOREIGN KEY ([Acq_Deal_Sport_Code]) REFERENCES [dbo].[Acq_Deal_Sport] ([Acq_Deal_Sport_Code]),
    CONSTRAINT [FK_Acq_Deal_Sport_Broadcast_Broadcast_Mode] FOREIGN KEY ([Broadcast_Mode_Code]) REFERENCES [dbo].[Broadcast_Mode] ([Broadcast_Mode_Code])
);

