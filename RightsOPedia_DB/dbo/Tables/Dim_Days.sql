CREATE TABLE [dbo].[Dim_Days] (
    [DayId]    INT          NOT NULL,
    [DayShort] VARCHAR (50) NULL,
    [DayLong]  VARCHAR (50) NULL,
    CONSTRAINT [PK_Dim_Days] PRIMARY KEY CLUSTERED ([DayId] ASC)
);

