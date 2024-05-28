CREATE TABLE [dbo].[Acq_Deal_Tab_Version] (
    [Acq_Deal_Tab_Version_Code] INT             IDENTITY (1, 1) NOT NULL,
    [Version]                   FLOAT (53)      NULL,
    [Remarks]                   NVARCHAR (4000) NULL,
    [Acq_Deal_Code]             INT             NULL,
    [Inserted_On]               DATETIME        NULL,
    [Inserted_By]               INT             NULL,
    [Approved_On]               DATETIME        NULL,
    [Approved_By]               INT             NULL,
    CONSTRAINT [PK_Acq_Deal_Tab_Version] PRIMARY KEY CLUSTERED ([Acq_Deal_Tab_Version_Code] ASC)
);

