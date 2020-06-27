CREATE TABLE [dbo].[Monetisation_Type] (
    [Monetisation_Type_Code] INT           IDENTITY (1, 1) NOT NULL,
    [Monetisation_Type_Name] VARCHAR (100) NULL,
    [Is_Active]              CHAR (1)      NULL,
    CONSTRAINT [PK_Monetisation_Type] PRIMARY KEY CLUSTERED ([Monetisation_Type_Code] ASC)
);

