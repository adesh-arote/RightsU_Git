CREATE TABLE [dbo].[ServiceLog] (
    [ServiceLogID] INT           IDENTITY (1, 1) NOT NULL,
    [LogType]      INT           NULL,
    [UserCode]     INT           NULL,
    [UserName]     VARCHAR (200) NULL,
    [MethodName]   VARCHAR (200) NULL,
    [Request]      VARCHAR (MAX) NULL,
    [Response]     VARCHAR (MAX) NULL,
    [RequestTime]  DATETIME      CONSTRAINT [DF_ServiceLog_RequestTime] DEFAULT (getdate()) NULL,
    [ResponseTime] DATETIME      CONSTRAINT [DF_ServiceLog_ResponseTime] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_ServiceLog] PRIMARY KEY CLUSTERED ([ServiceLogID] ASC)
);

