CREATE TABLE [dbo].[Platform_Group] (
    [Platform_Group_Code] INT           IDENTITY (1, 1) NOT NULL,
    [Platform_Group_Name] VARCHAR (500) NULL,
    [Inserted_On]         DATETIME      NULL,
    [Inserted_By]         INT           NULL,
    [Lock_Time]           DATETIME      NULL,
    [Last_Updated_Time]   DATETIME      NULL,
    [Last_Action_By]      INT           NULL,
    [Is_Active]           CHAR (1)      CONSTRAINT [DF_Platform_Group_Is_Active] DEFAULT ('Y') NULL,
    [Group_For]           CHAR (1)      CONSTRAINT [DF_Platform_Group_Group_For] DEFAULT ('D') NULL,
    CONSTRAINT [PK_Platform_Group] PRIMARY KEY CLUSTERED ([Platform_Group_Code] ASC)
);



