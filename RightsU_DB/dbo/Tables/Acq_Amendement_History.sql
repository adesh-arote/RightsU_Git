CREATE TABLE [dbo].[Acq_Amendement_History] (
    [Acq_Amendement_History_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Record_Code]                 INT            NULL,
    [Module_Code]                 INT            NULL,
    [Version]                     INT            NULL,
    [Amendment_Date]              DATETIME       NULL,
    [Amended_By]                  NVARCHAR (MAX) NULL,
    [Remarks]                     NVARCHAR (MAX) NULL,
    PRIMARY KEY CLUSTERED ([Acq_Amendement_History_Code] ASC)
);

