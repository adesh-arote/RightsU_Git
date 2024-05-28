CREATE TABLE [dbo].[Promoter_Group] (
    [Promoter_Group_Code] INT             IDENTITY (1, 1) NOT NULL,
    [Promoter_Group_Name] NVARCHAR (400)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Parent_Group_Code]   INT             NULL,
    [Is_Last_Level]       CHAR (1)        COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Hierarchy_Name]      NVARCHAR (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Display_Order]       VARCHAR (5)     COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Inserted_On]         DATETIME        NULL,
    [Inserted_By]         INT             NULL,
    [Last_Updated_Time]   DATETIME        NULL,
    [Last_Action_By]      INT             NULL,
    [Is_Active]           CHAR (1)        COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    CONSTRAINT [PK_Promoter_Group] PRIMARY KEY CLUSTERED ([Promoter_Group_Code] ASC)
);

