CREATE TABLE [dbo].[DM_Master_Import] (
    [DM_Master_Import_Code] INT            IDENTITY (1, 1) NOT NULL,
    [File_Name]             NVARCHAR (200) NULL,
    [System_File_Name]      NVARCHAR (500) NULL,
    [Upoaded_By]            INT            NULL,
    [Uploaded_Date]         DATETIME       NULL,
    [Action_By]             INT            NULL,
    [Action_On]             DATETIME       NULL,
    [Status]                VARCHAR (2)    NULL,
    [File_Type]             VARCHAR (2)    NULL,
    [Mapped_By]             CHAR (1)       NULL,
    [Import_Type]           CHAR (1)       NULL,
    [Record_Code]           INT            NULL,
    [Remarks]               NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_DM_Master_Import] PRIMARY KEY CLUSTERED ([DM_Master_Import_Code] ASC)
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'M- Music, T- Title', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DM_Master_Import', @level2type = N'COLUMN', @level2name = N'File_Type';

