CREATE TABLE [dbo].[Music_Deal_Channel] (
    [Music_Deal_Channel_Code] INT IDENTITY (1, 1) NOT NULL,
    [Music_Deal_Code]         INT NULL,
    [Channel_Code]            INT NULL,
    [Defined_Runs]            INT NULL,
    [Scheduled_Runs]          INT NULL,
    CONSTRAINT [PK_Music_Deal_Channel] PRIMARY KEY CLUSTERED ([Music_Deal_Channel_Code] ASC),
    CONSTRAINT [FK_Music_Deal_Channel_Channel] FOREIGN KEY ([Channel_Code]) REFERENCES [dbo].[Channel] ([Channel_Code]),
    CONSTRAINT [FK_Music_Deal_Channel_Music_Deal] FOREIGN KEY ([Music_Deal_Code]) REFERENCES [dbo].[Music_Deal] ([Music_Deal_Code])
);

