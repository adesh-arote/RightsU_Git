CREATE TABLE [dbo].[Acq_Deal_Sport_Sales_Ancillary_Sponsor] (
    [Acq_Deal_Sport_Sales_Ancillary_Sponsor_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Sport_Sales_Ancillary_Code]         INT      NULL,
    [Sponsor_Code]                                INT      NULL,
    [Sponsor_Type]                                CHAR (1) NULL,
    CONSTRAINT [PK_Acq_Deal_Sport_Sales_Ancillary_Sponsor] PRIMARY KEY CLUSTERED ([Acq_Deal_Sport_Sales_Ancillary_Sponsor_Code] ASC),
    CONSTRAINT [FK_Acq_Deal_Sport_Sales_Ancillary_Sponsor_Acq_Deal_Sport_Sales_Ancillary] FOREIGN KEY ([Acq_Deal_Sport_Sales_Ancillary_Code]) REFERENCES [dbo].[Acq_Deal_Sport_Sales_Ancillary] ([Acq_Deal_Sport_Sales_Ancillary_Code]),
    CONSTRAINT [FK_Acq_Deal_Sport_Sales_Ancillary_Sponsor_Sponsor] FOREIGN KEY ([Sponsor_Code]) REFERENCES [dbo].[Sponsor] ([Sponsor_Code])
);

