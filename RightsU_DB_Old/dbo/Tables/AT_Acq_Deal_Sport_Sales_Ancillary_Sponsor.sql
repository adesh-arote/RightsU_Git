CREATE TABLE [dbo].[AT_Acq_Deal_Sport_Sales_Ancillary_Sponsor] (
    [AT_Acq_Deal_Sport_Sales_Ancillary_Sponsor_Code] INT      IDENTITY (1, 1) NOT NULL,
    [AT_Acq_Deal_Sport_Sales_Ancillary_Code]         INT      NULL,
    [Sponsor_Code]                                   INT      NULL,
    [Sponsor_Type]                                   CHAR (1) NULL,
    [Acq_Deal_Sport_Sales_Ancillary_Sponsor_Code]    INT      NOT NULL,
    CONSTRAINT [PK_AT_Acq_Deal_Sport_Sales_Ancillary_Sponsor] PRIMARY KEY CLUSTERED ([AT_Acq_Deal_Sport_Sales_Ancillary_Sponsor_Code] ASC),
    CONSTRAINT [FK_AT_Acq_Deal_Sport_Sales_Ancillary_Sponsor_AT_Acq_Deal_Sport_Sales_Ancillary] FOREIGN KEY ([AT_Acq_Deal_Sport_Sales_Ancillary_Code]) REFERENCES [dbo].[AT_Acq_Deal_Sport_Sales_Ancillary] ([AT_Acq_Deal_Sport_Sales_Ancillary_Code]),
    CONSTRAINT [FK_AT_Acq_Deal_Sport_Sales_Ancillary_Sponsor_Sponsor] FOREIGN KEY ([Sponsor_Code]) REFERENCES [dbo].[Sponsor] ([Sponsor_Code])
);

