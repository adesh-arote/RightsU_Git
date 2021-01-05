CREATE TABLE [dbo].[BMS_Temp_Data_All_Masters] (
    [BMS_Temp_Data_Masters_Id] INT            IDENTITY (1, 1) NOT NULL,
    [Batch_Id]                 INT            NULL,
    [Module_Name]              VARCHAR (100)  NULL,
    [BMS_XML_Data]             NVARCHAR (MAX) NULL,
    [Inserted_On]              DATETIME       NULL,
    CONSTRAINT [PK_BMS_Temp_Data_All_Masters] PRIMARY KEY CLUSTERED ([BMS_Temp_Data_Masters_Id] ASC)
);

