CREATE TABLE [dbo].[Platform_Group] (
    [Platform_Group_Code] INT           IDENTITY (1, 1) NOT NULL,
    [Platform_Group_Name] VARCHAR (500) NULL,
    [Inserted_On]         DATETIME      NULL,
    [Inserted_By]         INT           NULL,
    [Lock_Time]           DATETIME      NULL,
    [Last_Updated_Time]   DATETIME      NULL,
    [Last_Action_By]      INT           NULL,
    [Is_Active]           CHAR (1)      NULL,
    [Group_For]           CHAR (1)      NULL,
    CONSTRAINT [PK_Platform_Group_Demo] PRIMARY KEY CLUSTERED ([Platform_Group_Code] ASC)
);



