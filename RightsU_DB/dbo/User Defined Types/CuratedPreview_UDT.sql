CREATE TYPE [dbo].[CuratedPreview_UDT] AS TABLE (
    [Key]       NVARCHAR (MAX) NULL,
    [Value]     NVARCHAR (MAX) NULL,
    [Condition] NVARCHAR (MAX) NULL,
    [Operator]  NVARCHAR (MAX) NULL,
    [IsDisplay] NVARCHAR (MAX) NULL,
    [Order]     NVARCHAR (MAX) NULL,
    [Group]     NVARCHAR (MAX) NULL);

