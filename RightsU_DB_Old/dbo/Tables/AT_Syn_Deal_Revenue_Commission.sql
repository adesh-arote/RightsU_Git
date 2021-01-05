CREATE TABLE [dbo].[AT_Syn_Deal_Revenue_Commission] (
    [AT_Syn_Deal_Revenue_Commission_Code] INT              IDENTITY (1, 1) NOT NULL,
    [AT_Syn_Deal_Revenue_Code]            INT              NULL,
    [Cost_Type_Code]                      INT              NULL,
    [Royalty_Commission_Code]             INT              NULL,
    [Vendor_Code]                         INT              NULL,
    [Entity_Code]                         INT              NULL,
    [Type]                                CHAR (1)         CONSTRAINT [DF_AT_Syn_Deal_Revenue_Commission_Type] DEFAULT ('O') NULL,
    [Commission_Type]                     CHAR (1)         CONSTRAINT [DF_AT_Syn_Deal_Revenue_Commission_Commission_Type] DEFAULT ('C') NULL,
    [Percentage]                          NUMERIC (18, 3)  NULL,
    [Amount]                              NUMERIC (32, 10) NULL,
    [Syn_Deal_Revenue_Commission_Code]    INT              NULL,
    CONSTRAINT [PK_AT_Syn_Deal_Revenue_Commission] PRIMARY KEY CLUSTERED ([AT_Syn_Deal_Revenue_Commission_Code] ASC),
    CONSTRAINT [FK_AT_Syn_Deal_Revenue_Commission_AT_Syn_Deal_Revenue] FOREIGN KEY ([AT_Syn_Deal_Revenue_Code]) REFERENCES [dbo].[AT_Syn_Deal_Revenue] ([AT_Syn_Deal_Revenue_Code]),
    CONSTRAINT [FK_AT_Syn_Deal_Revenue_Commission_Cost_Type] FOREIGN KEY ([Cost_Type_Code]) REFERENCES [dbo].[Cost_Type] ([Cost_Type_Code]),
    CONSTRAINT [FK_AT_Syn_Deal_Revenue_Commission_Entity] FOREIGN KEY ([Entity_Code]) REFERENCES [dbo].[Entity] ([Entity_Code]),
    CONSTRAINT [FK_AT_Syn_Deal_Revenue_Commission_Royalty_Commission] FOREIGN KEY ([Royalty_Commission_Code]) REFERENCES [dbo].[Royalty_Commission] ([Royalty_Commission_Code]),
    CONSTRAINT [FK_AT_Syn_Deal_Revenue_Commission_Vendor] FOREIGN KEY ([Vendor_Code]) REFERENCES [dbo].[Vendor] ([Vendor_Code])
);

