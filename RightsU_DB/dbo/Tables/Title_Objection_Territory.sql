CREATE TABLE [dbo].[Title_Objection_Territory] (
    [Title_Objection_Territory_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Title_Objection_Code]           INT      NULL,
    [Territory_Type]                 CHAR (1) NULL,
    [Country_Code]                   INT      NULL,
    [Territory_Code]                 INT      NULL,
    PRIMARY KEY CLUSTERED ([Title_Objection_Territory_Code] ASC),
    CONSTRAINT [FK_Title_Objection_Territory_Title_Objection] FOREIGN KEY ([Title_Objection_Code]) REFERENCES [dbo].[Title_Objection] ([Title_Objection_Code])
);


