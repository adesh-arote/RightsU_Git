CREATE TABLE [dbo].[Party_Group] (
    [Party_Group_Code] INT             IDENTITY (1, 1) NOT NULL,
    [Party_Group_Name] NVARCHAR (4000) NULL,
    [InsertedOn]       DATETIME        NULL,
    [Last_Updated_By]  DATETIME        NULL,
    [Is_Active]        CHAR (1)        NULL,
    PRIMARY KEY CLUSTERED ([Party_Group_Code] ASC)
);

