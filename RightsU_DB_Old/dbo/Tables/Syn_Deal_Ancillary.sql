CREATE TABLE [dbo].[Syn_Deal_Ancillary] (
    [Syn_Deal_Ancillary_Code] INT             IDENTITY (1, 1) NOT NULL,
    [Syn_Deal_Code]           INT             NULL,
    [Ancillary_Type_code]     INT             NULL,
    [Duration]                NUMERIC (5)     NULL,
    [Day]                     NUMERIC (4)     NULL,
    [Remarks]                 NVARCHAR (4000) NULL,
    [Group_No]                INT             NULL,
    CONSTRAINT [PK_Syn_Deal_Ancillary] PRIMARY KEY CLUSTERED ([Syn_Deal_Ancillary_Code] ASC),
    CONSTRAINT [FK_Syn_Deal_Ancillary_Ancillary_Type] FOREIGN KEY ([Ancillary_Type_code]) REFERENCES [dbo].[Ancillary_Type] ([Ancillary_Type_Code]),
    CONSTRAINT [FK_Syn_Deal_Ancillary_Syn_Deal] FOREIGN KEY ([Syn_Deal_Code]) REFERENCES [dbo].[Syn_Deal] ([Syn_Deal_Code])
);



