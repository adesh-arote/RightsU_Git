CREATE TABLE [dbo].[Business_Unit] (
    [Business_Unit_Code] INT           IDENTITY (1, 1) NOT NULL,
    [Business_Unit_Name] VARCHAR (150) NULL,
    [Is_Active]          CHAR (1)      DEFAULT ('Y') NULL,
    CONSTRAINT [PK_Business_Unit] PRIMARY KEY CLUSTERED ([Business_Unit_Code] ASC)
);

