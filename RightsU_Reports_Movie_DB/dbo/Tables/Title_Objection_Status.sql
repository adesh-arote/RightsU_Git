CREATE TABLE [dbo].[Title_Objection_Status] (
    [Title_Objection_Status_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Objection_Status_Name]       NVARCHAR (MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Is_Active]                   CHAR (1)       COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    CONSTRAINT [PK_Title_Objection_Status] PRIMARY KEY CLUSTERED ([Title_Objection_Status_Code] ASC)
);

