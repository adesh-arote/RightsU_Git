CREATE TABLE [dbo].[HR_Department] (
    [HR_Department_Code] INT            IDENTITY (1, 1) NOT NULL,
    [HR_Department_Name] NVARCHAR (MAX) NULL,
    [Inserted_By]        INT            NULL,
    [Inserted_On]        DATETIME       NULL,
    [Last_Updated_By]    INT            NULL,
    [Last_Updated_On]    DATETIME       NULL,
    [Is_Active]          CHAR (1)       NULL
);

