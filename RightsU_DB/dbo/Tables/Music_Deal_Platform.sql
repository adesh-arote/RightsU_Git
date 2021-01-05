CREATE TABLE [dbo].[Music_Deal_Platform] (
    [Music_Deal_Platform_Code] INT IDENTITY (1, 1) NOT NULL,
    [Music_Deal_Code]          INT NULL,
    [Music_Platform_Code]      INT NULL,
    PRIMARY KEY CLUSTERED ([Music_Deal_Platform_Code] ASC),
    FOREIGN KEY ([Music_Deal_Code]) REFERENCES [dbo].[Music_Deal] ([Music_Deal_Code]),
    FOREIGN KEY ([Music_Platform_Code]) REFERENCES [dbo].[Music_Platform] ([Music_Platform_Code])
);

