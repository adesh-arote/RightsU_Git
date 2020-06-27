﻿CREATE TABLE [dbo].[Title] (
    [Title_Code]             INT             IDENTITY (1, 1) NOT NULL,
    [Original_Title]         NVARCHAR (250)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Title_Name]             NVARCHAR (500)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Title_Code_Id]          VARCHAR (50)    COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Synopsis]               NVARCHAR (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Original_Language_Code] INT             NULL,
    [Title_Language_Code]    INT             NULL,
    [Year_Of_Production]     INT             NULL,
    [Duration_In_Min]        DECIMAL (18, 2) NULL,
    [Deal_Type_Code]         INT             NULL,
    [Grade_Code]             INT             NULL,
    [Reference_Key]          INT             NULL,
    [Reference_Flag]         CHAR (1)        COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Is_Active]              CHAR (1)        COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Inserted_By]            INT             NULL,
    [Inserted_On]            DATETIME        NULL,
    [Last_UpDated_Time]      DATETIME        NULL,
    [Last_Action_By]         INT             NULL,
    [Lock_Time]              DATETIME        NULL,
    [Title_Image]            VARCHAR (2000)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Music_Label_Code]       INT             NULL,
    [Program_Code]           INT             NULL,
    CONSTRAINT [PK_Title_1] PRIMARY KEY CLUSTERED ([Title_Code] ASC)
);



