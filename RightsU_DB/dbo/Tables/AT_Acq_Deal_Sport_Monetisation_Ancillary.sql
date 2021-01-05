CREATE TABLE [dbo].[AT_Acq_Deal_Sport_Monetisation_Ancillary] (
    [AT_Acq_Deal_Sport_Monetisation_Ancillary_Code] INT             IDENTITY (1, 1) NOT NULL,
    [AT_Acq_Deal_Code]                              INT             NULL,
    [Appoint_Title_Sponsor]                         CHAR (1)        NULL,
    [Appoint_Broadcast_Sponsor]                     CHAR (1)        NULL,
    [Remarks]                                       NVARCHAR (4000) NULL,
    [Acq_Deal_Sport_Monetisation_Ancillary_Code]    INT             NOT NULL,
    CONSTRAINT [PK_AT_Acq_Deal_Sport_Monetisation_Ancillary] PRIMARY KEY CLUSTERED ([AT_Acq_Deal_Sport_Monetisation_Ancillary_Code] ASC),
    CONSTRAINT [FK_AT_Acq_Deal_Sport_Monetisation_Ancillary_AT_Acq_Deal] FOREIGN KEY ([AT_Acq_Deal_Code]) REFERENCES [dbo].[AT_Acq_Deal] ([AT_Acq_Deal_Code])
);

