CREATE TYPE [dbo].[DM_Import] AS TABLE (
    [File_Name]        NVARCHAR (1000) NULL,
    [System_File_Name] NVARCHAR (1000) NULL,
    [Uploaded_By]      NVARCHAR (100)  NULL,
    [updated_On]       NVARCHAR (1000) NULL,
    [Action_By]        NVARCHAR (1000) NULL,
    [Action_On]        NVARCHAR (1000) NULL,
    [Status]           NVARCHAR (2000) NULL,
    [File_Type]        NVARCHAR (500)  NULL);

