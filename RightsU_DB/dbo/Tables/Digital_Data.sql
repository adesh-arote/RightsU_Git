CREATE TABLE [dbo].[Digital_Data] (
    [Digital_Data_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Digital_Type]      VARCHAR (10)   NULL,
    [Data_Description]  NVARCHAR (100) NULL,
    [Is_Active]         CHAR (1)       NULL,
    CONSTRAINT [PK_Digital_Data] PRIMARY KEY CLUSTERED ([Digital_Data_Code] ASC)
);

