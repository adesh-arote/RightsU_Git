--CREATE  PROCEDURE [dbo].[USPSchedulerDataGeneration](@AcqDealCode INT)
--AS
BEGIN
	SET NOCOUNT ON;	

	DECLARE @AcqDealCode INT = 26068
	/********************************Delcare Variables****************/

	IF OBJECT_ID('tempdb..#TempData') IS NOT NULL
	BEGIN
		DROP TABLE #TempData
	END
	
	IF OBJECT_ID('tempdb..#SharedRound') IS NOT NULL
	BEGIN
		DROP TABLE #SharedRound
	END				
	
	IF OBJECT_ID('tempdb..#Dummy_TempData_New') IS NOT NULL
	BEGIN
		DROP TABLE #Dummy_TempData_New
	END
	
	IF OBJECT_ID('tempdb..#TempData_New') IS NOT NULL
	BEGIN
		DROP TABLE #TempData_New
	END

	IF OBJECT_ID('tempdb..#tmpFinalData') IS NOT NULL
	BEGIN
		DROP TABLE #tmpFinalData
	END
	
	/********************************Set Amendment Flag****************/
	
	SELECT T.N AS Row_Num INTO #TempDummy
	FROM  (
		SELECT TOP(5000) ROW_NUMBER() OVER(ORDER BY 1/0)
		FROM sys.all_objects AS o1, sys.all_objects AS o2
	) AS T(N)
	
	SELECT 
		CAST(
			CASE
				WHEN Run_Type = 'U' THEN -1
				WHEN Is_Yearwise_Definition = 'Y' AND Is_Channel_Definition_Rights = 'Y' AND Run_Type <> 'U'
					THEN CASE WHEN Channel_Weightage_YearWise = 0 THEN 0 ELSE ROUND(Channel_Weightage_YearWise, 0) END													
				WHEN Is_Yearwise_Definition = 'Y' AND Is_Channel_Definition_Rights = 'N' AND Run_Type <> 'U'
					THEN CASE WHEN No_Of_Runs = 0 THEN 0 ELSE   ROUND((No_Of_Runs * 100) / No_Of_Runs, 0)  END
				WHEN Is_Yearwise_Definition = 'N' AND Is_Channel_Definition_Rights = 'Y' AND Run_Type <> 'U' AND Run_Definition_Type NOT in ('S', 'N')
					THEN Min_Runs
				WHEN Is_Yearwise_Definition = 'N' AND Is_Channel_Definition_Rights = 'Y' AND Run_Type <> 'U' AND Run_Definition_Type in ('S', 'N')
					THEN ROUND((No_Of_Runs * Channel_Weightage) / 100, 0) 
				ELSE No_Of_Runs END 
			AS INT
		) AS 'Total_Runs',				
		CAST(temp.Row_Num AS VARCHAR) AS Episode_Number,
		0 [CurIden_BMS_Deal], 
		0 [CurIden_BMS_Deal_Content],
		0 [CurIden_BMS_Asset],
		0 [Min_Plays],
		0 [Max_Plays],
		* INTO #TempData 
		FROM (
			SELECT DISTINCT T.Duration_In_Min, T.Title_Name AS Title_Name, T.Synopsis AS Synopsis, Lang.Language_Code RU_Language_Code, Lang.Ref_Language_Key,
			AD.Deal_Type_Code, ADRT.Episode_From, ADRT.Episode_To, CH.Channel_Code [RU_Channel_Code], CH.Ref_Station_Key [BMS_Station_Key],
			ADRun.Is_Rule_Right, RR.Right_Rule_Code [RU_Right_Rule_Code], RR.Ref_Right_Rule_Key [BMS_Right_Rule_Ref_Key],
			CAST(NULL AS Decimal(38,0)) [TitleContentCode], 'PRO' [Asset_Type],
			ADRun.Run_Type, ADRun.Acq_Deal_Run_Code,
			ADRun.Is_Channel_Definition_Rights, ADRun.Is_Yearwise_Definition, Run_Definition_Type, ADRC.Min_Runs,
			CASE WHEN ADRun.Is_Yearwise_Definition = 'Y' THEN ADRYR.No_Of_Runs ELSE ADRun.No_Of_Runs END No_Of_Runs,
			CASE 
				WHEN ADRun.Is_Channel_Definition_Rights ='Y' AND ADRun.Run_Type <> 'U'
				THEN CASE WHEN ADRun.No_Of_Runs = 0 THEN 0 ELSE CAST(((ISNULL(ADRC.Min_Runs, 0) * 100) / ISNULL(ADRun.No_Of_Runs, 0)) AS NUMERIC(6, 3)) END
				ELSE 0 
			END 'Channel_Weightage',
			CASE 
				WHEN ADRun.Is_Channel_Definition_Rights ='Y' AND ADRun.Is_Yearwise_Definition = 'Y' AND ADRun.Run_Type <> 'U'
				THEN CASE 
						WHEN ISNULL(ADRun.No_Of_Runs,0) = 0 THEN 0 
						ELSE ((ISNULL(ADRC.Min_Runs,0) * ISNULL(CAST(ADRYR.No_Of_Runs AS DECIMAL),0)) / CAST(ADRun.No_Of_Runs AS NUMERIC(6,3)))
					 END
			END 'Channel_Weightage_YearWise',
			NULL [Utilised_Run],
			CASE WHEN ADRYR.Acq_Deal_Run_Yearwise_Run_Code IS NULL THEN ADR.Actual_Right_Start_Date ELSE ADRYR.Start_Date END Right_Start_Date,
			CASE WHEN ADRYR.Acq_Deal_Run_Yearwise_Run_Code IS NULL THEN 
				CASE ADR.Right_Type WHEN 'U' THEN CAST('31 Dec 9999' AS DATETIME) ELSE ADR.Actual_Right_End_Date END
			ELSE ADRYR.End_Date END Right_End_Date,
			ADR.Actual_Right_Start_Date [Content_Start_Date], 
			CASE 
				WHEN ADR.Right_Type = 'U' THEN CAST('31 Dec 9999' AS DATETIME) 
				WHEN ADR.Right_Type = 'Y' AND ADR.Is_Tentative = 'Y' AND ADR.Actual_Right_Start_Date IS NOT NULL 
					THEN DATEADD(MONTH, CAST(SUBSTRING(Term, CHARINDEX('.', Term, 0) + 1 , LEN(Term)) AS INT), DATEADD(YEAR, CAST(SUBSTRING(Term, 0, CHARINDEX('.', Term, 0)) AS INT), Actual_Right_Start_Date))
				ELSE ADR.Actual_Right_End_Date 
			END [Content_End_Date],
			AD.Acq_Deal_Code, T.Title_Code [RU_Title_Code], AD.Ref_BMS_Code [BMS_Deal_Ref_Key], 'false' [Is_Archived], V.Vendor_Code [RU_Licensor_Code], NULL [RU_Payee_Code], 
			Cur.Currency_Code [RU_Currency_Code], E.Entity_Code [RU_Licensee_Code], Cat.Category_Code [RU_Category_Code],
			V.Ref_Vendor_Key [BMS_Licensor_Code], NULL [BMS_Payee_Code], Cur.Ref_Currency_Key [BMS_Currency_Code], 
			E.Ref_Entity_Key [BMS_Licensee_Code], Cat.Ref_Category_Key [BMS_Category_Code],
			AD.Deal_Desc [Description], NULL [Contact], AD.Agreement_No, NULL [Revision], 
			ADR.Actual_Right_Start_Date [Start_Date], 
			CASE ADR.Right_Type WHEN 'U' THEN CAST('31 Dec 9999' AS DATETIME) ELSE ADR.Actual_Right_End_Date END [End_Date], 
			'1001' [Status_SLUId], '24001' [Type_SLUId], 
			AD.Agreement_Date [Acquisition_Date], ADRun.Time_Lag_Simulcast
		FROM Acq_Deal AD 
		INNER JOIN Vendor V ON AD.Vendor_Code = V.Vendor_Code
		INNER JOIN Currency Cur ON AD.Currency_Code = Cur.Currency_Code
		INNER JOIN Entity E ON AD.Entity_Code = E.Entity_Code
		INNER JOIN Category Cat ON AD.Category_Code = Cat.Category_Code
		INNER JOIN Acq_Deal_Movie ADM ON AD.Acq_Deal_Code= ADM.Acq_Deal_Code
		INNER JOIN Title T ON ADM.Title_Code = T.Title_Code
		INNER JOIN Acq_Deal_Rights ADR ON AD.Acq_Deal_Code = ADR.Acq_Deal_Code AND ADR.Actual_Right_Start_Date IS NOT NULL					
		INNER JOIN Acq_Deal_Rights_Title ADRTitle ON ADM.Title_Code = ADRTitle.Title_code AND ADR.Acq_Deal_Rights_Code = ADRTitle.Acq_Deal_Rights_Code
													 AND ADRTitle.Episode_From = ADM.Episode_Starts_From AND ADRTitle.Episode_To = ADM.Episode_End_To
		INNER JOIN Acq_Deal_Rights_Platform ADRP ON ADR.Acq_Deal_Rights_Code = ADRP.Acq_Deal_Rights_Code
													AND ADRP.Platform_Code IN (SELECT Platform_Code FROM [Platform] where Is_No_Of_Run = 'Y')
		INNER JOIN Language Lang ON T.Title_Language_Code = Lang.Language_Code
		INNER JOIN Acq_Deal_Run ADRun ON AD.Acq_Deal_Code =  ADRun.Acq_Deal_Code AND ADRun.Is_Channel_Definition_Rights = 'Y'
		INNER JOIN Acq_Deal_Run_Title ADRT ON ADRun.Acq_Deal_Run_Code = ADRT.Acq_Deal_Run_Code AND ADRT.Title_Code = T.Title_Code
											  AND ADRTitle.Episode_From = ADRT.Episode_From AND ADRTitle.Episode_To = ADRT.Episode_To
											  AND ADM.Episode_Starts_From = ADRT.Episode_From AND ADM.Episode_End_To = ADRT.Episode_To
		LEFT JOIN Right_Rule RR ON ADRun.Right_Rule_Code = RR.Right_Rule_Code
		LEFT JOIN Acq_Deal_Run_Channel ADRC ON ADRun.Acq_Deal_Run_Code = ADRC.Acq_Deal_Run_Code
		LEFT JOIN Channel CH ON ADRC.Channel_Code = CH.Channel_Code
		LEFT JOIN Acq_Deal_Run_Yearwise_Run ADRYR ON ADRun.Acq_Deal_Run_Code = ADRYR.Acq_Deal_Run_Code
		WHERE 1=1 AND AD.Acq_Deal_Code = @AcqDealCode 
	) AS TBL
	INNER JOIN #TempDummy temp ON temp.Row_Num between TBL.Episode_From AND TBL.Episode_To
	WHERE Cast(TBL.Content_End_Date As Date) > Cast(GETDATE() As Date)

	PRINT '2'
	DROP TABLE #TempDummy
	
	-------NEED TO CHECK
	UPDATE #TempData SET Start_Date = (SELECT Min(Start_Date) FROM #TempData), End_Date = (SELECT Max(End_Date) FROM #TempData)
	
	UPDATE temp SET temp.TitleContentCode = ta.Title_Content_Code
	FROM #TempData temp 
	INNER JOIN Title_Content ta ON ta.Title_Code = temp.RU_Title_Code 					
	AND ISNULL(ta.Episode_No, 0) = ISNULL(temp.Episode_Number, 0)

	PRINT '3'
	/******** For shared & NA type definition *********************************************************************/
	SELECT No_Of_Runs AS TotalRuns, Acq_Deal_Run_Code,Right_Start_date 
	INTO #SharedRound
	FROM #TempData
	WHERE Run_Definition_Type IN ('S', 'N') AND No_Of_Runs > 0
	GROUP BY Acq_Deal_Run_Code, No_Of_Runs, RU_Channel_Code,Right_Start_Date

	/******** Update Total Runs and Content Start and End Date *********************************************************************/
	UPDATE temp SET temp.Total_Runs = shared.TotalRuns, Max_Plays = shared.TotalRuns
	FROM #TempData temp 
	INNER JOIN #SharedRound shared ON temp.Acq_Deal_Run_Code = shared.Acq_Deal_Run_Code AND temp.Right_Start_date = shared.Right_Start_date

	UPDATE TD SET TD.Content_Start_Date = TEMP.CONTENT_START_DATE, TD.Content_End_Date = TEMP.Content_End_Date
	FROM #TEMPDATA TD
	INNER JOIN (
		SELECT MIN(CONTENT_START_DATE) AS CONTENT_START_DATE, MAX(Content_End_Date) AS Content_End_Date,RU_TITLE_CODE,Episode_From,Episode_To 
		FROM #TEMPDATA GROUP BY RU_TITLE_CODE,Episode_From,Episode_To
	) TEMP ON TD.RU_TITLE_CODE = TEMP.RU_TITLE_CODE
	AND TD.Episode_From =TEMP.Episode_From AND TD.Episode_To =TEMP.Episode_To
	AND ISNULL(TD.Is_Yearwise_Definition,'N') = 'N'
	
	/********************************Calculate License_Fees****************/
	PRINT '4'
	
	--BEGIN TRAN
	
	BEGIN TRY
		
		PRINT '7'
		/********************************BMS_Asset****************/

		UPDATE temp SET temp.CurIden_BMS_Asset = tc.Title_Content_Code
		FROM Title_Content tc
		INNER JOIN #TempData temp ON tc.Title_Code = temp.RU_Title_Code AND ISNULL(tc.Episode_No, 0) = ISNULL(temp.Episode_Number, 0)

		/********************************Insert into new Temp Table****************/						
		PRINT '9'	

		SELECT DISTINCT Total_Runs, Episode_Number, CurIden_BMS_Deal, CurIden_BMS_Deal_Content, CurIden_BMS_Asset, Min_Plays, Max_Plays, Duration_In_Min,Title_Name,
			Synopsis, RU_Language_Code, Ref_Language_Key, Deal_Type_Code, Episode_From, Episode_To, RU_Channel_Code, BMS_Station_Key, Is_Rule_Right, RU_Right_Rule_Code,
			BMS_Right_Rule_Ref_Key, TitleContentCode, Asset_Type, Run_Type, Acq_Deal_Run_Code,
			Is_Channel_Definition_Rights, Is_Yearwise_Definition, Run_Definition_Type, Min_Runs, No_Of_Runs, Channel_Weightage, Channel_Weightage_YearWise, Utilised_Run,
			CASE WHEN Is_Yearwise_Definition = 'Y' THEN [Right_Start_Date] ELSE Content_Start_Date  END AS Right_Start_Date,
			CASE WHEN Is_Yearwise_Definition = 'Y' THEN Right_End_Date ELSE Content_End_Date  END AS Right_End_Date,
			Acq_Deal_Code, RU_Title_Code, BMS_Deal_Ref_Key, Is_Archived, RU_Licensor_Code, RU_Payee_Code, RU_Currency_Code,
			RU_Licensee_Code, RU_Category_Code, BMS_Licensor_Code, BMS_Payee_Code, BMS_Currency_Code, BMS_Licensee_Code, BMS_Category_Code,
			Description, Contact, Agreement_No, Revision, Status_SLUId, Type_SLUId, Acquisition_Date, Row_Num, Content_Start_Date, Time_Lag_Simulcast
			INTO #Dummy_TempData_New
		FROM #TempData

		SELECT ROW_NUMBER() OVER (PARTITION BY RU_Channel_Code, Content_Start_Date, CurIden_BMS_Asset ORDER BY RU_Channel_Code, Right_Start_Date, Right_End_Date) YearWise_No, * INTO #TempData_New
		FROM #Dummy_TempData_New


		--SELECT * FROM #TempData
		--SELECT * FROM #Dummy_TempData_New
		print 'A'

		DROP TABLE #TempData
		DROP TABLE #Dummy_TempData_New

			
		--SELECT DISTINCT [TitleContentCode], [Right_Start_Date], [Right_End_Date],
		--	[RU_Right_Rule_Code], [Total_Runs], YearWise_No, Min_Plays, Max_Plays, Min_Runs,
		--	Acq_Deal_Code, Acq_Deal_Run_Code, Run_Definition_Type, Run_Type, Is_Channel_Definition_Rights, Time_Lag_Simulcast
		--FROM #TempData_New
		--WHERE Run_Type = 'U' OR Run_Definition_Type IN('S', 'N')

		CREATE TABLE #tmpFinalData(
			TitleContentCode INT,
			ChannelCodes VARCHAR(1000),
			YearwiseNo INT,
			StartDate DATE,
			EndDate DATE,
			TotalRun INT,
			RunType CHAR(1),
			RightRuleName VARCHAR(1000),
			Is_First_Air INT,
			PPDay INT,
			Dur INT,
			RepeatCnt INT,
			Timelag TIME,
			AcqDealCode INT,
			AcqRunCode INT,
			SchedulerRightID INT,
			RunDefn CHAR(1),
			IsArchive CHAR(1)
		)

		INSERT INTO #tmpFinalData(TitleContentCode, 
					ChannelCodes, 
					YearwiseNo, StartDate, EndDate, TotalRun, RunType,
					RightRuleName, Is_First_Air, PPDay, Dur, RepeatCnt, Timelag,
					AcqDealCode, AcqRunCode, RunDefn, IsArchive
				)
		SELECT [TitleContentCode], 
				STUFF((SELECT DISTINCT ',' + CAST(ts.RU_Channel_Code AS VARCHAR(Max)) [text()]
					FROm #TempData_New ts
					Where ts.Acq_Deal_Run_Code = a.Acq_Deal_Run_Code
					FOR XML PATH(''), TYPE)
					.value('.','NVARCHAR(MAX)'),1,1,''
				)  AS Channel_Codes,
			   YearWise_No, [Right_Start_Date], [Right_End_Date], [Total_Runs], Run_Type,
			   rr.Right_Rule_Name, rr.IS_First_Air , rr.Play_Per_Day, rr.Duration_Of_Day, rr.No_Of_Repeat, Time_Lag_Simulcast,
			   Acq_Deal_Code, Acq_Deal_Run_Code, 'S','N'
		FROM(
			SELECT DISTINCT [TitleContentCode], [Right_Start_Date], [Right_End_Date],
				[RU_Right_Rule_Code], [Total_Runs], YearWise_No, Min_Plays, Max_Plays, --Min_Runs,
				Acq_Deal_Code, Acq_Deal_Run_Code, Run_Definition_Type, Run_Type, Is_Channel_Definition_Rights, Time_Lag_Simulcast
			FROM #TempData_New
			WHERE Run_Type = 'U' OR Run_Definition_Type IN('S', 'N')
		) AS a
		LEFT JOIN Right_Rule rr ON a.[RU_Right_Rule_Code] = rr.Right_Rule_Code



		INSERT INTO #tmpFinalData(TitleContentCode, ChannelCodes, YearwiseNo, StartDate, EndDate, TotalRun, RunType,
					RightRuleName, Is_First_Air, PPDay, Dur, RepeatCnt, Timelag,
					AcqDealCode, AcqRunCode, RunDefn,  IsArchive)
		SELECT DISTINCT [TitleContentCode], CAST([RU_Channel_Code] AS VARCHAR(100)), YearWise_No, [Right_Start_Date], [Right_End_Date], [Total_Runs], Run_Type,
			   rr.Right_Rule_Name, rr.IS_First_Air, rr.Play_Per_Day, rr.Duration_Of_Day, rr.No_Of_Repeat, Time_Lag_Simulcast,
			   Acq_Deal_Code, Acq_Deal_Run_Code, 'C', 'N'
		FROM #TempData_New a
		LEFT JOIN Right_Rule rr ON a.[RU_Right_Rule_Code] = rr.Right_Rule_Code
		WHERE Run_Type = 'C' AND Run_Definition_Type NOT IN('S', 'N')		
		PRINT CAST(@AcqDealCode AS VARCHAR(100))


		UPDATE SchedulerRights SET isArchive = 'Y', RecordStatus = 'P' WHERE Acq_Deal_Code = @AcqDealCode

	
		--SELECT TitleContentCode, ',' + ChannelCodes + ',', YearwiseNo, StartDate, EndDate, TotalRun, RunType, RightRuleName, PPDay, Dur, RepeatCnt, Timelag,
		--	   AcqDealCode, AcqRunCode, SchedulerRightID, RunDefn
		--FROM #tmpFinalData
		--SELECT * FROM #tmpFinalData
	
		--Added by akshay
		--Started
		

		UPDATE sr SET sr.isArchive = 'N'
	    FROM #tmpFinalData tmp
		INNER JOIN SchedulerRights sr ON sr.Acq_Deal_Run_Code = tmp.AcqRunCode AND sr.yearNo = tmp.YearwiseNo 
													   AND sr.runDef COLLATE Latin1_General_CI_AI = tmp.RunDefn COLLATE Latin1_General_CI_AI
													   AND tmp.RunDefn = 'C' AND tmp.ChannelCodes COLLATE Latin1_General_CI_AI = CAST(sr.channelId AS VARCHAR(5)) COLLATE Latin1_General_CI_AI

		--Ended

		UPDATE tmp SET tmp.SchedulerRightID = sr.SchedulerRightId 
		FROM #tmpFinalData tmp
		INNER JOIN SchedulerRights sr ON sr.Acq_Deal_Run_Code = tmp.AcqRunCode AND sr.yearNo = tmp.YearwiseNo 
													   AND sr.runDef COLLATE Latin1_General_CI_AI = tmp.RunDefn COLLATE Latin1_General_CI_AI
													   AND tmp.RunDefn = 'C' AND tmp.ChannelCodes COLLATE Latin1_General_CI_AI = CAST(sr.channelId AS VARCHAR(5)) COLLATE Latin1_General_CI_AI

		UPDATE tmp SET tmp.SchedulerRightID = sr.SchedulerRightId
		FROM #tmpFinalData tmp
		INNER JOIN SchedulerRights sr ON sr.Acq_Deal_Run_Code = tmp.AcqRunCode AND sr.yearNo = tmp.YearwiseNo 
													   AND sr.runDef COLLATE Latin1_General_CI_AI = tmp.RunDefn COLLATE Latin1_General_CI_AI
													   AND tmp.RunDefn = 'S' --AND tmp.ChannelCodes COLLATE Latin1_General_CI_AI = CAST(sr.channelId AS VARCHAR(5)) COLLATE Latin1_General_CI_AI
		
		UPDATE tmp SET tmp.SchedulerRightID = sr.SchedulerRightId
		FROM #tmpFinalData tmp
		INNER JOIN SchedulerRights sr ON sr.Acq_Deal_Run_Code = tmp.AcqRunCode AND sr.yearNo = tmp.YearwiseNo 
													   AND sr.runDef COLLATE Latin1_General_CI_AI <> tmp.RunDefn COLLATE Latin1_General_CI_AI
													   AND tmp.RunDefn = 'C'
		
		UPDATE tmp SET tmp.SchedulerRightID = sr.SchedulerRightId
		FROM #tmpFinalData tmp
		INNER JOIN SchedulerRights sr ON sr.Acq_Deal_Run_Code = tmp.AcqRunCode AND sr.yearNo = tmp.YearwiseNo 
													   AND sr.runDef COLLATE Latin1_General_CI_AI <> tmp.RunDefn COLLATE Latin1_General_CI_AI
													   AND tmp.RunDefn = 'S' AND (',' + tmp.ChannelCodes +',') COLLATE Latin1_General_CI_AI LIKE '%' + (',' + sr.channelId +',') + '%' COLLATE Latin1_General_CI_AI

		
		
		SELECT sr.Acq_Deal_Run_Code,COUNT(sr.Acq_Deal_Run_Code)
					FROM SchedulerRights sr 
					WHERE --sr.runDef = 'S' 
					 sr.Acq_Deal_Run_Code IN (SELECT AcqRunCode FROM #tmpFinalData) 
					AND sr.Acq_Deal_Code IN (SELECT Acq_Deal_Code FROM #tmpFinalData )
					GROUP BY sr.Acq_Deal_Run_Code HAVING COUNT(sr.Acq_Deal_Run_Code) > 1 

		SELECT Acq_Deal_Run_Code, * FROM SchedulerRights
		SELECT * FROM #tmpFinalData
		--return

		UPDATE A SET A.SchedulerRightID = NULL FROM (
			    SELECT SchedulerRightID, ROW_NUMBER() OVER(PARTITION BY SchedulerRightID ORDER BY SchedulerRightID) AS Row_Number 
				FROM #tmpFinalData 
				WHERE AcqRunCode NOT IN (
					SELECT sr.Acq_Deal_Run_Code
					FROM SchedulerRights sr 
					WHERE --sr.runDef = 'S' 
					 sr.Acq_Deal_Run_Code IN (SELECT AcqRunCode FROM #tmpFinalData) 
					AND sr.Acq_Deal_Code IN (SELECT Acq_Deal_Code FROM #tmpFinalData )
					GROUP BY sr.Acq_Deal_Run_Code HAVING COUNT(sr.Acq_Deal_Run_Code) > 1 
				)
		) as A where A.Row_Number > 1

		INSERT INTO SchedulerRights(assetId, channelId, rightsStartDate, rightsEndDate, yearNo, availableRun, consumptionRun, runType, runDef, 
												  rightsRuleName, Is_First_Air , playPerRightsRule, duration, repeatPerRightsRule, timeLag, CreateOn, UpdatedOn, Acq_Deal_Code, Acq_Deal_Run_Code, 
												  isArchive, RecordStatus)
		SELECT TitleContentCode, ChannelCodes, StartDate, EndDate, YearwiseNo, TotalRun, 0, RunType, RunDefn,
			   RightRuleName, Is_First_Air , PPDay, Dur, RepeatCnt, Timelag, GETDATE(), GETDATE(), AcqDealCode, AcqRunCode,
			   'N', 'P'
		FROM #tmpFinalData
		WHERE SchedulerRightID IS NULL  

		UPDATE sr SET
			sr.assetId = tmp.TitleContentCode,
			sr.channelId = tmp.ChannelCodes, 
			sr.rightsStartDate = tmp.StartDate, 
			sr.rightsEndDate = tmp.EndDate, 
			sr.yearNo = tmp.YearwiseNo, 
			sr.availableRun = tmp.TotalRun, 
			sr.consumptionRun = 0, 
			sr.runType = tmp.RunType, 
			sr.runDef = tmp.RunDefn, 
			sr.rightsRuleName = tmp.RightRuleName, 
			sr.Is_First_Air = tmp.Is_First_Air, 
			sr.playPerRightsRule = tmp.PPDay, 
			sr.duration = tmp.Dur, 
			sr.repeatPerRightsRule = tmp.RepeatCnt, 
			sr.timeLag = tmp.Timelag, 
			sr.UpdatedOn = GETDATE(), 
			sr.RecordStatus = 'P',
			sr.isArchive = tmp.IsArchive
		FROM #tmpFinalData tmp
		INNER JOIN SchedulerRights sr ON sr.SchedulerRightId = tmp.SchedulerRightID
		
		--COMMIT
	END TRY
	BEGIN CATCH
		SELECT ERROR_MESSAGE(), ERROR_Line()
		--ROLLBACK
	END CATCH

	/********************************DELETE Temp Table if Exists ****************/

	DROP TABLE #SharedRound
	DROP TABLE #TempData_New
	--DROP TABLE #tmpFinalData

	/**************END*************/
					
END

--exec [USPSchedulerDataGeneration] 2066
--select * from Acq_Deal order by 1 desc