CREATE TABLE [dbo].[IPR_Opp_Channel] (
    [IPR_Opp_Channel_Code] INT IDENTITY (1, 1) NOT NULL,
    [IPR_Opp_Code]         INT NULL,
    [Channel_Code]         INT NULL,
    CONSTRAINT [PK_IPR_Opp_Channel] PRIMARY KEY CLUSTERED ([IPR_Opp_Channel_Code] ASC),
    CONSTRAINT [FK_IPR_Opp_Channel_Channel] FOREIGN KEY ([Channel_Code]) REFERENCES [dbo].[Channel] ([Channel_Code]),
    CONSTRAINT [FK_IPR_Opp_Channel_IPR_Opp] FOREIGN KEY ([IPR_Opp_Code]) REFERENCES [dbo].[IPR_Opp] ([IPR_Opp_Code])
);

