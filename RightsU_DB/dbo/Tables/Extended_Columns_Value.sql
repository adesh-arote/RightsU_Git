CREATE TABLE [dbo].[Extended_Columns_Value] (
    [Columns_Value_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Columns_Code]       INT            NULL,
    [Columns_Value]      VARCHAR (100)  NULL,
    [Ref_BMS_Code]       VARCHAR (1000) NULL,
    CONSTRAINT [PK_Extended_Columns_Value] PRIMARY KEY CLUSTERED ([Columns_Value_Code] ASC),
    CONSTRAINT [FK_Extended_Columns_Value_Extended_Columns] FOREIGN KEY ([Columns_Code]) REFERENCES [dbo].[Extended_Columns] ([Columns_Code])
);

