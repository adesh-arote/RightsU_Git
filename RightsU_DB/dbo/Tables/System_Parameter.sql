CREATE TABLE [dbo].[System_Parameter] (
    [Id]                INT             NOT NULL,
    [Parameter_Name]    VARCHAR (1000)  NULL,
    [Parameter_Value]   VARCHAR (1000)  NULL,
    [Inserted_On]       DATETIME        NULL,
    [Inserted_By]       INT             NULL,
    [Lock_Time]         DATETIME        NULL,
    [Last_Updated_Time] DATETIME        NULL,
    [Last_Action_By]    INT             NULL,
    [Channel_Code]      INT             NULL,
    [Type]              CHAR (1)        NULL,
    [IsActive]          CHAR (1)        NULL,
    [Description]       NVARCHAR (4000) NULL,
    [IS_System_Admin]   CHAR (1)        NULL,
    [Client_Name]       NVARCHAR (MAX)  NULL,
    CONSTRAINT [PK_System_Parameter] PRIMARY KEY CLUSTERED ([Id] ASC)
);



