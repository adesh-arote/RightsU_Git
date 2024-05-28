CREATE TYPE [dbo].[BMS_Schedule_Mapped_Title_UDT] AS TABLE (
    [BV_HouseId_Data_Code]                INT            NULL,
    [BV_Title]                            NVARCHAR (MAX) NULL,
    [Episode_No]                          INT            NULL,
    [Mapped_Deal_Title_Code]              INT            NULL,
    [Is_Mapped]                           CHAR (1)       NULL,
    [Program_Episode_ID]                  INT            NULL,
    [IsProcessed]                         CHAR (1)       NULL,
    [IsIgnore]                            CHAR (1)       NULL,
    [Program_Category]                    NVARCHAR (MAX) NULL,
    [BMS_Schedule_Process_Data_Temp_Code] INT            NULL);

