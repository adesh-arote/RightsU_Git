CREATE TABLE [dbo].[Integration_Config] (
    [Integration_Config_Code] NUMERIC (8)   IDENTITY (1, 1) NOT NULL,
    [Module_Code]             INT           NULL,
    [Module_Name]             VARCHAR (100) NULL,
    [Foreign_System_Name]     VARCHAR (100) NULL,
    [Is_Active]               CHAR (1)      NULL,
    CONSTRAINT [PK_Integration_Config] PRIMARY KEY CLUSTERED ([Integration_Config_Code] ASC)
);

