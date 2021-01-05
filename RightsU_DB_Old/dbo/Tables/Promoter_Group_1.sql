CREATE TABLE [dbo].[Promoter_Group] (
    [Promoter_Group_Code] INT             IDENTITY (1, 1) NOT NULL,
    [Promoter_Group_Name] NVARCHAR (400)  NULL,
    [Parent_Group_Code]   INT             NULL,
    [Is_Last_Level]       CHAR (1)        NULL,
    [Hierarchy_Name]      NVARCHAR (1000) NULL,
    [Display_Order]       VARCHAR (5)     NULL,
    [Inserted_On]         DATETIME        NULL,
    [Inserted_By]         INT             NULL,
    [Last_Updated_Time]   DATETIME        NULL,
    [Last_Action_By]      INT             NULL,
    [Is_Active]           CHAR (1)        NULL,
    CONSTRAINT [PK__Promoter__DFD29A2D4359A8B7] PRIMARY KEY CLUSTERED ([Promoter_Group_Code] ASC)
);



