CREATE TABLE [dbo].[Map_Extended_Columns] (
    [Map_Extended_Columns_Code] INT             IDENTITY (1, 1) NOT NULL,
    [Record_Code]               INT             NULL,
    [Table_Name]                VARCHAR (100)   NULL,
    [Columns_Code]              INT             NULL,
    [Columns_Value_Code]        INT             NULL,
    [Column_Value]              NVARCHAR (1000) NULL,
    [Is_Multiple_Select]        CHAR (1)        NULL,
    CONSTRAINT [PK_Map_Extended_Columns] PRIMARY KEY CLUSTERED ([Map_Extended_Columns_Code] ASC),
    CONSTRAINT [FK_Map_Extended_Columns_Extended_Columns] FOREIGN KEY ([Columns_Code]) REFERENCES [dbo].[Extended_Columns] ([Columns_Code]),
    CONSTRAINT [FK_Map_Extended_Columns_Extended_Columns_Value] FOREIGN KEY ([Columns_Value_Code]) REFERENCES [dbo].[Extended_Columns_Value] ([Columns_Value_Code])
);



