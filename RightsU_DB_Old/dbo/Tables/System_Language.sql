CREATE TABLE [dbo].[System_Language] (
    [System_Language_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Language_Name]        NVARCHAR (400) NULL,
    [Layout_Direction]     VARCHAR (10)   NULL,
    [Is_Default]           CHAR (1)       NULL,
    [Is_Active]            CHAR (1)       NULL,
    [Inserted_On]          DATETIME       NULL,
    [Inserted_By]          INT            NULL,
    [Last_Updated_Time]    DATETIME       NULL,
    [Last_Action_By]       INT            NULL,
    CONSTRAINT [PK_System_Language] PRIMARY KEY CLUSTERED ([System_Language_Code] ASC)
);



