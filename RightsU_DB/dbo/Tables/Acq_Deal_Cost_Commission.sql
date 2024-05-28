CREATE TABLE [dbo].[Acq_Deal_Cost_Commission] (
    [Acq_Deal_Cost_Commission_Code] INT              IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Cost_Code]            INT              NULL,
    [Cost_Type_Code]                INT              NULL,
    [Royalty_Commission_Code]       INT              NULL,
    [Vendor_Code]                   INT              NULL,
    [Entity_Code]                   INT              NULL,
    [Type]                          CHAR (1)         CONSTRAINT [DF_Acq_Deal_Cost_Commission_Type] DEFAULT ('O') NULL,
    [Commission_Type]               CHAR (1)         CONSTRAINT [DF_Acq_Deal_Cost_Commission_Commission_Type] DEFAULT ('C') NULL,
    [Percentage]                    NUMERIC (18, 3)  NULL,
    [Amount]                        NUMERIC (32, 10) NULL,
    CONSTRAINT [PK_Acq_Deal_Cost_Commission] PRIMARY KEY CLUSTERED ([Acq_Deal_Cost_Commission_Code] ASC),
    CONSTRAINT [FK_Acq_Deal_Cost_Commission_Acq_Deal_Cost] FOREIGN KEY ([Acq_Deal_Cost_Code]) REFERENCES [dbo].[Acq_Deal_Cost] ([Acq_Deal_Cost_Code]),
    CONSTRAINT [FK_Acq_Deal_Cost_Commission_Cost_Type] FOREIGN KEY ([Cost_Type_Code]) REFERENCES [dbo].[Cost_Type] ([Cost_Type_Code]),
    CONSTRAINT [FK_Acq_Deal_Cost_Commission_Entity] FOREIGN KEY ([Entity_Code]) REFERENCES [dbo].[Entity] ([Entity_Code]),
    CONSTRAINT [FK_Acq_Deal_Cost_Commission_Royalty_Commission] FOREIGN KEY ([Royalty_Commission_Code]) REFERENCES [dbo].[Royalty_Commission] ([Royalty_Commission_Code]),
    CONSTRAINT [FK_Acq_Deal_Cost_Commission_Vendor] FOREIGN KEY ([Vendor_Code]) REFERENCES [dbo].[Vendor] ([Vendor_Code])
);

