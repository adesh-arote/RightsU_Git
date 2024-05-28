CREATE TABLE [dbo].[Syn_Deal_Revenue_Platform] (
    [Syn_Deal_Revenue_Platform_Code] INT IDENTITY (1, 1) NOT NULL,
    [Syn_Deal_Revenue_Code]          INT NULL,
    [Platform_Code]                  INT NULL,
    CONSTRAINT [PK_Syn_Deal_Revenue_Platform] PRIMARY KEY CLUSTERED ([Syn_Deal_Revenue_Platform_Code] ASC),
    CONSTRAINT [FK_Syn_Deal_Revenue_Platform_Platform] FOREIGN KEY ([Platform_Code]) REFERENCES [dbo].[Platform] ([Platform_Code]),
    CONSTRAINT [FK_Syn_Deal_Revenue_Platform_Syn_Deal_Revenue] FOREIGN KEY ([Syn_Deal_Revenue_Code]) REFERENCES [dbo].[Syn_Deal_Revenue] ([Syn_Deal_Revenue_Code])
);

