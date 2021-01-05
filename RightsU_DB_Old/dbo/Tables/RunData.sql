CREATE TABLE [dbo].[RunData] (
    [Id]             INT            NOT NULL,
    [ChannelCode]    INT            NOT NULL,
    [ChannelName]    VARCHAR (5000) NULL,
    [ParameterName]  VARCHAR (5000) NULL,
    [ParameterValue] VARCHAR (5000) NULL,
    CONSTRAINT [FK_RunData_Channel] FOREIGN KEY ([ChannelCode]) REFERENCES [dbo].[Channel] ([Channel_Code])
);

