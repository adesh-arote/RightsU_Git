CREATE TABLE [dbo].[Import_Log_Detail] (
    [Import_Log_Detail_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Import_Log_Code]        INT            NOT NULL,
    [Short_Status_Code]      VARCHAR (20)   NOT NULL,
    [Proc_Name]              VARCHAR (140)  NULL,
    [Process_Step_No]        INT            NOT NULL,
    [Process_Sub_Step_No]    INT            NOT NULL,
    [Loop_Counter]           NVARCHAR (MAX) NULL,
    [Process_Start]          DATETIME       NULL,
    [Process_Error_Code]     VARCHAR (240)  NULL,
    [Process_Error_MSG]      NVARCHAR (MAX) NULL,
    PRIMARY KEY CLUSTERED ([Import_Log_Detail_Code] ASC)
);

