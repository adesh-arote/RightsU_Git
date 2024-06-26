﻿CREATE TABLE [dbo].[BMS_Payee] (
    [BMS_Payee_Id]      INT           IDENTITY (1, 1) NOT NULL,
    [BMS_Key]           INT           NULL,
    [Name]              VARCHAR (80)  NULL,
    [AddressLine1]      VARCHAR (80)  NULL,
    [AddressLine2]      VARCHAR (80)  NULL,
    [AddressLine3]      VARCHAR (80)  NULL,
    [City]              VARCHAR (40)  NULL,
    [Province]          VARCHAR (40)  NULL,
    [Country]           VARCHAR (40)  NULL,
    [PostalCode]        VARCHAR (10)  NULL,
    [Phone]             VARCHAR (20)  NULL,
    [Fax]               VARCHAR (20)  NULL,
    [Email]             VARCHAR (252) NULL,
    [ExternalId]        VARCHAR (20)  NULL,
    [UpdateDateTime]    VARCHAR (30)  NULL,
    [UpdateUserId]      VARCHAR (20)  NULL,
    [IsArchived]        CHAR (1)      NULL,
    [ForeignId]         VARCHAR (40)  NULL,
    [Inserted_By]       INT           NULL,
    [Inserted_On]       DATETIME      NULL,
    [Last_Updated_Time] DATETIME      NULL,
    [Last_Action_By]    INT           NULL
);

