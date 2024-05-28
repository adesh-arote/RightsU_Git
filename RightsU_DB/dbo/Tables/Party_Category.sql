CREATE TABLE [dbo].[Party_Category] (
    [Party_Category_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Party_Category_Name] NVARCHAR (100) NULL,
    [Inserted_On]         DATETIME       NULL,
    [Inserted_By]         INT            NULL,
    [Last_Updated_On]     DATETIME       NULL,
    [Last_Updated_By]     INT            NULL,
    [Is_Active]           CHAR (1)       NULL,
    PRIMARY KEY CLUSTERED ([Party_Category_Code] ASC)
);

