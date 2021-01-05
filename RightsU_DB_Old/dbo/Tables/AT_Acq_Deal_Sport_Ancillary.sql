CREATE TABLE [dbo].[AT_Acq_Deal_Sport_Ancillary] (
    [AT_Acq_Deal_Sport_Ancillary_Code] INT             IDENTITY (1, 1) NOT NULL,
    [AT_Acq_Deal_Code]                 INT             NULL,
    [Ancillary_For]                    CHAR (1)        NULL,
    [Sport_Ancillary_Type_Code]        INT             NULL,
    [Obligation_Broadcast]             CHAR (1)        NULL,
    [Broadcast_Window]                 INT             NULL,
    [Broadcast_Periodicity_Code]       INT             NULL,
    [Sport_Ancillary_Periodicity_Code] INT             NULL,
    [Duration]                         TIME (7)        NULL,
    [No_Of_Promos]                     INT             NULL,
    [Prime_Start_Time]                 TIME (7)        NULL,
    [Prime_End_Time]                   TIME (7)        NULL,
    [Prime_Durartion]                  TIME (7)        NULL,
    [Prime_No_of_Promos]               INT             NULL,
    [Off_Prime_Start_Time]             TIME (7)        NULL,
    [Off_Prime_End_Time]               TIME (7)        NULL,
    [Off_Prime_Durartion]              TIME (7)        NULL,
    [Off_Prime_No_of_Promos]           INT             NULL,
    [Remarks]                          NVARCHAR (4000) NULL,
    [Acq_Deal_Sport_Ancillary_Code]    INT             NOT NULL,
    CONSTRAINT [PK_AT_Acq_Deal_Sport_Ancillary] PRIMARY KEY CLUSTERED ([AT_Acq_Deal_Sport_Ancillary_Code] ASC),
    CONSTRAINT [FK_AT_Acq_Deal_Sport_Ancillary_AT_Acq_Deal_Sport_Ancillary] FOREIGN KEY ([AT_Acq_Deal_Code]) REFERENCES [dbo].[AT_Acq_Deal] ([AT_Acq_Deal_Code]),
    CONSTRAINT [FK_AT_Acq_Deal_Sport_Ancillary_Sport_Ancillary_Periodicity] FOREIGN KEY ([Sport_Ancillary_Periodicity_Code]) REFERENCES [dbo].[Sport_Ancillary_Periodicity] ([Sport_Ancillary_Periodicity_Code]),
    CONSTRAINT [FK_AT_Acq_Deal_Sport_Ancillary_Sport_Ancillary_Periodicity1] FOREIGN KEY ([Broadcast_Periodicity_Code]) REFERENCES [dbo].[Sport_Ancillary_Periodicity] ([Sport_Ancillary_Periodicity_Code]),
    CONSTRAINT [FK_AT_Acq_Deal_Sport_Ancillary_Sport_Ancillary_Type] FOREIGN KEY ([Sport_Ancillary_Type_Code]) REFERENCES [dbo].[Sport_Ancillary_Type] ([Sport_Ancillary_Type_Code])
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'P/M/F', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'AT_Acq_Deal_Sport_Ancillary', @level2type = N'COLUMN', @level2name = N'Ancillary_For';

