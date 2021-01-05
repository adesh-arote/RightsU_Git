CREATE TYPE [dbo].[Title_Content_UDT] AS TABLE (
    [Title_Content_Code] INT NULL,
    [Episode_Title] NVARCHAR (MAX)  NULL,
    [Duration]  DECIMAL(18,2) NULL
)