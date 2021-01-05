CREATE TYPE [dbo].[Title_Import] AS TABLE (
    [Title_Name]            NVARCHAR (4000) NULL,
    [Title_Type]            VARCHAR (100)   NULL,
    [Title_Language]        NVARCHAR (200)  NULL,
    [Year_of_Release]       VARCHAR (100)   NULL,
    [Duration]              VARCHAR (100)   NULL,
    [Key_Star_Cast]         NVARCHAR (2000) NULL,
    [Director]              NVARCHAR (2000) NULL,
    [Synopsis]              NVARCHAR (4000) NULL,
    [Music_Label]           NVARCHAR (4000) NULL,
    [DM_Master_Import_Code] VARCHAR (100)   NULL,
    [Excel_Line_No]         VARCHAR (50)    NULL,
	[Program_Category] NVARCHAR(4000));





