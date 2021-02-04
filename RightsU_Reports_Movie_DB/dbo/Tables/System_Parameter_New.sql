CREATE TABLE [dbo].[System_Parameter_New] (
    [Id]                INT             IDENTITY (1, 1) NOT NULL,
    [Parameter_Name]    VARCHAR (1000)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Parameter_Value]   VARCHAR (1000)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Inserted_On]       DATETIME        NULL,
    [Inserted_By]       INT             NULL,
    [Lock_Time]         DATETIME        NULL,
    [Last_Updated_Time] DATETIME        NULL,
    [Last_Action_By]    INT             NULL,
    [Channel_Code]      INT             NULL,
    [Type]              CHAR (1)        COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [IsActive]          CHAR (1)        COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Description]       NVARCHAR (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [IS_System_Admin]   CHAR (1)        COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    CONSTRAINT [PK_System_Parameter_New] PRIMARY KEY CLUSTERED ([Id] ASC)
);

