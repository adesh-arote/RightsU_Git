CREATE TABLE [dbo].[System_Message] (
    [System_Message_Code] INT           IDENTITY (1, 1) NOT NULL,
    [Message_Key]         VARCHAR (MAX) NULL,
    [Inserted_On]         DATETIME      NULL,
    [Inserted_By]         INT           NULL,
    [Last_Updated_Time]   DATETIME      NULL,
    [Last_Action_By]      INT           NULL,
    CONSTRAINT [PK_System_Message_Type] PRIMARY KEY CLUSTERED ([System_Message_Code] ASC)
);



