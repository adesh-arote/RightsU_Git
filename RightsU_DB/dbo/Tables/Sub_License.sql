CREATE TABLE [dbo].[Sub_License] (
    [Sub_License_Code] INT           IDENTITY (1, 1) NOT NULL,
    [Sub_License_Name] VARCHAR (100) NULL,
    [Is_Active]        CHAR (1)      CONSTRAINT [DF_Sub_License_Is_Active] DEFAULT ('Y') NULL,
    CONSTRAINT [PK_Sub_License] PRIMARY KEY CLUSTERED ([Sub_License_Code] ASC)
);

