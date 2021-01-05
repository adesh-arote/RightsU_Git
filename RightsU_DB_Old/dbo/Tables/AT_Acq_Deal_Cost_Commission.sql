CREATE TABLE [dbo].[AT_Acq_Deal_Cost_Commission] (
    [AT_Acq_Deal_Cost_Commission_Code] INT              IDENTITY (1, 1) NOT NULL,
    [AT_Acq_Deal_Cost_Code]            INT              NULL,
    [Cost_Type_Code]                   INT              NULL,
    [Royalty_Commission_Code]          INT              NULL,
    [Vendor_Code]                      INT              NULL,
    [Entity_Code]                      INT              NULL,
    [Type]                             CHAR (1)         CONSTRAINT [DF_AT_Acq_Deal_Cost_Commission_Type] DEFAULT ('O') NULL,
    [Commission_Type]                  CHAR (1)         CONSTRAINT [DF_AT_Acq_Deal_Cost_Commission_Commission_Type] DEFAULT ('C') NULL,
    [Percentage]                       NUMERIC (18, 3)  NULL,
    [Amount]                           NUMERIC (32, 10) NULL,
    [Acq_Deal_Cost_Commission_Code]    INT              NULL,
    CONSTRAINT [PK_AT_Acq_Deal_Cost_Commission] PRIMARY KEY CLUSTERED ([AT_Acq_Deal_Cost_Commission_Code] ASC),
    CONSTRAINT [FK_AT_Acq_Deal_Cost_Commission_AT_Acq_Deal_Cost] FOREIGN KEY ([AT_Acq_Deal_Cost_Code]) REFERENCES [dbo].[AT_Acq_Deal_Cost] ([AT_Acq_Deal_Cost_Code]),
    CONSTRAINT [FK_AT_Acq_Deal_Cost_Commission_Cost_Type] FOREIGN KEY ([Cost_Type_Code]) REFERENCES [dbo].[Cost_Type] ([Cost_Type_Code]),
    CONSTRAINT [FK_AT_Acq_Deal_Cost_Commission_Entity] FOREIGN KEY ([Entity_Code]) REFERENCES [dbo].[Entity] ([Entity_Code]),
    CONSTRAINT [FK_AT_Acq_Deal_Cost_Commission_Royalty_Commission] FOREIGN KEY ([Royalty_Commission_Code]) REFERENCES [dbo].[Royalty_Commission] ([Royalty_Commission_Code]),
    CONSTRAINT [FK_AT_Acq_Deal_Cost_Commission_Vendor] FOREIGN KEY ([Vendor_Code]) REFERENCES [dbo].[Vendor] ([Vendor_Code])
);

