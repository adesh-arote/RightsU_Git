CREATE TABLE [dbo].[Talent] (
    [Talent_Code]       INT            IDENTITY (1, 1) NOT NULL,
    [Talent_Name]       NVARCHAR (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [Gender]            NCHAR (1)      COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Inserted_On]       DATETIME       NULL,
    [Inserted_By]       INT            NULL,
    [Lock_Time]         DATETIME       NULL,
    [Last_Updated_Time] DATETIME       NULL,
    [Last_Action_By]    INT            NULL,
    [Is_Active]         CHAR (1)       COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    CONSTRAINT [PK_Talent] PRIMARY KEY CLUSTERED ([Talent_Code] ASC)
);

