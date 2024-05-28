CREATE TABLE [dbo].[Module_Status_History] (
    [Module_Status_Code] INT             IDENTITY (1, 1) NOT NULL,
    [Module_Code]        INT             NULL,
    [Record_Code]        INT             NULL,
    [Status]             VARCHAR (100)   NULL,
    [Status_Changed_By]  INT             NULL,
    [Status_Changed_On]  DATETIME        NULL,
    [Remarks]            NVARCHAR (4000) NULL,
    [Version_No]         INT             NULL,
    CONSTRAINT [PK_Module_Status_History] PRIMARY KEY CLUSTERED ([Module_Status_Code] ASC),
    CONSTRAINT [FK_Module_Status_History_System_Module] FOREIGN KEY ([Module_Code]) REFERENCES [dbo].[System_Module] ([Module_Code])
);

