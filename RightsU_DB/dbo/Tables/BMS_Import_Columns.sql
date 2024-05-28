CREATE TABLE [dbo].[BMS_Import_Columns] (
    [BMS_Import_Column_Code] INT           IDENTITY (1, 1) NOT NULL,
    [BMS_Import_Column_Name] VARCHAR (100) NULL,
    [Is_Active]              CHAR (1)      NULL,
    CONSTRAINT [PK_BMS_Import_Columns] PRIMARY KEY CLUSTERED ([BMS_Import_Column_Code] ASC)
);

