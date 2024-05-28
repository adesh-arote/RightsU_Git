CREATE TABLE [dbo].[AT_Syn_Deal_Ancillary_Platform] (
    [AT_Syn_Deal_Ancillary_Platform_Code] INT IDENTITY (1, 1) NOT NULL,
    [AT_Syn_Deal_Ancillary_Code]          INT NULL,
    [Ancillary_Platform_code]             INT NULL,
    [Syn_Deal_Ancillary_Platform_Code]    INT NULL,
    CONSTRAINT [PK_AT_Syn_Deal_Ancillary_Platform] PRIMARY KEY CLUSTERED ([AT_Syn_Deal_Ancillary_Platform_Code] ASC),
    CONSTRAINT [FK_AT_Syn_Deal_Ancillary_Platform_Ancillary_Platform] FOREIGN KEY ([Ancillary_Platform_code]) REFERENCES [dbo].[Ancillary_Platform] ([Ancillary_Platform_code]),
    CONSTRAINT [FK_AT_Syn_Deal_Ancillary_Platform_AT_Syn_Deal_Ancillary] FOREIGN KEY ([AT_Syn_Deal_Ancillary_Code]) REFERENCES [dbo].[AT_Syn_Deal_Ancillary] ([AT_Syn_Deal_Ancillary_Code])
);

