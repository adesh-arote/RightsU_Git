CREATE TABLE [dbo].[BV_HouseId_Data] (
    [BV_HouseId_Data_Code]        INT            IDENTITY (1, 1) NOT NULL,
    [House_Ids]                   VARCHAR (5000) NULL,
    [BV_Title]                    VARCHAR (5000) NULL,
    [Episode_No]                  VARCHAR (500)  NULL,
    [House_Type]                  VARCHAR (500)  NULL,
    [Mapped_Deal_Title_Code]      INT            NULL,
    [Is_Mapped]                   CHAR (1)       CONSTRAINT [DF_BV_HouseId_Data_Is_Mapped] DEFAULT ('N') NULL,
    [Parent_BV_HouseId_Data_Code] INT            NULL,
    [upload_file_code]            BIGINT         NULL,
    [Program_Episode_ID]          VARCHAR (1000) NULL,
    [Program_Version_ID]          VARCHAR (1000) NULL,
    [Schedule_Item_Log_Date]      VARCHAR (50)   NULL,
    [Schedule_Item_Log_Time]      VARCHAR (50)   NULL,
    [IsProcessed]                 CHAR (1)       NULL,
    [IsIgnore]                    CHAR (1)       NULL,
    [LastUpdatedOn]               DATETIME       NULL,
    [Type]                        VARCHAR (2)    NULL,
    [InsertedOn]                  DATETIME       NULL,
    [Program_Category]            VARCHAR (250)  NULL,
	BMS_Schedule_Process_Data_Temp_Code INT NULL CONSTRAINT FK_BV_HouseId_Data_BMS_Schedule_Process_Data_Temp_TCode FOREIGN KEY REFERENCES BMS_Schedule_Process_Data_Temp(BMS_Schedule_Process_Data_Temp_Code),
    [Title_Content_Code] NCHAR(10) NULL, 
    [Title_Code] NCHAR(10) NULL, 
    CONSTRAINT [PK_BV_HouseId_Data] PRIMARY KEY CLUSTERED ([BV_HouseId_Data_Code] ASC),
	
);



