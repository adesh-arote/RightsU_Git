﻿CREATE TABLE [dbo].[DM_IPR] (
    [ID]                     INT             IDENTITY (1, 1) NOT NULL,
    [APPLICANT]              NVARCHAR (1000) NULL,
    [TRADEMARK]              NVARCHAR (1000) NULL,
    [CLASSES]                NVARCHAR (1000) NULL,
    [TYPE]                   NVARCHAR (1000) NULL,
    [APPLICATION DATE]       NVARCHAR (1000) NULL,
    [APPLICATION NO#]        NVARCHAR (1000) NULL,
    [DATE OF USE]            NVARCHAR (1000) NULL,
    [APPLICATION STATUS]     NVARCHAR (1000) NULL,
    [REGISTRATION NO#]       NVARCHAR (1000) NULL,
    [DATE OF REGISTRATION ]  NVARCHAR (1000) NULL,
    [RENEWED UNTILL]         NVARCHAR (1000) NULL,
    [COUNTRY]                NVARCHAR (1000) NULL,
    [TRADE MARK ATTORNEY]    NVARCHAR (1000) NULL,
    [INTERNATIONAL ATTORNEY] NVARCHAR (1000) NULL
);

