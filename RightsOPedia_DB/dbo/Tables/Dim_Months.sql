CREATE TABLE [dbo].[Dim_Months] (
    [MonthId]    INT          NOT NULL,
    [MonthShort] VARCHAR (50) NULL,
    [MonthLong]  VARCHAR (50) NULL,
    CONSTRAINT [PK_Dim_Months] PRIMARY KEY CLUSTERED ([MonthId] ASC)
);

