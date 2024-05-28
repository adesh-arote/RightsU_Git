CREATE PROC [dbo].[USP_BMS_Schedule_Channel_For_PUSH]
AS
--    ==========================
--    Author        :   Abhaysingh N. Rajpurohit  
--    Created On    :   05 July 2016
--    Edited By        :   Anchal Sikarwar  
--    Created On    :   16 Dec 2016
--    Description   :   Select All Channel Which is IsUseForAsRun = 'Y' to Get schedule data
--    Notes            :   This procedure will return recordset(table) with five columns (1. Channel_Code, 2. Ref_Station_Key, 3. Method_Type, 4. BaseAddress, 5. RequestUri,)
--    ==========================
BEGIN
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_BMS_Schedule_Channel_For_PUSH]', 'Step 1', 0, 'Started Procedure', 0, ''
		IF OBJECT_ID('tempdb..#Temp') IS NOT NULL
		BEGIN
			Drop Table #Temp
		END
			IF OBJECT_ID('tempdb..#Temp2') IS NOT NULL
		BEGIN
			Drop Table #Temp2
		END

		DECLARE @BaseAddress VARCHAR(300) = '',@RequestUri VARCHAR(100) = '', @moduleName VARCHAR(MAX)
		SET @moduleName = 'BMS_Schedule_PlayCount'
		SELECT TOP 1 @BaseAddress = [BaseAddress],@RequestUri = RequestUri
		FROM BMS_All_Masters (NOLOCK) WHERE Method_Type = 'p' AND Module_Name = @moduleName AND Is_Active = 'Y'

		CREATE TABLE #Temp
		(
			BMS_Schedule_Log_Code INT,
			BMS_Schedule_Process_Data_Temp_Code INT,
			BV_Schedule_Transaction_Code INT,
			ChanneL_Code INT,
			DealContent_RightId INT,
			Email_Notification_Msg_Code INT,
			Ref_Channel_Key INT,
			TimeLineID  INT,
			SYSLookupId_PlayCountError INT,
			PlayDay  INT,
			PlayRun  INT,
			BMS_Asset_Ref_Key INT,
			Acq_Deal_Code INT
		)
		INSERT INTO #Temp(BMS_Schedule_Log_Code,BMS_Schedule_Process_Data_Temp_Code,ChanneL_Code,Email_Notification_Msg_Code,TimeLineID,SYSLookupId_PlayCountError)
		SELECT DISTINCT BSPD.BMS_Schedule_Log_Code,BSPD.BMS_Schedule_Process_Data_Temp_Code,BSPD.ChanneL_Code,BSE.Email_Notification_Msg_Code,
		BSPD.Timeline_ID,0 AS SYSLookupId_PlayCountError
		FROM BMS_Schedule_Process_Data_Temp BSPD (NOLOCK)
		INNER JOIN BMS_Schedule_Exception BSE (NOLOCK) ON ISNULL(BSE.BMS_Schedule_Process_Data_Temp_Code,0) = ISNULL(BSPD.BMS_Schedule_Process_Data_Temp_Code,0)
		AND ISNULL(BSE.BMS_Schedule_Process_Data_Temp_Code,0) > 0
		AND Convert(datetime,BSPD.Inserted_On,103) >
		(
			SELECT TOP 1 Convert(datetime,TBL.Response_Time,103) FROM
			(
				SELECT TOP 1 BSL.Response_Time
				FROM BMS_Schedule_Log BSL  (NOLOCK)
				WHERE BSL.Channel_Code = BSPD.Channel_Code  AND UPPER(ISNULL(BSL.Method_Type,'')) = 'PUT' AND ISNULL(BSL.Record_Status,'')='D'
				ORDER BY 1 DESC
				UNION
				SELECT '01 Jan 1900' AS Response_Time
			) AS TBL
			ORDER BY 1 DESC
		)

		INSERT INTO #Temp(BMS_Schedule_Log_Code,BV_Schedule_Transaction_Code,ChanneL_Code,Email_Notification_Msg_Code,TimeLineID,SYSLookupId_PlayCountError)
		SELECT DISTINCT BST.File_Code,BST.BV_Schedule_Transaction_Code,BSLL.Channel_Code,BSE.Email_Notification_Msg_Code,
		BST.Timeline_ID,0 AS SYSLookupId_PlayCountError
		FROM BV_Schedule_Transaction BST  (NOLOCK)
		INNER JOIN BMS_Schedule_Log BSLL (NOLOCK) ON ISNULL(BST.File_Code,0) = ISNULL(BSLL.BMS_Schedule_Log_Code,0)
		INNER JOIN BMS_Schedule_Exception BSE (NOLOCK) ON ISNULL(BSE.BV_Schedule_Transaction_Code,0)  = ISNULL(BST.BV_Schedule_Transaction_Code,0)
		AND ISNULL(BSE.BV_Schedule_Transaction_Code,0) > 0
		AND Convert(datetime,ISNULL(BST.Last_Updated_Time,Inserted_On),103) > 
		(
			SELECT TOP 1 Convert(datetime,TBL.Response_Time,103) FROM
			(
				SELECT TOP 1 BSL.Response_Time
				FROM BMS_Schedule_Log BSL  (NOLOCK)
				WHERE BSL.Channel_Code = BSLL.Channel_Code AND UPPER(ISNULL(BSL.Method_Type,'')) = 'PUT'  AND ISNULL(BSL.Record_Status,'')='D'
				ORDER BY 1 DESC
				UNION
				SELECT '01 Jan 1900' AS Response_Time
			) AS TBL
			ORDER BY 1 DESC
		) 

		UPDATE T SET T.SYSLookupId_PlayCountError=ENM.BMS_Error_Code
		FROM #Temp T
		INNER JOIN Email_Notification_Msg ENM ON ENM.Email_Notification_Msg_Code=T.Email_Notification_Msg_Code
		AND ISNULL(ENM.BMS_Error_Code,0)>0

		INSERT INTO #Temp(BMS_Schedule_Log_Code,BV_Schedule_Transaction_Code,ChanneL_Code,TimeLineID,DealContent_RightId,PlayDay,
		PlayRun,BMS_Asset_Ref_Key,Acq_Deal_Code)
		SELECT DISTINCT BST.File_Code,BST.BV_Schedule_Transaction_Code,BSLL.Channel_Code,BST.Timeline_ID,
		(
			select TOP 1 BDCR.BMS_Deal_Content_Rights_Ref_Key from BMS_Deal BD  (NOLOCK)
			INNER JOIN BMS_Deal_Content BDC (NOLOCK) ON BD.BMS_Deal_Code=BDC.BMS_Deal_Code
			INNER JOIN BMS_Deal_Content_Rights BDCR (NOLOCK) ON BDCR.BMS_Deal_Content_Code =BDC.BMS_Deal_Content_Code
			where BD.Acq_Deal_Code=BST.Acq_Deal_Code
			AND BDCR.BMS_Asset_Ref_Key=BSt.Program_Episode_ID
		) AS DealContent_RightId,
		BST.Play_Day AS PlayDay,BST.Play_Run AS PlayRun,BST.Program_Episode_ID,BST.Acq_Deal_Code
		--,Convert(datetime,ISNULL(BST.Last_Updated_Time,Inserted_On),103)
		--,
		--	(
		--		SELECT TOP 1 Convert(datetime,TBL.Response_Time,103) FROM
		--		(
		--		SELECT TOP 1 BSL.Response_Time
		--		FROM BMS_Schedule_Log BSL 
		--		WHERE BSL.Channel_Code = BSLL.Channel_Code AND UPPER(ISNULL(BSL.Method_Type,'')) = 'PUT'  AND ISNULL(BSL.Record_Status,'')='D'
		--		ORDER BY 1 DESC
		--		UNION
		--		SELECT '01 Jan 1900' AS Response_Time
		--		) AS TBL
		--		ORDER BY 1 DESC
		--	) 
		--	,BSLL.Channel_Code
	
		FROM  BV_Schedule_Transaction BST  (NOLOCK)
		INNER JOIN BMS_Schedule_Log BSLL (NOLOCK) ON ISNULL(BST.File_Code,0) = ISNULL(BSLL.BMS_Schedule_Log_Code,0) AND BST.Channel_Code = BSLL.Channel_Code
		AND 
		(Convert(datetime,ISNULL(BST.Last_Updated_Time,BST.Inserted_On),103) >
			(
				SELECT TOP 1 Convert(datetime,TBL.Response_Time,103) FROM
				(
				SELECT TOP 1 BSL.Response_Time
				FROM BMS_Schedule_Log BSL  (NOLOCK)
				WHERE BSL.Channel_Code = BSLL.Channel_Code AND UPPER(ISNULL(BSL.Method_Type,'')) = 'PUT'  AND ISNULL(BSL.Record_Status,'')='D'
				ORDER BY 1 DESC
				UNION
				SELECT '01 Jan 1900' AS Response_Time
				) AS TBL
				ORDER BY 1 DESC
			) 
		)
		AND BST.File_Code NOT IN(select BMS_Schedule_Log_Code from #Temp) AND BST.Timeline_ID IS NOT NULL
 
		UPDATE T SET T.DealContent_RightId = BDCR.BMS_Deal_Content_Rights_Ref_Key from BMS_Deal BD 
		INNER JOIN BMS_Deal_Content BDC ON BD.BMS_Deal_Code=BDC.BMS_Deal_Code
		INNER JOIN BMS_Deal_Content_Rights BDCR ON BDCR.BMS_Deal_Content_Code = BDC.BMS_Deal_Content_Code
		INNER JOIN #Temp T ON T.ChanneL_Code=BDCR.RU_Channel_Code AND BDCR.BMS_Asset_Ref_Key=T.BMS_Asset_Ref_Key
	
		UPDATE T SET T.Ref_Channel_Key=C.Ref_Channel_Key FROM #Temp AS T
		INNER JOIN Channel C ON C.Channel_Code = T.ChanneL_Code

		SELECT C.Channel_Code, BS.Ref_Channel_Key, 'PUT' AS Method_Type, @BaseAddress AS BaseAddress, @RequestUri  AS RequestUri,'<?xml version="1.0" ?>'+
			(
				SELECT DISTINCT T.TimeLineID AS TimelineId,T.DealContent_RightId AS DealContent_RightId,ISNULL(T.SYSLookupId_PlayCountError,0) AS SYSLookupId_PlayCountError
				,T.PlayDay AS PlayDay, T.PlayRun AS PlayRun 
				FROM #Temp AS T
				--where T.Channel_Code=24
				where T.Channel_Code=BS.Channel_Code
				FOR XML PATH('PlayCountChange'), ROOT('PlayCounts')  
			)
			AS Request_XML

		INTO #Temp2   
		FROM DBO.Channel C
		INNER JOIN #Temp BS ON C.Channel_Code=BS.Channel_Code
		WHERE @BaseAddress <> '' AND @RequestUri <> ''
		AND ISNULL(C.Is_Put,'N')='Y' AND ISNULL(C.Is_Get,'N')='Y'
		ORDER BY C.Order_For_schedule

		SELECT DISTINCT * from #Temp2 where Request_XML IS NOT NULL 

		IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp
		IF OBJECT_ID('tempdb..#Temp2') IS NOT NULL DROP TABLE #Temp2
	
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_BMS_Schedule_Channel_For_PUSH]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END