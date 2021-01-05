CREATE TABLE [dbo].[Acq_Deal_Sport_Monetisation_Ancillary] (
    [Acq_Deal_Sport_Monetisation_Ancillary_Code] INT             IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Code]                              INT             NULL,
    [Appoint_Title_Sponsor]                      CHAR (1)        NULL,
    [Appoint_Broadcast_Sponsor]                  CHAR (1)        NULL,
    [Remarks]                                    NVARCHAR (4000) NULL,
    CONSTRAINT [PK_Acq_Deal_Sport_Monetisation_Ancillary] PRIMARY KEY CLUSTERED ([Acq_Deal_Sport_Monetisation_Ancillary_Code] ASC),
    CONSTRAINT [FK_Acq_Deal_Sport_Monetisation_Ancillary_Acq_Deal] FOREIGN KEY ([Acq_Deal_Code]) REFERENCES [dbo].[Acq_Deal] ([Acq_Deal_Code])
);

