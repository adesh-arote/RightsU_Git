CREATE TABLE [dbo].[Channel_Entity] (
    [Channel_Entity_Code]  INT      IDENTITY (1, 1) NOT NULL,
    [Channel_Code]         INT      NULL,
    [Entity_Code]          INT      NULL,
    [Effective_Start_Date] DATETIME NOT NULL,
    [System_End_Date]      DATETIME NULL,
    [Last_Updated_Time]    DATETIME NULL,
    [Last_Action_By]       INT      NULL,
    CONSTRAINT [PK_Channel_Entity] PRIMARY KEY CLUSTERED ([Channel_Entity_Code] ASC),
    CONSTRAINT [FK_Channel_Entity_Channel] FOREIGN KEY ([Channel_Code]) REFERENCES [dbo].[Channel] ([Channel_Code])
);

