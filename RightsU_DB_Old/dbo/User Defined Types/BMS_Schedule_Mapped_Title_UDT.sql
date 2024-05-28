CREATE TYPE [dbo].[BMS_Schedule_Mapped_Title_UDT] AS TABLE
(
	BV_HouseId_Data_Code INT,
	BV_Title NVARCHAR(MAX),
	Episode_No INT,
	Mapped_Deal_Title_Code INT,
	Is_Mapped CHAR(1),
	Program_Episode_ID INT,
	IsProcessed CHAR(1),
	IsIgnore CHAR(1),
	Program_Category NVARCHAR(MAX),
	BMS_Schedule_Process_Data_Temp_Code INT
)

