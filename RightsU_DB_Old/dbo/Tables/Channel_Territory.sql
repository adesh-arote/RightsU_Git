CREATE TABLE [dbo].[Channel_Territory] (
    [Channel_Territory_Code] INT IDENTITY (1, 1) NOT NULL,
    [Channel_Code]           INT NULL,
    [Country_Code]           INT NULL,
    CONSTRAINT [PK_Channel_Territory] PRIMARY KEY CLUSTERED ([Channel_Territory_Code] ASC),
    CONSTRAINT [FK_Channel_Territory_Channel] FOREIGN KEY ([Country_Code]) REFERENCES [dbo].[Country] ([Country_Code]),
    CONSTRAINT [FK_Channel_Territory_Channel1] FOREIGN KEY ([Channel_Code]) REFERENCES [dbo].[Channel] ([Channel_Code])
);

