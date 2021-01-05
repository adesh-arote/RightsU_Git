CREATE TABLE [dbo].[IPR_REP_STATUS_HISTORY] (
    [IPR_Rep_Status_History_Code] INT             IDENTITY (1, 1) NOT NULL,
    [IPR_Rep_Code]                INT             NULL,
    [IPR_Status]                  VARCHAR (50)    NULL,
    [Changed_On]                  DATETIME        NULL,
    [Changed_By]                  INT             NULL,
    [Remarks]                     NVARCHAR (1000) NULL,
    CONSTRAINT [PK_IPR_STATUS_HISTORY] PRIMARY KEY CLUSTERED ([IPR_Rep_Status_History_Code] ASC),
    CONSTRAINT [FK_IPR_STATUS_HISTORY_IPR_REP] FOREIGN KEY ([IPR_Rep_Code]) REFERENCES [dbo].[IPR_REP] ([IPR_Rep_Code])
);



