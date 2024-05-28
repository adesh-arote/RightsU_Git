CREATE TABLE [dbo].[Channel_Category_Details] (
    [Channel_Category_Details_Code] INT IDENTITY (1, 1) NOT NULL,
    [Channel_Category_Code]         INT NULL,
    [Channel_Code]                  INT NULL,
    CONSTRAINT [PK_Channel_Category_Details] PRIMARY KEY CLUSTERED ([Channel_Category_Details_Code] ASC),
    CONSTRAINT [FK_Channel_Category_Details_Channel] FOREIGN KEY ([Channel_Code]) REFERENCES [dbo].[Channel] ([Channel_Code]),
    CONSTRAINT [FK_Channel_Category_Details_Channel_Category] FOREIGN KEY ([Channel_Category_Code]) REFERENCES [dbo].[Channel_Category] ([Channel_Category_Code])
);

