CREATE TABLE [dbo].[Title_Objection_Type] (
    [Objection_Type_Code]        INT           IDENTITY (1, 1) NOT NULL,
    [Objection_Type_Name]        VARCHAR (MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Is_Active]                  CHAR (1)      COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Inserted_On]                DATETIME      NULL,
    [Inserted_By]                INT           NULL,
    [Last_Updated_Time]          DATETIME      NULL,
    [Last_Action_By]             INT           NULL,
    [Parent_Objection_Type_Code] INT           NULL,
    CONSTRAINT [PK_Title_Objection_Type] PRIMARY KEY CLUSTERED ([Objection_Type_Code] ASC)
);

