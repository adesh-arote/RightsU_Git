CREATE TABLE [dbo].[Title_Objection_Territory] (
    [Title_Objection_Territory_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Title_Objection_Code]           INT      NULL,
    [Territory_Type]                 CHAR (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Country_Code]                   INT      NULL,
    [Territory_Code]                 INT      NULL,
    CONSTRAINT [PK_Title_Objection_Territory] PRIMARY KEY CLUSTERED ([Title_Objection_Territory_Code] ASC)
);

