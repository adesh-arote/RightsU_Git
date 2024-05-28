CREATE TABLE [dbo].[Sponsor] (
    [Sponsor_Code] INT           IDENTITY (1, 1) NOT NULL,
    [Sponsor_Name] VARCHAR (100) NULL,
    [Is_Active]    CHAR (1)      NULL,
    CONSTRAINT [PK_Sponsor] PRIMARY KEY CLUSTERED ([Sponsor_Code] ASC)
);

