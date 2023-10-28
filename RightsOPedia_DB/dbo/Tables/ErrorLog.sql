CREATE TABLE [dbo].[ErrorLog] (
    [ErrorLogCode] NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [ErrorDate]    DATETIME2 (7)  NULL,
    [Message]      NVARCHAR (MAX) NULL,
    [MachineName]  NVARCHAR (MAX) NULL,
    [ProcessCode]  NVARCHAR (MAX) NULL,
    [ThreadCode]   NVARCHAR (MAX) NULL,
    [Level]        NVARCHAR (MAX) NULL,
    [Logger]       NVARCHAR (MAX) NULL,
    [UserCode]     VARCHAR (100)  NULL,
    [Request]      NVARCHAR (MAX) NULL,
    [Module]       VARCHAR (500)  NULL,
    CONSTRAINT [PK_ErrorLog] PRIMARY KEY CLUSTERED ([ErrorLogCode] ASC)
);

