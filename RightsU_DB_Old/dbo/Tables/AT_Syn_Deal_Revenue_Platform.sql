CREATE TABLE [dbo].[AT_Syn_Deal_Revenue_Platform] (
    [AT_Syn_Deal_Revenue_Platform_Code] INT IDENTITY (1, 1) NOT NULL,
    [AT_Syn_Deal_Revenue_Code]          INT NULL,
    [Platform_Code]                     INT NULL,
    CONSTRAINT [PK_AT_Syn_Deal_Revenue_Platform] PRIMARY KEY CLUSTERED ([AT_Syn_Deal_Revenue_Platform_Code] ASC),
    CONSTRAINT [FK_AT_Syn_Deal_Revenue_Platform_AT_Syn_Deal_Revenue] FOREIGN KEY ([AT_Syn_Deal_Revenue_Code]) REFERENCES [dbo].[AT_Syn_Deal_Revenue] ([AT_Syn_Deal_Revenue_Code]),
    CONSTRAINT [FK_AT_Syn_Deal_Revenue_Platform_Platform] FOREIGN KEY ([Platform_Code]) REFERENCES [dbo].[Platform] ([Platform_Code])
);

