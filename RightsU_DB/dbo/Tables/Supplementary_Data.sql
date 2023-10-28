CREATE TABLE [dbo].[Supplementary_Data] (
    [Supplementary_Data_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Supplementary_Type]      VARCHAR (10)   NULL,
    [Data_Description]        NVARCHAR (100) NULL,
    [Is_Active]               CHAR (1)       NULL,
    CONSTRAINT [PK_Supplementary_Data] PRIMARY KEY CLUSTERED ([Supplementary_Data_Code] ASC)
);

