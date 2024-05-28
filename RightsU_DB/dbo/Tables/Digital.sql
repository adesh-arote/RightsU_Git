CREATE TABLE [dbo].[Digital] (
    [Digital_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Digital_Name] NVARCHAR (200) NULL,
    [Is_Active]    CHAR (1)       NULL,
    CONSTRAINT [PK_Digital] PRIMARY KEY CLUSTERED ([Digital_Code] ASC)
);

