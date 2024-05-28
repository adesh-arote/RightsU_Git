CREATE TABLE [dbo].[Security_Group] (
    [Security_Group_Code] INT           IDENTITY (1, 1) NOT NULL,
    [Security_Group_Name] NVARCHAR (50) NULL,
    [Inserted_On]         DATETIME      NOT NULL,
    [Inserted_By]         INT           NOT NULL,
    [Lock_Time]           DATETIME      NULL,
    [Last_Updated_Time]   DATETIME      NULL,
    [Last_Action_By]      INT           NULL,
    [Is_Active]           CHAR (1)      NOT NULL,
    CONSTRAINT [PK_Security_Group_Ad] PRIMARY KEY CLUSTERED ([Security_Group_Code] ASC)
);

