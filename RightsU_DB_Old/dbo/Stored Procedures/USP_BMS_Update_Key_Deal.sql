ALTER  PROC [dbo].[USP_BMS_Update_Key_Deal]
(
	@strXml VARCHAR(MAX),
    @Type VARCHAR(10),
    @Is_Error VARCHAR(1),
    @Error_Details VARCHAR(MAX),
    @BMS_Log_Code INT,
	@Request_Time VARCHAR(30),
	@Request_Message VARCHAR(MAX)
)
AS
--	==========================
--	Author		:	Abhaysingh N. Rajpurohit	
--	Created On	:	29 September 2015
--	Description	:	Convert XML into table format, and update BMS_Key in BMS_WBS, SAP_WBS tables
--	==========================
BEGIN
--	DECLARE @strXml VARCHAR(MAX), @Type VARCHAR(10) = 'BMS_D'
	DECLARE @Temp_Request_Time DATETIME = CONVERT(DATETIME,@Request_Time,102)
	--DECLARE @XML_Data XML
	--SET @XML_Data = @strXml

	IF OBJECT_ID('TEMPDB..#Temp_Updated_Keys') IS NOT NULL
	BEGIN
		DROP TABLE #Temp_Updated_Keys
	END

	CREATE TABLE #Temp_Updated_Keys
	(
		BMS_Key INT, 
		Code INT
	)

	IF(@Type = 'RUBVD')
	BEGIN
		--INSERT INTO #Temp_Updated_Keys(BMS_Key, Code)
		--SELECT A.B.value('Key[1]','INT') AS BMS_Key,
		--REPLACE(A.B.value('ForeignId[1]','VARCHAR(40)'), 'RUBVD', '')  AS Code
		--FROM   @XML_Data.nodes('//Deal') AS A(B)

		INSERT INTO #Temp_Updated_Keys(BMS_Key, Code)
		SELECT BMS_Key, REPLACE(RU_Code, 'RUBMSBVD', '')  AS Code  FROM BMS_Response_Data WHERE Type_For = 'RUBVD'
		
		DELETE bvRD FROM BMS_Response_Data bvRD
		INNER JOIN #Temp_Updated_Keys tmp ON REPLACE(bvRD.RU_Code, 'RUBMSBVD', '') = tmp.Code AND bvRD.BMS_Key = tmp.BMS_Key
		WHERE Type_For = 'RUBVD'

		IF(@Is_Error = 'Y')
		BEGIN
			UPDATE bvD SET Request_Time = @Temp_Request_Time, bvD.Error_Description = @Error_Details, bvD.Record_Status = 'E', bvD.Response_Time = GETDATE() FROM BMS_Deal bvD
			INNER JOIN #Temp_Updated_Keys tmp ON bvD.BMS_Deal_Code = tmp.Code
		END
		ELSE IF(@Is_Error = 'N')
		BEGIN
			UPDATE bvD SET Request_Time = @Temp_Request_Time,  bvD.BMS_Deal_Ref_Key = tmp.BMS_Key, bvD.Record_Status = 'D', 
			bvD.Response_Time = GETDATE(), bvD.Error_Description = @Error_Details FROM BMS_Deal bvD
			INNER JOIN #Temp_Updated_Keys tmp ON bvD.BMS_Deal_Code = tmp.Code

			UPDATE bvDC SET BMS_Deal_Ref_Key = tmp.BMS_Key FROM BMS_Deal_Content bvDC
			INNER JOIN #Temp_Updated_Keys tmp ON bvDC.BMS_Deal_Code = tmp.Code

			UPDATE AD SET AD.Ref_BMS_Code = tmp.BMS_Key FROM Acq_Deal AD
			INNER JOIN BMS_Deal bvD ON bvD.Acq_Deal_Code = AD.Acq_Deal_Code
			INNER JOIN #Temp_Updated_Keys tmp ON bvD.BMS_Deal_Code = tmp.Code	
			WHERE AD.Deal_Workflow_Status NOT IN ('AR', 'WA')
		END
	END
	ELSE IF(@Type = 'RUBVA')
	BEGIN

		INSERT INTO #Temp_Updated_Keys(BMS_Key, Code)
		SELECT BMS_Key, REPLACE(RU_Code, 'RUBMSBVA', '')  AS Code  FROM BMS_Response_Data WHERE Type_For = 'RUBVA'
		
		DELETE bvRD FROM BMS_Response_Data bvRD
		INNER JOIN #Temp_Updated_Keys tmp ON REPLACE(bvRD.RU_Code, 'RUBMSBVA', '') = tmp.Code AND bvRD.BMS_Key = tmp.BMS_Key
		WHERE Type_For = 'RUBVA'

		IF(@Is_Error = 'Y')
		BEGIN
			UPDATE bvA SET Request_Time = @Temp_Request_Time,
			bvA.Error_Description = @Error_Details, bvA.Record_Status = 'E', bvA.Response_Time = GETDATE() ,bvA.IS_Consider='N'
			FROM BMS_Asset bvA
			INNER JOIN #Temp_Updated_Keys tmp ON bvA.BMS_Asset_Code = tmp.Code
		END
		ELSE IF(@Is_Error = 'N')
		BEGIN
			UPDATE bvA SET Request_Time = @Temp_Request_Time,
			bvA.BMS_Asset_Ref_Key = tmp.BMS_Key, bvA.Record_Status = 'D', bvA.Response_Time = GETDATE(),bvA.IS_Consider='N',
			bvA.Error_Description = @Error_Details 
			FROM BMS_Asset bvA
			INNER JOIN #Temp_Updated_Keys tmp ON bvA.BMS_Asset_Code = tmp.Code

			UPDATE TC SET TC.Ref_BMS_Content_Code = tmp.BMS_Key
			FROM Title_Content TC
			INNER JOIN Title_Content_Mapping TCM ON TCM.Title_Content_Code = TC.Title_Content_Code 
			INNER JOIN Acq_Deal_Movie ADM ON ADM.Acq_Deal_Movie_Code = TCM.Acq_Deal_Movie_Code
			INNER JOIN BMS_Asset BA ON BA.Episode_Number = TC.Episode_No AND ADM.Title_Code = BA.RU_Title_Code
			INNER JOIN #Temp_Updated_Keys tmp ON BA.BMS_Asset_Code = tmp.Code

			UPDATE bvDC SET bvDC.BMS_Asset_Ref_Key = tmp.BMS_Key FROM BMS_Deal_Content bvDC
			INNER JOIN #Temp_Updated_Keys tmp ON bvDC.BMS_Asset_Code = tmp.Code

			UPDATE bvDCR SET bvDCR.BMS_Asset_Ref_Key = tmp.BMS_Key FROM BMS_Deal_Content_Rights bvDCR
			INNER JOIN #Temp_Updated_Keys tmp ON bvDCR.BMS_Asset_Code = tmp.Code
		END

	END
	ELSE IF(@Type = 'RUBVPV')
	BEGIN
		INSERT INTO #Temp_Updated_Keys(BMS_Key, Code)
		SELECT BMS_Key, REPLACE(RU_Code, 'RUBMSBVPV', '')  AS Code  FROM BMS_Response_Data WHERE Type_For = 'RUBVPV'
		
		DELETE bvRD FROM BMS_Response_Data bvRD
		INNER JOIN #Temp_Updated_Keys tmp ON REPLACE(bvRD.RU_Code, 'RUBMSBVPV', '') = tmp.Code AND bvRD.BMS_Key = tmp.BMS_Key
		WHERE Type_For = 'RUBVPV'

		IF(@Is_Error = 'Y')
		BEGIN
			UPDATE bvA SET Request_Time = @Temp_Request_Time,  bvA.Error_Description = @Error_Details, bvA.Record_Status = 'E', bvA.Response_Time = GETDATE() 
			FROM BMS_ProgramVersion bvA
			INNER JOIN #Temp_Updated_Keys tmp ON bvA. BMS_ProgramVersion_Code= tmp.Code
		END
		ELSE IF(@Is_Error = 'N')
		BEGIN
			UPDATE bvA SET Request_Time = @Temp_Request_Time, bvA.BMS_ProgramVersion_Ref_Key = tmp.BMS_Key, bvA.Record_Status = 'D', bvA.Response_Time = GETDATE(),
			bvA.Error_Description = @Error_Details 
			FROM BMS_ProgramVersion bvA
			INNER JOIN #Temp_Updated_Keys tmp ON bvA.BMS_ProgramVersion_Code = tmp.Code
		END
	END

	ELSE IF(@Type = 'RUBVDC')
	BEGIN		
		
		INSERT INTO #Temp_Updated_Keys(BMS_Key, Code)
		SELECT BMS_Key, REPLACE(RU_Code, 'RUBMSBVDC', '')  AS Code  FROM BMS_Response_Data WHERE Type_For = 'RUBVDC'
		
		DELETE bvRD FROM BMS_Response_Data bvRD
		INNER JOIN #Temp_Updated_Keys tmp ON REPLACE(bvRD.RU_Code, 'RUBMSBVDC', '') = tmp.Code AND bvRD.BMS_Key = tmp.BMS_Key
		WHERE Type_For = 'RUBVDC'

		IF(@Is_Error = 'Y')
		BEGIN
			UPDATE bvDC SET Request_Time = @Temp_Request_Time,  bvDC.Error_Description = @Error_Details, bvDC.Record_Status = 'E', bvDC.Response_Time = GETDATE() FROM BMS_Deal_Content bvDC
			INNER JOIN #Temp_Updated_Keys tmp ON bvDC.BMS_Deal_Content_Code = tmp.Code
		END
		ELSE IF(@Is_Error = 'N')
		BEGIN
			UPDATE bvDC SET  Request_Time = @Temp_Request_Time, bvDC.BMS_Deal_Content_Ref_Key = tmp.BMS_Key, bvDC.Record_Status = 'D',
			bvDC.Response_Time = GETDATE(),bvDC.Error_Description = @Error_Details FROM BMS_Deal_Content bvDC
			INNER JOIN #Temp_Updated_Keys tmp ON bvDC.BMS_Deal_Content_Code = tmp.Code

			UPDATE bvDCR SET bvDCR.BMS_Deal_Content_Ref_Key = tmp.BMS_Key FROM BMS_Deal_Content_Rights bvDCR
			INNER JOIN #Temp_Updated_Keys tmp ON bvDCR.BMS_Deal_Content_Code = tmp.Code
		END

	END
	ELSE IF(@Type = 'RUBVDCR')
	BEGIN		
		
		INSERT INTO #Temp_Updated_Keys(BMS_Key, Code)
		SELECT BMS_Key, REPLACE(RU_Code, 'RUBMSBVDCR', '')  AS Code  FROM BMS_Response_Data WHERE Type_For = 'RUBVDCR'
		
		DELETE bvRD FROM BMS_Response_Data bvRD
		INNER JOIN #Temp_Updated_Keys tmp ON REPLACE(bvRD.RU_Code, 'RUBMSBVDCR', '') = tmp.Code AND bvRD.BMS_Key = tmp.BMS_Key
		WHERE Type_For = 'RUBVDCR'

		IF(@Is_Error = 'Y')
		BEGIN
			UPDATE bvDCR SET Request_Time = @Temp_Request_Time,  bvDCR.Error_Description = @Error_Details, bvDCR.Record_Status = 'E', bvDCR.Response_Time = GETDATE() FROM BMS_Deal_Content_Rights bvDCR
			INNER JOIN #Temp_Updated_Keys tmp ON bvDCR.BMS_Deal_Content_Rights_Code = tmp.Code
		END
		ELSE IF(@Is_Error = 'N')
		BEGIN
			UPDATE bvDCR SET Request_Time = @Temp_Request_Time,  bvDCR.BMS_Deal_Content_Rights_Ref_Key = tmp.BMS_Key, bvDCR.Record_Status = 'D',bvDCR.Response_Time=GETDATE(),
			bvDCR.Error_Description = @Error_Details FROM BMS_Deal_Content_Rights bvDCR
			INNER JOIN #Temp_Updated_Keys tmp ON bvDCR.BMS_Deal_Content_Rights_Code = tmp.Code
		END
	END

	UPDATE BMS_Log SET
	Request_Time = @Temp_Request_Time,
	Request_Message =@Request_Message ,
    Response_Time = GETDATE(),
    Response_Xml = CASE WHEN UPPER(@Is_Error) = 'Y' THEN '' ELSE @strXml END,
    Record_Status = CASE WHEN UPPER(@Is_Error) = 'Y' THEN 'E' ELSE 'D' END,
    Error_Description = @Error_Details
    WHERE  BMS_Log_Code = @BMS_Log_Code
END
