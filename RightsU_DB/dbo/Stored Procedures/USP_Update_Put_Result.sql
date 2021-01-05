CREATE PROC [dbo].[USP_Update_Put_Result]
(
	@strXml VARCHAR(MAX),
	@BV_WBS_Code INT
)
AS
----	==========================
----	Author		:	Abhaysingh N. Rajpurohit	
----	Created On	:	29 September 2015
----	Description	:	Convert XML into table format, and update Response_Type, Error_Details, Response_Status, Is_Process in BV_WBS, and make entry in 
----	==========================
BEGIN
--	DECLARE @strXml VARCHAR(MAX),
--	@BV_WBS_Code INT

--	SET @strXml = '<?xml version="1.0" encoding="UTF-8" standalone="no"?>
--<Budgetcode>
--    <Key>502582642</Key>
--    <Description>Pandorum</Description>
--    <IsArchived>true</IsArchived>
--    <ForeignId>F/LIC-0004001.01</ForeignId>
--</Budgetcode>'
--	SET @BV_WBS_Code = 2

	DECLARE @XML_Data XML
	SET @XML_Data = @strXml

	DECLARE @ErrorText VARCHAR(MAX), @ResponseType VARCHAR(MAX), @Status VARCHAR(MAX)
	SELECT TOP 1 @ErrorText = ISNULL(ErrorText, ''), @ResponseType = ISNULL(ResponseType, ''), @Status = ISNULL([Status], 'OK') FROM (
		SELECT 
		A.B.value('errorText[1]','VARCHAR(150)') AS ErrorText,
		A.B.value('responseType[1]','VARCHAR(1000)') AS ResponseType,
		A.B.value('status[1]','VARCHAR(1000)') AS [Status]
		FROM   @XML_Data.nodes('//Budgetcode') AS A(B)
	) AS TBL

	DECLARE @File_Code INT = 0, @File_Name VARCHAR(MAX) = ''

	Select @File_Name = REPLACE(CONVERT(VARCHAR, GETDATE(), 102), '.', '') + REPLACE(CONVERT(VARCHAR, GETDATE(), 114), ':', '') + '~' 
	+ CONVERT(VARCHAR, GETDATE(), 103) + ' ' + CONVERT(VARCHAR, GETDATE(), 108) --+ ' ' + RIGHT(CONVERT(VARCHAR(30), GETDATE(), 9), 2) 

	--SELECT @ErrorText AS ErrorText, @ResponseType AS ResponseType, @Status AS [Status]

	INSERT INTO Upload_Files([File_Name], Err_YN, Upload_Date, Uploaded_By, Upload_Type, Upload_Record_Count, Bank_Code, ChannelCode)
	VALUES(@File_Name, CASE WHEN LTRIM(RTRIM(UPPER(@Status))) = 'OK' THEN 'N' ELSE 'Y' END, GETDATE(), 143, 'BV_WBS_EXP', 1, 0, 0)

	select @File_Code = IDENT_CURRENT('Upload_Files')

	UPDATE BV_WBS SET 
		Error_Details = @ErrorText,
		Response_Type = @ResponseType,
		Response_Status = @Status,
		Is_Process = CASE WHEN LTRIM(RTRIM(UPPER(@Status))) = 'OK' THEN 'D' ELSE 'P' END,
		File_Code = @File_Code
	WHERE BV_WBS_Code = @BV_WBS_Code
	
	SELECT 'S' As Result
END
