CREATE TABLE [dbo].[Map_Extended_Columns_Details] (
    [Map_Extended_Columns_Details_Code] INT IDENTITY (1, 1) NOT NULL,
    [Map_Extended_Columns_Code]         INT NULL,
    [Columns_Value_Code]                INT NULL,
    CONSTRAINT [PK_Map_Extended_Columns_Details] PRIMARY KEY CLUSTERED ([Map_Extended_Columns_Details_Code] ASC),
    CONSTRAINT [FK_Map_Extended_Columns_Details_Map_Extended_Columns] FOREIGN KEY ([Map_Extended_Columns_Code]) REFERENCES [dbo].[Map_Extended_Columns] ([Map_Extended_Columns_Code])
);

