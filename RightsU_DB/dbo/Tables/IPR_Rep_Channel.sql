CREATE TABLE [dbo].[IPR_Rep_Channel] (
    [IPR_Rep_Channel_Code] INT IDENTITY (1, 1) NOT NULL,
    [IPR_Rep_Code]         INT NULL,
    [Channel_Code]         INT NULL,
    CONSTRAINT [PK_IPR_Rep_Channel] PRIMARY KEY CLUSTERED ([IPR_Rep_Channel_Code] ASC),
    CONSTRAINT [FK_IPR_Rep_Channel_Channel] FOREIGN KEY ([Channel_Code]) REFERENCES [dbo].[Channel] ([Channel_Code]),
    CONSTRAINT [FK_IPR_Rep_Channel_IPR_REP] FOREIGN KEY ([IPR_Rep_Code]) REFERENCES [dbo].[IPR_REP] ([IPR_Rep_Code])
);

