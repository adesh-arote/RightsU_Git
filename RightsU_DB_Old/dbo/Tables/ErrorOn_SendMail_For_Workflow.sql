CREATE TABLE [dbo].[ErrorOn_SendMail_For_Workflow] (
    [Error_Id]       INT            IDENTITY (1, 1) NOT NULL,
    [ErrorNumber]    NUMERIC (18)   NULL,
    [ErrorSeverity]  NUMERIC (18)   NULL,
    [ErrorState]     NUMERIC (18)   NULL,
    [ErrorProcedure] NVARCHAR (100) NULL,
    [ErrorLine]      NUMERIC (18)   NULL,
    [ErrorMessage]   VARCHAR (MAX)  NULL,
    CONSTRAINT [PK_ErrorOn_SendMail_For_Workflow] PRIMARY KEY CLUSTERED ([Error_Id] ASC)
);

