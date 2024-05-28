CREATE TABLE [dbo].[AT_Music_Deal_Channel] (
    [AT_Music_Deal_Channel_Code] INT IDENTITY (1, 1) NOT NULL,
    [AT_Music_Deal_Code]         INT NULL,
    [Channel_Code]               INT NULL,
    [Defined_Runs]               INT NULL,
    [Scheduled_Runs]             INT NULL,
    [Music_Deal_Channel_Code]    INT NULL,
    CONSTRAINT [PK_AT_Music_Deal_Channel] PRIMARY KEY CLUSTERED ([AT_Music_Deal_Channel_Code] ASC),
    CONSTRAINT [FK_AT_Music_Deal_Channel_AT_Music_Deal] FOREIGN KEY ([AT_Music_Deal_Code]) REFERENCES [dbo].[AT_Music_Deal] ([AT_Music_Deal_Code]),
    CONSTRAINT [FK_AT_Music_Deal_Channel_Channel] FOREIGN KEY ([Channel_Code]) REFERENCES [dbo].[Channel] ([Channel_Code])
);

