CREATE TABLE [dbo].[ErrorOn_AsRun_Schedule] (
    [Error_Id]       INT            IDENTITY (1, 1) NOT NULL,
    [ErrorNumber]    NUMERIC (18)   NULL,
    [ErrorSeverity]  NUMERIC (18)   NULL,
    [ErrorState]     NUMERIC (18)   NULL,
    [ErrorProcedure] NVARCHAR (100) NULL,
    [ErrorLine]      NUMERIC (18)   NULL,
    [ErrorMessage]   VARCHAR (MAX)  NULL,
    [FileCode]       INT            NULL,
    [ChannelCode]    INT            NULL,
    [ErrorFor]       VARCHAR (50)   NULL,
    [ErrorDate]      DATETIME       NULL,
    CONSTRAINT [PK_ErrorOn_AsRun_Schedule] PRIMARY KEY CLUSTERED ([Error_Id] ASC)
);

