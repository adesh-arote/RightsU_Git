﻿CREATE TABLE [dbo].[Language_Group] (
    [Language_Group_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Language_Group_Name] NVARCHAR (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Inserted_On]         DATETIME       NULL,
    [Inserted_By]         INT            NULL,
    [Lock_Time]           DATETIME       NULL,
    [Last_Updated_Time]   DATETIME       NULL,
    [Last_Action_By]      INT            NULL,
    [Is_Active]           CHAR (1)       COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    CONSTRAINT [PK_Language_Group] PRIMARY KEY CLUSTERED ([Language_Group_Code] ASC)
);
