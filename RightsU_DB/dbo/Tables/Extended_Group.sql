CREATE TABLE [dbo].[Extended_Group] (
    [Extended_Group_Code] INT           NOT NULL,
    [Group_Name]          VARCHAR (100) NULL,
    [Short_Name]          VARCHAR (100) NULL,
    [Group_Order]         INT           NULL,
    [Add_Edit_Type]       VARCHAR (10)  NULL,
    [Module_Code]         INT           NULL,
    [Inserted_By]         INT           NULL,
    [Inserted_On]         DATETIME      NULL,
    [Last_Updated_Time]   DATETIME      NULL,
    [Last_Action_By]      INT           NULL,
    [Lock_Time]           DATETIME      NULL,
    [IsActive]            CHAR (1)      NULL,
    CONSTRAINT [PK_Extended_Group] PRIMARY KEY CLUSTERED ([Extended_Group_Code] ASC)
);

