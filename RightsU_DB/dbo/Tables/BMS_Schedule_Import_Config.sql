CREATE TABLE [dbo].[BMS_Schedule_Import_Config] (
    [BMS_Import_Config_Code] INT           IDENTITY (1, 1) NOT NULL,
    [BMS_Import_Column_Code] INT           NULL,
    [Input_Column_Name]      VARCHAR (100) NULL,
    [File_Format]            VARCHAR (10)  NULL,
    [Column_Type]            INT           NULL,
    [Validations]            VARCHAR (100) NULL,
    [Column_Order]           INT           NULL,
    CONSTRAINT [PK_BMS_Schedule_Import_Config] PRIMARY KEY CLUSTERED ([BMS_Import_Config_Code] ASC),
    CONSTRAINT [FK_BMS_Schedule_Import_Config_BMS_Import_Columns] FOREIGN KEY ([BMS_Import_Column_Code]) REFERENCES [dbo].[BMS_Import_Columns] ([BMS_Import_Column_Code])
);

