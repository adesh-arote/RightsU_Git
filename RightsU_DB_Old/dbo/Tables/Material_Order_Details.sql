CREATE TABLE [dbo].[Material_Order_Details] (
    [Material_Order_Detail_Code] INT             IDENTITY (1, 1) NOT NULL,
    [Material_Order_Code]        INT             NULL,
    [Acq_Deal_Code]              INT             NULL,
    [Acq_Deal_Movie_Code]        INT             NULL,
    [Material_Medium_Code]       INT             NULL,
    [Order_Quantity]             INT             NULL,
    [Currency_Code]              INT             NULL,
    [Rate]                       NUMERIC (18, 3) NULL,
    [Amount]                     NUMERIC (38, 3) NULL,
    [Received_Quantity]          INT             CONSTRAINT [DF_Material_Order_Details_Received_Quantity] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Material_Order_Details] PRIMARY KEY CLUSTERED ([Material_Order_Detail_Code] ASC),
    CONSTRAINT [FK_Material_Order_Details_Currency] FOREIGN KEY ([Currency_Code]) REFERENCES [dbo].[Currency] ([Currency_Code]),
    CONSTRAINT [FK_Material_Order_Details_Deal] FOREIGN KEY ([Acq_Deal_Code]) REFERENCES [dbo].[Acq_Deal] ([Acq_Deal_Code]),
    CONSTRAINT [FK_Material_Order_Details_Deal_Movie] FOREIGN KEY ([Acq_Deal_Movie_Code]) REFERENCES [dbo].[Acq_Deal_Movie] ([Acq_Deal_Movie_Code]),
    CONSTRAINT [FK_Material_Order_Details_Material_Medium] FOREIGN KEY ([Material_Medium_Code]) REFERENCES [dbo].[Material_Medium] ([Material_Medium_Code]),
    CONSTRAINT [FK_Material_Order_Details_Material_Order] FOREIGN KEY ([Material_Order_Code]) REFERENCES [dbo].[Material_Order] ([Material_Order_Code])
);

