﻿CREATE TABLE [dbo].[AT_Acq_Deal_Sport] (
    [AT_Acq_Deal_Sport_Code]  INT             IDENTITY (1, 1) NOT NULL,
    [AT_Acq_Deal_Code]        INT             NULL,
    [Content_Delivery]        VARCHAR (2)     NULL,
    [Obligation_Broadcast]    VARCHAR (2)     NULL,
    [Deferred_Live]           VARCHAR (2)     NULL,
    [Deferred_Live_Duration]  VARCHAR (100)   NULL,
    [Tape_Delayed]            VARCHAR (2)     NULL,
    [Tape_Delayed_Duration]   VARCHAR (100)   NULL,
    [Standalone_Transmission] VARCHAR (2)     NULL,
    [Standalone_Substantial]  VARCHAR (2)     NULL,
    [Simulcast_Transmission]  VARCHAR (2)     NULL,
    [Simulcast_Substantial]   VARCHAR (2)     NULL,
    [File_Name]               VARCHAR (1000)  NULL,
    [Sys_File_Name]           VARCHAR (1000)  NULL,
    [Remarks]                 NVARCHAR (4000) NULL,
    [Inserted_By]             INT             NULL,
    [Inserted_On]             DATETIME        NULL,
    [Last_Updated_Time]       DATETIME        NULL,
    [Last_Action_By]          INT             NULL,
    [MBO_Note]                NVARCHAR (4000) NULL,
    [Acq_Deal_Sport_Code]     INT             NULL,
    CONSTRAINT [PK_AT_Acq_Deal_Sport] PRIMARY KEY CLUSTERED ([AT_Acq_Deal_Sport_Code] ASC),
    CONSTRAINT [FK_AT_Acq_Deal_Sport_Acq_Deal] FOREIGN KEY ([AT_Acq_Deal_Code]) REFERENCES [dbo].[AT_Acq_Deal] ([AT_Acq_Deal_Code])
);


