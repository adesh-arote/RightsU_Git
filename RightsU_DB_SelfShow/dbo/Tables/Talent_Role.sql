CREATE TABLE [dbo].[Talent_Role] (
    [Talent_Role_Code] INT IDENTITY (1, 1) NOT NULL,
    [Talent_Code]      INT NULL,
    [Role_Code]        INT NULL,
    CONSTRAINT [PK_Talent_Role] PRIMARY KEY CLUSTERED ([Talent_Role_Code] ASC)
);

