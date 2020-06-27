﻿CREATE TABLE [dbo].[ROFR] (
    [ROFR_Code] INT           IDENTITY (1, 1) NOT NULL,
    [ROFR_Type] VARCHAR (500) NULL,
    [Is_Active] VARCHAR (1)   NULL,
    CONSTRAINT [PK_ROFR] PRIMARY KEY CLUSTERED ([ROFR_Code] ASC)
);

