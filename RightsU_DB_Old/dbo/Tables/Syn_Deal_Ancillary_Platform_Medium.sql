CREATE TABLE [dbo].[Syn_Deal_Ancillary_Platform_Medium] (
    [Syn_Deal_Ancillary_Platform_Medium_Code] INT IDENTITY (1, 1) NOT NULL,
    [Syn_Deal_Ancillary_Platform_Code]        INT NULL,
    [Ancillary_Platform_Medium_Code]          INT NULL,
    CONSTRAINT [PK_Syn_Deal_Ancillary_Medium] PRIMARY KEY CLUSTERED ([Syn_Deal_Ancillary_Platform_Medium_Code] ASC),
    CONSTRAINT [FK_Syn_Deal_Ancillary_Platform_Medium_Ancillary_Platform_Medium] FOREIGN KEY ([Ancillary_Platform_Medium_Code]) REFERENCES [dbo].[Ancillary_Platform_Medium] ([Ancillary_Platform_Medium_Code]),
    CONSTRAINT [FK_Syn_Deal_Ancillary_Platform_Medium_Syn_Deal_Ancillary_Platform] FOREIGN KEY ([Syn_Deal_Ancillary_Platform_Code]) REFERENCES [dbo].[Syn_Deal_Ancillary_Platform] ([Syn_Deal_Ancillary_Platform_Code])
);

