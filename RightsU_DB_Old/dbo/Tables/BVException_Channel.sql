CREATE TABLE [dbo].[BVException_Channel] (
    [Bv_Exception_Channel_Code] INT IDENTITY (1, 1) NOT NULL,
    [Bv_Exception_Code]         INT NOT NULL,
    [Channel_Code]              INT NOT NULL,
    CONSTRAINT [PK_Exception_Channel] PRIMARY KEY CLUSTERED ([Bv_Exception_Channel_Code] ASC),
    CONSTRAINT [FK_BVException_Channel_BVException] FOREIGN KEY ([Bv_Exception_Code]) REFERENCES [dbo].[BVException] ([Bv_Exception_Code]),
    CONSTRAINT [FK_BVException_Channel_Channel] FOREIGN KEY ([Channel_Code]) REFERENCES [dbo].[Channel] ([Channel_Code])
);

