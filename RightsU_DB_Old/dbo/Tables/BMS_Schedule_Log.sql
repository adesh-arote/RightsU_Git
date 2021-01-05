CREATE TABLE BMS_Schedule_Log
	(
		BMS_Schedule_Log_Code INT IDENTITY(1, 1) PRIMARY KEY,
		Channel_Code INT,
		Data_Since DATETIME,
		Method_Type VARCHAR(5),
		Request_Time DATETIME,
		Response_Time DATETIME,
		Request_Xml VARCHAR(MAX),
		Response_Xml VARCHAR(MAX),
		Record_Status CHAR(1),
		Error_Description VARCHAR(MAX),
		[Start_Date] DATETIME,
		[End_Date] DATETIME,
		Response_Message VARCHAR(MAX),
		CONSTRAINT FK_BMS_Schedule_Log_Channel FOREIGN KEY (Channel_Code)     
		REFERENCES dbo.Channel(Channel_Code) 
	)