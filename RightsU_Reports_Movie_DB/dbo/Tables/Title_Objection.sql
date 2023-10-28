CREATE TABLE [dbo].[Title_Objection] (
    [Title_Objection_Code]        INT            IDENTITY (1, 1) NOT NULL,
    [Title_Objection_Status_Code] INT            NULL,
    [Title_Objection_Type_Code]   INT            NULL,
    [Title_Code]                  INT            NULL,
    [Record_Code]                 INT            NULL,
    [Record_Type]                 CHAR (1)       COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Objection_Start_Date]        DATETIME       NULL,
    [Objection_End_Date]          DATETIME       NULL,
    [Objection_Remarks]           NVARCHAR (MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Resolution_Remarks]          NVARCHAR (MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Inserted_On]                 DATETIME       NULL,
    [Inserted_By]                 INT            NULL,
    [Last_Updated_Time]           DATETIME       NULL,
    [Last_Action_By]              INT            NULL,
    CONSTRAINT [PK_Title_Objection] PRIMARY KEY CLUSTERED ([Title_Objection_Code] ASC)
);

