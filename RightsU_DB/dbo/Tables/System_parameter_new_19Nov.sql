﻿CREATE TABLE [dbo].[System_parameter_new_19Nov] (
    [Id]                INT            IDENTITY (1, 1) NOT NULL,
    [Parameter_Name]    VARCHAR (1000) NULL,
    [Parameter_Value]   VARCHAR (1000) NULL,
    [Inserted_On]       DATETIME       NULL,
    [Inserted_By]       INT            NULL,
    [Lock_Time]         DATETIME       NULL,
    [Last_Updated_Time] DATETIME       NULL,
    [Last_Action_By]    INT            NULL,
    [Channel_Code]      INT            NULL,
    [Type]              CHAR (1)       NULL,
    [IsActive]          CHAR (1)       NULL
);

