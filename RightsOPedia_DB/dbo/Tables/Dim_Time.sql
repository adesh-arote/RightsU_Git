CREATE TABLE [dbo].[Dim_Time] (
    [TimeId]  INT NOT NULL,
    [DayId]   INT NOT NULL,
    [Day]     INT NOT NULL,
    [Week]    INT NOT NULL,
    [BiWeek]  INT NOT NULL,
    [Quarter] INT NOT NULL,
    [MonthId] INT NOT NULL,
    [Year]    INT NOT NULL,
    CONSTRAINT [PK_Dim_Time] PRIMARY KEY CLUSTERED ([TimeId] ASC)
);

