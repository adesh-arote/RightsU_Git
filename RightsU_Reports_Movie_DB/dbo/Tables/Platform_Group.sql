CREATE TABLE [dbo].[Platform_Group] (
    [Platform_Group_Code] INT           IDENTITY (1, 1) NOT NULL,
    [Platform_Group_Name] VARCHAR (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Inserted_On]         DATETIME      NULL,
    [Inserted_By]         INT           NULL,
    [Lock_Time]           DATETIME      NULL,
    [Last_Updated_Time]   DATETIME      NULL,
    [Last_Action_By]      INT           NULL,
    [Is_Active]           CHAR (1)      COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Group_For]           CHAR (1)      COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    CONSTRAINT [PK_Platform_Group_Demo] PRIMARY KEY CLUSTERED ([Platform_Group_Code] ASC)
);

