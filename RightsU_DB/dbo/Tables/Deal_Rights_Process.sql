CREATE TABLE [dbo].[Deal_Rights_Process] (
    [Deal_Rights_Process_Code] INT             IDENTITY (1, 1) NOT NULL,
    [Deal_Code]                INT             NULL,
    [Module_Code]              INT             NULL,
    [Deal_Rights_Code]         INT             NULL,
    [Record_Status]            CHAR (1)        DEFAULT ('P') NULL,
    [Inserted_On]              DATETIME        NULL,
    [Process_Start]            DATETIME        NULL,
    [Porcess_End]              DATETIME        NULL,
    [User_Code]                INT             NULL,
    [Error_Messages]           NVARCHAR (MAX)  NULL,
    [Button_Visibility]        NVARCHAR (1000) NULL,
    [Rights_Bulk_Update_Code]  INT             NULL,
    [Title_Code]               INT             NULL,
    PRIMARY KEY CLUSTERED ([Deal_Rights_Process_Code] ASC)
);

