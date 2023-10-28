CREATE TABLE [dbo].[Trace_ML] (
    [TraceId]               INT           NOT NULL,
    [RequestId]             VARCHAR (50)  NULL,
    [UserId]                INT           NULL,
    [RequestUri]            VARCHAR (200) NULL,
    [RequestMethod]         VARCHAR (200) NULL,
    [Method]                VARCHAR (200) NULL,
    [IsSuccess]             BIT           NULL,
    [TimeTaken]             INT           NULL,
    [RequestContent]        VARCHAR (MAX) NULL,
    [RequestLength]         INT           NULL,
    [RequestDateTime]       DATETIME      NULL,
    [ResponseContent]       VARCHAR (MAX) NULL,
    [ResponseLength]        INT           NULL,
    [ResponseDateTime]      DATETIME      NULL,
    [HttpStatusCode]        INT           NULL,
    [HttpStatusDescription] VARCHAR (MAX) NULL,
    [AuthenticationKey]     VARCHAR (MAX) NULL,
    [UserAgent]             VARCHAR (200) NULL,
    [ServerName]            VARCHAR (200) NULL,
    [ClientIpAddress]       VARCHAR (100) NULL
);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20200817-114220]
    ON [dbo].[Trace_ML]([RequestUri] ASC, [RequestMethod] ASC, [Method] ASC, [RequestDateTime] ASC, [ResponseDateTime] ASC, [HttpStatusCode] ASC, [ServerName] ASC);

