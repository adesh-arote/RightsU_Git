﻿CREATE TABLE [dbo].[IPR_REP_CLASS] (
    [IPR_Rep_Class_Code] INT IDENTITY (1, 1) NOT NULL,
    [IPR_Rep_Code]       INT NULL,
    [IPR_Class_Code]     INT NULL,
    CONSTRAINT [PK_IPR_REP_CLASS] PRIMARY KEY CLUSTERED ([IPR_Rep_Class_Code] ASC),
    CONSTRAINT [FK_IPR_REP_CLASS_IPR_CLASS] FOREIGN KEY ([IPR_Class_Code]) REFERENCES [dbo].[IPR_CLASS] ([IPR_Class_Code]),
    CONSTRAINT [FK_IPR_REP_CLASS_IPR_REP] FOREIGN KEY ([IPR_Rep_Code]) REFERENCES [dbo].[IPR_REP] ([IPR_Rep_Code])
);
