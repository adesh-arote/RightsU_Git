CREATE TABLE [dbo].[LeaderBoardData] (
    [LeaderBoardDataId] INT  IDENTITY (1, 1) NOT NULL,
    [UserId]            INT  NOT NULL,
    [RUPoints]          INT  DEFAULT ((0)) NOT NULL,
    [RptDate]           DATE NOT NULL,
    CONSTRAINT [PK_LeaderBoardData] PRIMARY KEY CLUSTERED ([LeaderBoardDataId] ASC),
    UNIQUE NONCLUSTERED ([UserId] ASC, [RptDate] ASC)
);

