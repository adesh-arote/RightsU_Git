CREATE TABLE [dbo].[Revenue_Heads] (
    [Rev_Hd_Code] INT           IDENTITY (1, 1) NOT NULL,
    [Rev_Hd_Name] VARCHAR (250) NULL,
    [Rev_Hd_Type] INT           NULL,
    CONSTRAINT [PK_RHead_Code_1] PRIMARY KEY CLUSTERED ([Rev_Hd_Code] ASC)
);

