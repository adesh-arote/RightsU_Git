CREATE TABLE [dbo].[AT_Syn_Deal_Ancillary] (
    [AT_Syn_Deal_Ancillary_Code] INT             IDENTITY (1, 1) NOT NULL,
    [AT_Syn_Deal_Code]           INT             NULL,
    [Ancillary_Type_code]        INT             NULL,
    [Duration]                   NUMERIC (5)     NULL,
    [Day]                        NUMERIC (4)     NULL,
    [Remarks]                    NVARCHAR (4000) NULL,
    [Group_No]                   INT             NULL,
    [Syn_Deal_Ancillary_Code]    INT             NULL,
    CONSTRAINT [PK_AT_Syn_Deal_Ancillary] PRIMARY KEY CLUSTERED ([AT_Syn_Deal_Ancillary_Code] ASC),
    CONSTRAINT [FK_AT_Syn_Deal_Ancillary_Ancillary_Type] FOREIGN KEY ([Ancillary_Type_code]) REFERENCES [dbo].[Ancillary_Type] ([Ancillary_Type_Code]),
    CONSTRAINT [FK_AT_Syn_Deal_Ancillary_AT_Syn_Deal] FOREIGN KEY ([AT_Syn_Deal_Code]) REFERENCES [dbo].[AT_Syn_Deal] ([AT_Syn_Deal_Code])
);



