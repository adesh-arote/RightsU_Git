CREATE TABLE [dbo].[Syn_Deal_Ancillary_Title] (
    [Syn_Deal_Ancillary_Title_Code] INT IDENTITY (1, 1) NOT NULL,
    [Syn_Deal_Ancillary_Code]       INT NULL,
    [Title_Code]                    INT NULL,
    [Episode_From]                  INT NULL,
    [Episode_To]                    INT NULL,
    CONSTRAINT [PK_Syn_Deal_Ancillary_Title] PRIMARY KEY CLUSTERED ([Syn_Deal_Ancillary_Title_Code] ASC),
    CONSTRAINT [FK_Syn_Deal_Ancillary_Title_Syn_Deal_Ancillary] FOREIGN KEY ([Syn_Deal_Ancillary_Code]) REFERENCES [dbo].[Syn_Deal_Ancillary] ([Syn_Deal_Ancillary_Code]),
    CONSTRAINT [FK_Syn_Deal_Ancillary_Title_Title] FOREIGN KEY ([Title_Code]) REFERENCES [dbo].[Title] ([Title_Code])
);

