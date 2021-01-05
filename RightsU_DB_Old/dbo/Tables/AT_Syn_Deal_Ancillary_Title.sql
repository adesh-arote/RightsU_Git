﻿CREATE TABLE [dbo].[AT_Syn_Deal_Ancillary_Title] (
    [AT_Syn_Deal_Ancillary_Title_Code] INT IDENTITY (1, 1) NOT NULL,
    [AT_Syn_Deal_Ancillary_Code]       INT NULL,
    [Title_Code]                       INT NULL,
    [Episode_From]                     INT NULL,
    [Episode_To]                       INT NULL,
    [Syn_Deal_Ancillary_Title_Code]    INT NULL,
    CONSTRAINT [PK_AT_Syn_Deal_Ancillary_Title] PRIMARY KEY CLUSTERED ([AT_Syn_Deal_Ancillary_Title_Code] ASC),
    CONSTRAINT [FK_AT_Syn_Deal_Ancillary_Title_AT_Syn_Deal_Ancillary] FOREIGN KEY ([AT_Syn_Deal_Ancillary_Code]) REFERENCES [dbo].[AT_Syn_Deal_Ancillary] ([AT_Syn_Deal_Ancillary_Code]),
    CONSTRAINT [FK_AT_Syn_Deal_Ancillary_Title_Title] FOREIGN KEY ([Title_Code]) REFERENCES [dbo].[Title] ([Title_Code])
);

