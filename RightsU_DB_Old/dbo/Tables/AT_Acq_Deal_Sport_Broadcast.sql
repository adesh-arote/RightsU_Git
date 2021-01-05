CREATE TABLE [dbo].[AT_Acq_Deal_Sport_Broadcast] (
    [AT_Acq_Deal_Sport_Broadcast_Code] INT         IDENTITY (1, 1) NOT NULL,
    [AT_Acq_Deal_Sport_Code]           INT         NULL,
    [Broadcast_Mode_Code]              INT         NOT NULL,
    [Type]                             VARCHAR (2) NULL,
    [Acq_Deal_Sport_Broadcast_Code]    INT         NULL,
    CONSTRAINT [PK_AT_Acq_Deal_Sport_Broadcast] PRIMARY KEY CLUSTERED ([AT_Acq_Deal_Sport_Broadcast_Code] ASC),
    CONSTRAINT [FK_AT_Acq_Deal_Sport_Broadcast_AT_Acq_Deal_Sport] FOREIGN KEY ([AT_Acq_Deal_Sport_Code]) REFERENCES [dbo].[AT_Acq_Deal_Sport] ([AT_Acq_Deal_Sport_Code]),
    CONSTRAINT [FK_AT_Acq_Deal_Sport_Broadcast_Broadcast_Mode] FOREIGN KEY ([Broadcast_Mode_Code]) REFERENCES [dbo].[Broadcast_Mode] ([Broadcast_Mode_Code])
);

