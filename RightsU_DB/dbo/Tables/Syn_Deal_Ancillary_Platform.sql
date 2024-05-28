CREATE TABLE [dbo].[Syn_Deal_Ancillary_Platform] (
    [Syn_Deal_Ancillary_Platform_Code] INT IDENTITY (1, 1) NOT NULL,
    [Syn_Deal_Ancillary_Code]          INT NULL,
    [Ancillary_Platform_code]          INT NULL,
    CONSTRAINT [PK_Syn_Deal_Ancillary_Platform] PRIMARY KEY CLUSTERED ([Syn_Deal_Ancillary_Platform_Code] ASC),
    CONSTRAINT [FK_Syn_Deal_Ancillary_Platform_Ancillary_Platform] FOREIGN KEY ([Ancillary_Platform_code]) REFERENCES [dbo].[Ancillary_Platform] ([Ancillary_Platform_code]),
    CONSTRAINT [FK_Syn_Deal_Ancillary_Platform_Syn_Deal_Ancillary] FOREIGN KEY ([Syn_Deal_Ancillary_Code]) REFERENCES [dbo].[Syn_Deal_Ancillary] ([Syn_Deal_Ancillary_Code])
);

