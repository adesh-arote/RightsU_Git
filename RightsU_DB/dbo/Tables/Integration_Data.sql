CREATE TABLE [dbo].[Integration_Data] (
    [Integration_Data_Code]   NUMERIC (8)   IDENTITY (1, 1) NOT NULL,
    [Integration_Config_Code] NUMERIC (8)   NULL,
    [RU_Record_Code]          NUMERIC (8)   NULL,
    [Foreign_System_Code]     VARCHAR (100) NULL,
    [Creation_Date]           DATETIME      NULL,
    [Record_Status]           CHAR (1)      NULL,
    [Processing_Date]         DATETIME      NULL,
    CONSTRAINT [PK_Integration_Data] PRIMARY KEY CLUSTERED ([Integration_Data_Code] ASC),
    CONSTRAINT [FK_Integration_Data_Integration_Data] FOREIGN KEY ([Integration_Config_Code]) REFERENCES [dbo].[Integration_Config] ([Integration_Config_Code])
);

