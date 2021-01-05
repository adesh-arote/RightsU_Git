CREATE TABLE [dbo].[LoggedInUsers] (
    [LoggedInUsersCode] INT           IDENTITY (1, 1) NOT NULL,
    [LoginName]         VARCHAR (250) NULL,
    [HostIP]            VARCHAR (50)  NULL,
    [BrowserDetails]    VARCHAR (500) NULL,
    [AccessToken]       VARCHAR (MAX) NULL,
    [RefreshToken]      VARCHAR (500) NULL,
    [LoggedInUrl]       VARCHAR (500) NULL,
    [LoggedinTime]      DATETIME      NULL,
    [LastUpdatedTime]   DATETIME      NULL,
    PRIMARY KEY CLUSTERED ([LoggedInUsersCode] ASC)
);

