CREATE TABLE [dbo].[Music_Platform] (
    [Music_Platform_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Platform_Name]       NVARCHAR (MAX) NULL,
    [Parent_Code]         INT            NULL,
    [Is_Last_Level]       CHAR (1)       NULL,
    [Module_Position]     VARCHAR (10)   NULL,
    [Platform_Hierarchy]  NVARCHAR (MAX) NULL,
    [Inserted_On]         DATETIME       NULL,
    [Inserted_By]         INT            NULL,
    [Last_Updated_Time]   DATETIME       NULL,
    [Last_Action_By]      INT            NULL,
    [Is_Active]           CHAR (1)       NULL,
    PRIMARY KEY CLUSTERED ([Music_Platform_Code] ASC)
);

