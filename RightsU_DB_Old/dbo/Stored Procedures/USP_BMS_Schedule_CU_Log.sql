CREATE PROCEDURE [dbo].[USP_BMS_Schedule_CU_Log]
(
	@BMS_Schedule_Log_Code INT = NULL,
	@Channel_Code INT = NULL,
	@Data_Since VARCHAR(50) = NULL,
	@Method_Type VARCHAR(5) = NULL,
	@Request_Xml VARCHAR(MAX) =  NULL,
	@Response_Xml VARCHAR(MAX) =  NULL,
	@Record_Status CHAR(1) =  NULL,
	@Error_Desc VARCHAR(MAX) = NULL,
	@Response_Message VARCHAR(MAX) = NULL
)
AS
--    ==========================
--    Author		:   Abhaysingh N. Rajpurohit   
--    Created On    :   05 July 2016
--    Description   :   Create or Update Log, If exist update else create
--    Notes			:   This procedure will return @BMS_Schedule_Log_Code
--    ==========================
BEGIN

	IF(LTRIM(RTRIM(@Data_Since)) = '')
		SET @Data_Since = NULL
	
	IF(ISNULL(@BMS_Schedule_Log_Code, 0) > 0)
	BEGIN
		PRINT 'UPDATE Response Log'
		UPDATE BMS_Schedule_Log SET 
		Response_Time = GETDATE(),
		Response_Xml = ISNULL(@Response_Xml, Response_Xml),
		Record_Status = ISNULL(@Record_Status, 'P'),
		Error_Description = @Error_Desc,
		Response_Message = @Response_Message
		WHERE BMS_Schedule_Log_Code = @BMS_Schedule_Log_Code
	END
	ELSE
	BEGIN
		PRINT 'Insert Request Log'
		INSERT INTO BMS_Schedule_Log(Channel_Code, Data_Since, Method_Type, Request_Time, Request_Xml, Record_Status)
		VALUES(@Channel_Code, @Data_Since, @Method_Type, GETDATE(), @Request_Xml, ISNULL(@Record_Status, 'W'))

		SELECT @BMS_Schedule_Log_Code = IDENT_CURRENT('BMS_Schedule_Log')
	END
	
	SELECT @BMS_Schedule_Log_Code AS BMS_Schedule_Log_Code
END