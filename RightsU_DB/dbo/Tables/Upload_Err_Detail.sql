CREATE TABLE [dbo].[Upload_Err_Detail] (
    [Upload_Detail_Code] BIGINT        IDENTITY (1, 1) NOT NULL,
    [File_Code]          BIGINT        NOT NULL,
    [Row_Num]            INT           NULL,
    [Row_Delimed]        VARCHAR (MAX) NULL,
    [Err_Cols]           VARCHAR (MAX) NULL,
    [Upload_Type]        CHAR (10)     NULL,
    [Upload_Title_Type]  VARCHAR (5)   NULL
);

