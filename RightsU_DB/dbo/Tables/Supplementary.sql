CREATE TABLE [dbo].[Supplementary] (
    [Supplementary_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Supplementary_Name] NVARCHAR (200) NULL,
    [Is_Active]          CHAR (1)       NULL,
    CONSTRAINT [PK_Supplementary] PRIMARY KEY CLUSTERED ([Supplementary_Code] ASC)
);

