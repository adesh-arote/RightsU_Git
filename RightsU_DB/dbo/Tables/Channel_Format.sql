CREATE TABLE [dbo].[Channel_Format] (
    [Channel_Format_Code] INT           IDENTITY (1, 1) NOT NULL,
    [Channel_Format_Desc] VARCHAR (100) NULL,
    [Channel_Format_Flag] VARCHAR (2)   NULL,
    CONSTRAINT [PK_Channel_Format] PRIMARY KEY CLUSTERED ([Channel_Format_Code] ASC)
);

