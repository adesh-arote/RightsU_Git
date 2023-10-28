CREATE TABLE [dbo].[ScheduleLog] (
    [USPName]      VARCHAR (MAX)  NULL,
    [File_Code]    INT            NULL,
    [Channel_Code] INT            NULL,
    [BVID]         VARCHAR (1000) NULL,
    [IsProcess]    VARCHAR (5)    NULL,
    [CanProcess]   VARCHAR (1000) NULL,
    [STEPName]     NVARCHAR (MAX) NULL,
    [StepTime]     DATETIME       NULL
);

