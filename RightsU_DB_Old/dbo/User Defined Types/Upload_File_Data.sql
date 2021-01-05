CREATE TYPE [dbo].[Upload_File_Data] AS TABLE (
    [Row_Num]           INT            NULL,
    [Row_Delimed]       VARCHAR (MAX)  NULL,
    [Err_Cols]          VARCHAR (1000) NULL,
    [Upload_Type]       VARCHAR (1000) NULL,
    [Upload_Title_Type] VARCHAR (1000) NULL);

