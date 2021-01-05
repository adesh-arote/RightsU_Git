CREATE TABLE [dbo].[Glossary] (
    [Glossary_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Name]          VARCHAR (2000) NULL,
    [Description]   VARCHAR (2000) NULL,
    [Example]       VARCHAR (2000) NULL,
    [Glossary_Type] CHAR (1)       NULL,
    CONSTRAINT [PK_Glossary] PRIMARY KEY CLUSTERED ([Glossary_Code] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'P- Platform, F-FAQ, R-Reports and Usage, C- Contact', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Glossary', @level2type = N'COLUMN', @level2name = N'Glossary_Type';

