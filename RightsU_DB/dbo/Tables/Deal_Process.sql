CREATE TABLE [dbo].[Deal_Process] (
    [Deal_Process_Code]   INT             IDENTITY (1, 1) NOT NULL,
    [Deal_Code]           INT             NULL,
    [Module_Code]         INT             NULL,
    [EditWithoutApproval] CHAR (1)        NULL,
    [Action]              CHAR (1)        NULL,
    [Record_Status]       CHAR (1)        DEFAULT ('P') NULL,
    [Inserted_On]         DATETIME        NULL,
    [Process_Start]       DATETIME        NULL,
    [Porcess_End]         DATETIME        NULL,
    [User_Code]           INT             NULL,
    [Error_Messages]      NVARCHAR (MAX)  NULL,
    [Button_Visibility]   NVARCHAR (1000) NULL,
    [Version_No]          NVARCHAR (10)   NULL,
    PRIMARY KEY CLUSTERED ([Deal_Process_Code] ASC)
);

