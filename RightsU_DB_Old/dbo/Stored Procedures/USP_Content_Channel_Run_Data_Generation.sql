
ALTER PROCEDURE [dbo].[USP_Content_Channel_Run_Data_Generation]
--DECLARE
@Acq_Deal_Code INT
AS
BEGIN
-- =============================================
-- Author:		Anchal Sikarwar
-- Create date: 05 Apr, 2017
-- Description:	
-- =============================================
	SET NOCOUNT ON;	
	DECLARE @Is_Error CHAR(1), @Error_Desc VARCHAR(MAX)
	
	BEGIN TRY	
			/********************************DELETE Temp Table if Exists ****************/
			BEGIN
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
				IF OBJECT_ID('tempdb..#Temp_BMS_Deal_Content') IS NOT NULL
				BEGIN
					DROP TABLE #Temp_BMS_Deal_Content
				END
				IF OBJECT_ID('tempdb..#Temp_BMS_Deal_Content_Rights') IS NOT NULL
				BEGIN
					DROP TABLE #Temp_BMS_Deal_Content_Rights
				END
				IF OBJECT_ID('tempdb..#Temp_Content_Channel_Run') IS NOT NULL
				BEGIN
					DROP TABLE #Temp_Content_Channel_Run
				END
				IF OBJECT_ID('tempdb..#TempDummy') IS NOT NULL
				BEGIN
					DROP TABLE #TempDummy
				END
				IF OBJECT_ID('tempdb..#TempData_Final') IS NOT NULL
				BEGIN
					DROP TABLE #TempData_Final
				END
			END
				/********************************Delcare Variables****************/
			
			DECLARE  @Is_Amendment CHAR(1)  = 'N',@BMS_Deal_Code INT = 0,@License_Fees DECIMAL = 0.0
			/********************************Set Amendment Flag****************/
			SELECT TOP 1 @Is_Amendment = CASE WHEN  BV.Acq_Deal_Code > 0 THEN 'Y' ELSE 'N' END, @BMS_Deal_Code = BV.BMS_Deal_Code
			FROM BMS_Deal BV WHERE ISNULL(BV.Acq_Deal_Code,0) = @Acq_Deal_Code

			CREATE TABLE #Temp_BMS_Deal_Content
			(
				BMS_Deal_Content_Code INT, BMS_Deal_Code INT, BMS_Asset_Code INT, [Start_Date] DATETIME, End_Date DATETIME
			)
			SELECT T.N AS Row_Num INTO #TempDummy
			FROM (
				SELECT TOP(5000) ROW_NUMBER() OVER(ORDER BY 1/0)
				FROM sys.all_objects AS o1, sys.all_objects AS o2
			) AS T(N)

			SELECT  
			CAST(
				CASE
					WHEN Run_Type = 'U' THEN -1
					WHEN Is_Yearwise_Definition = 'Y' AND Is_Channel_Definition_Rights = 'Y' AND Run_Type <> 'U'  AND Run_Definition_Type ='C'
						THEN CASE WHEN Channel_Weightage_YearWise = 0 THEN 0 ELSE  
							ROUND(Channel_Weightage_YearWise, 0) END	
					WHEN Is_Yearwise_Definition = 'Y' AND Is_Channel_Definition_Rights = 'Y' AND Run_Type <> 'U'  AND Run_Definition_Type ='S'
						THEN  No_Of_Runs												
					WHEN Is_Yearwise_Definition = 'Y' AND Is_Channel_Definition_Rights = 'N' AND Run_Type <> 'U'
						THEN CASE WHEN No_Of_Runs = 0 THEN 0 ELSE   ROUND((No_Of_Runs * 100) / No_Of_Runs, 0)  END
					WHEN Is_Yearwise_Definition = 'N' AND Is_Channel_Definition_Rights = 'Y' AND Run_Type <> 'U' AND Run_Definition_Type NOT in ('S', 'N')
						THEN Min_Runs
					WHEN Is_Yearwise_Definition = 'N' AND Is_Channel_Definition_Rights = 'Y' AND Run_Type <> 'U' AND Run_Definition_Type in ('S', 'N')
						THEN No_Of_Runs
						--ROUND((No_Of_Runs * Channel_Weightage) / 100, 0) 
					ELSE No_Of_Runs 
				END  
			AS INT) AS 'Total_Runs',	
			CAST(temp.Row_Num AS VARCHAR) AS Episode_Number, 0 [Min_Plays], 0 [Max_Plays],
			* INTO #TempData FROM 
			(
				SELECT DISTINCT AD.Acq_Deal_Code, ADRun.Acq_Deal_Run_Code, T.Title_Code, CH.Channel_Code, ADRun.Run_Type, ADR.Actual_Right_Start_Date [Start_Date], 
				CASE ADR.Right_Type WHEN 'U' THEN CAST('31 Dec 9999' AS DATETIME) ELSE ADR.Actual_Right_End_Date END AS [End_Date], 
				RR.Right_Rule_Code, T.Duration_In_Min, T.Title_Name, AD.Deal_Type_Code, ADRT.Episode_From, ADRT.Episode_To, ADRun.Is_Rule_Right,
				ADRun.Is_Channel_Definition_Rights, ADRun.Is_Yearwise_Definition, Run_Definition_Type, ADRC.Min_Runs, 
				CASE WHEN ADRun.Is_Yearwise_Definition = 'Y' THEN ADRYR.No_Of_Runs ELSE ADRun.No_Of_Runs END No_Of_Runs,
				CASE 
					WHEN ADRun.Is_Channel_Definition_Rights ='Y' AND ADRun.Run_Type <> 'U' AND ISNULL(ADRun.No_Of_Runs,0) <> 0 
					THEN CASE WHEN ADRun.No_Of_Runs = 0 THEN 0 ELSE CAST(((ISNULL(ADRC.Min_Runs, 0) * 100) / ISNULL(ADRun.No_Of_Runs, 0)) AS NUMERIC(6, 3)) END
					ELSE 0 
				END 'Channel_Weightage',
				CASE 
					WHEN ADRun.Is_Channel_Definition_Rights ='Y' AND ADRun.Is_Yearwise_Definition = 'Y' AND ADRun.Run_Type <> 'U' AND ISNULL(ADRun.No_Of_Runs,0) <> 0 
					THEN CASE WHEN ISNULL(ADRun.No_Of_Runs,0) = 0 THEN 0 
					ELSE ((ISNULL(ADRC.Min_Runs,0) * ISNULL(CAST(ADRYR.No_Of_Runs AS DECIMAL),0)) / CAST(ADRun.No_Of_Runs AS NUMERIC(6,3))) 
					END 
				END 'Channel_Weightage_YearWise',
				CASE 
					WHEN ADRun.Is_Yearwise_Definition  = 'Y' AND ADRun.Run_Type <> 'U' AND ISNULL(ADRun.No_Of_Runs,0) <> 0 
					THEN CAST(((ADRYR.No_of_Runs * 100) / ISNULL(ADRun.No_Of_Runs, 0)) AS INT) ELSE 0 
				END 'Year_Weightage', 
				NULL [Utilised_Run],
				CASE WHEN ADRYR.Acq_Deal_Run_Yearwise_Run_Code IS NULL THEN ADR.Actual_Right_Start_Date ELSE ADRYR.Start_Date END Right_Start_Date,
				CASE 
					WHEN ADRYR.Acq_Deal_Run_Yearwise_Run_Code IS NULL THEN  
					CASE ADR.Right_Type WHEN 'U' THEN CAST('31 Dec 9999' AS DATETIME) ELSE ADR.Actual_Right_End_Date END
					ELSE ADRYR.End_Date 
				END Right_End_Date, 
				ADM.Acq_Deal_Movie_Code, ADRun.Prime_Start_Time, ADRun.Prime_End_Time, ADRun.Off_Prime_Start_Time,ADRun.Off_Prime_End_Time,
				CASE 
					WHEN ADRun.Run_Type = 'U' OR ISNULL(ADRun.No_Of_Runs,0) = 0  THEN 0 ELSE 
					Case When Is_Yearwise_Definition <> 'Y' Then round((ISNULL(ADRC.Min_Runs,0) * ISNULL(ADRUN.Prime_Run,0)) / ISNULL(ADRun.No_Of_Runs, 0), 0)  
					ELSE CASE WHEN Run_Definition_Type = 'S' Then ROUND((ISNULL(ADRYR.No_Of_Runs, 0) * CAST(ADRUN.Prime_Run As Decimal(12,4)) / ADRun.No_Of_Runs) , 0)
					Else ROUND((ISNULL(ADRYR.No_Of_Runs, 0) * Cast(ADRUN.Prime_Run As Decimal(12,4)) / ADRun.No_Of_Runs)  * ADRC.Min_Runs /  ADRun.No_Of_Runs, 0)  
					End End 
				END   AS 'Prime_Run',
				CASE WHEN ADRun.Run_Type = 'U' OR ISNULL(ADRun.No_Of_Runs,0) = 0 THEN 0 ELSE
					CASE WHEN Is_Yearwise_Definition <> 'Y' Then ROUND((ISNULL(ADRC.Min_Runs,0) * ISNULL(ADRUN.Off_Prime_Run,0)) / ISNULL(ADRun.No_Of_Runs, 0), 0)
					ELSE CASE WHEN Run_Definition_Type = 'S' Then ROUND((ISNULL(ADRYR.No_Of_Runs, 0) * CAST(ADRUN.Off_Prime_Run As Decimal(12,4)) / ADRun.No_Of_Runs) , 0)
					ELSE ROUND((ISNULL(ADRYR.No_Of_Runs, 0) * CAST(ADRUN.Off_Prime_Run As Decimal(12,4)) / ADRun.No_Of_Runs)  * ADRC.Min_Runs /  ADRun.No_Of_Runs, 0)  
					END 
				END END   AS 'Off_Prime_Run',
				ADRun.Time_Lag_Simulcast
				FROM Acq_Deal AD 
				INNER JOIN Acq_Deal_Movie ADM ON ADM.Acq_Deal_Code=AD.Acq_Deal_Code AND AD.Is_Master_Deal = 'Y'
				INNER JOIN Title_Content_Mapping TCM ON TCM.Acq_Deal_Movie_Code=ADM.Acq_Deal_Movie_Code
				INNER JOIN Title T ON ADM.Title_Code = T.Title_Code
				INNER JOIN Acq_Deal_Rights ADR ON AD.Acq_Deal_Code = ADR.Acq_Deal_Code AND ADR.Actual_Right_Start_Date IS NOT NULL
				INNER JOIN Acq_Deal_Rights_Title ADRTitle ON ADM.Title_Code= ADRTitle.Title_code AND ADR.Acq_Deal_Rights_Code = ADRTitle.Acq_Deal_Rights_Code
				AND ADRTitle.Episode_From = ADM.Episode_Starts_From AND ADRTitle.Episode_To = ADM.Episode_End_To
				INNER JOIN Language Lang ON T.Title_Language_Code = Lang.Language_Code
				INNER JOIN Acq_Deal_Run ADRun ON AD.Acq_Deal_Code =  ADRun.Acq_Deal_Code AND ADRun.Is_Channel_Definition_Rights = 'Y'
				INNER JOIN Acq_Deal_Run_Title ADRT ON ADRun.Acq_Deal_Run_Code = ADRT.Acq_Deal_Run_Code AND ADRT.Title_Code = T.Title_Code
				AND ADRTitle.Episode_From = ADRT.Episode_From AND ADRTitle.Episode_To = ADRT.Episode_To
				AND ADM.Episode_Starts_From = ADRT.Episode_From AND ADM.Episode_End_To = ADRT.Episode_To
				LEFT JOIN Right_Rule RR ON ADRun.Right_Rule_Code = RR.Right_Rule_Code
				LEFT JOIN Acq_Deal_Run_Channel ADRC ON ADRun.Acq_Deal_Run_Code = ADRC.Acq_Deal_Run_Code
				LEFT JOIN Channel CH ON ADRC.Channel_Code = CH.Channel_Code
				LEFT JOIN Acq_Deal_Run_Yearwise_Run ADRYR ON ADRun.Acq_Deal_Run_Code = ADRYR.Acq_Deal_Run_Code AND ADRun.Is_Yearwise_Definition = 'Y'
				WHERE 1=1 AND  AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND  AD.Acq_Deal_Code = @Acq_Deal_Code
			) AS TBL
			INNER JOIN #TempDummy temp ON temp.Row_Num between TBL.Episode_From AND TBL.Episode_To
				
			DROP TABLE #TempDummy
			--select * from #TempData
			UPDATE #TempData SET Start_Date = (SELECT Min(Start_Date) FROM #TempData), End_Date = (SELECT Max(End_Date) FROM #TempData)
			SELECT DISTINCT TD.Acq_Deal_Code
			,TD.Acq_Deal_Run_Code
			,TC.Title_Content_Code
			,TD.Title_Code
			,TD.Channel_Code
			,TD.Run_Type
			,TD.Right_Start_Date
			,TD.Right_End_Date
			,TD.Right_Rule_Code
			,TD.Total_Runs AS Defined_Runs
			,TD.Prime_Start_Time,TD.Prime_End_Time
			,TD.Off_Prime_Start_Time,TD.Off_Prime_End_Time
			,TD.Prime_Run,TD.Off_Prime_Run
			,TD.Run_Definition_Type
			,TD.Time_Lag_Simulcast
			,GETDATE() AS Inserted_On,'P' AS Record_Status
			INTO #TempData_New
			from #TempData TD
			INNER JOIN Title_Content_Mapping TCM ON TCM.Acq_Deal_Movie_Code=TD.Acq_Deal_Movie_Code
			INNER JOIN Title_Content TC ON TC.Title_Content_Code = TCM.Title_Content_Code AND TC.Episode_No=TD.Episode_Number

	
			SELECT DISTINCT TD.Acq_Deal_Code
			,TD.Acq_Deal_Run_Code
			,TC.Title_Content_Code
			,TD.Title_Code
			,TD.Channel_Code
			,TD.Run_Type
			,TD.Right_Start_Date
			,TD.Right_End_Date
			,TD.Right_Rule_Code
			,TD.Total_Runs AS Defined_Runs
			,TD.Prime_Start_Time,TD.Prime_End_Time
			,TD.Off_Prime_Start_Time,TD.Off_Prime_End_Time
			,TD.Prime_Run,TD.Off_Prime_Run
			,TD.Run_Definition_Type
			,TD.Time_Lag_Simulcast
			,GETDATE() AS Inserted_On,'P' AS Record_Status
			INTO #TempData_Final
			from #TempData TD
			INNER JOIN Title_Content_Mapping TCM ON TCM.Acq_Deal_Movie_Code=TD.Acq_Deal_Movie_Code
			INNER JOIN Title_Content TC ON TC.Title_Content_Code = TCM.Title_Content_Code AND TC.Episode_No=TD.Episode_Number

			--Select * from #TempData_New

			--select 'Update',CCR.Defined_Runs,ISNULL(TDN.Defined_Runs,0), CCR.Prime_Runs, ISNULL(TDN.Prime_Run,0), 
			--	CCR.OffPrime_Runs, ISNULL(TDN.Off_Prime_Run,0), CCR.Is_Archive,'N', CCR.Right_Rule_Code, ISNULL(TDN.Right_Rule_Code,0),
			--	ISNULL(CCR.Time_Lag_Simulcast,'00:00:00.0000000') , ISNULL(TDN.Time_Lag_Simulcast,'00:00:00.0000000')
			--	FROM Content_Channel_Run CCR
			--	INNER JOIN #TempData_New TDN 
			--	ON TDN.Acq_Deal_Code = CCR.Acq_Deal_Code AND TDN.Acq_Deal_Run_Code = CCR.Acq_Deal_Run_Code AND TDN.Title_Content_Code = CCR.Title_Content_Code 
			--	AND TDN.Right_Start_Date = CCR.Rights_Start_Date AND TDN.Right_End_Date = CCR.Rights_End_Date AND TDN.Channel_Code = CCR.Channel_Code
			--	AND (ISNULL(CCR.Defined_Runs,0) != ISNULL(TDN.Defined_Runs,0) --OR ISNULL(CCR.Prime_Runs,0) != ISNULL(TDN.Prime_Run,0) 
			--	OR ISNULL(CCR.OffPrime_Runs,0) != ISNULL(TDN.Off_Prime_Run,0) OR  ISNULL(CCR.Right_Rule_Code,0) != ISNULL(TDN.Right_Rule_Code,0)
			--	OR ISNULL(CCR.Time_Lag_Simulcast,'00:00:00.0000000') <> ISNULL(TDN.Time_Lag_Simulcast,'00:00:00.0000000')
			--	OR ISNULL(CCR.Prime_Start_Time,'00:00:00.0000000') <>  ISNULL(TDN.Prime_Start_Time,'00:00:00.0000000')
			--	OR ISNULL(CCR.OffPrime_Start_Time,'00:00:00.0000000') <> ISNULL(TDN.Off_Prime_Start_Time,'00:00:00.0000000')
			--	OR ISNULL(CCR.Prime_End_Time,'00:00:00.0000000') <> ISNULL(TDN.Prime_End_Time,'00:00:00.0000000')
			--	OR ISNULL(CCR.OffPrime_End_Time,'00:00:00.0000000') <> ISNULL(TDN.Off_Prime_End_Time,'00:00:00.0000000')
			--	)

			--Update Changed Defined Runs , Prime Runs , Off Prime Runs in Content_Channel_Run Table

			UPDATE CCR SET CCR.Defined_Runs=ISNULL(TDN.Defined_Runs,0), CCR.Updated_On=GETDATE(), CCR.Prime_Runs=ISNULL(TDN.Prime_Run,0), 
			CCR.OffPrime_Runs=ISNULL(TDN.Off_Prime_Run,0), CCR.Is_Archive='N', CCR.Right_Rule_Code=TDN.Right_Rule_Code
			, CCR.Time_Lag_Simulcast = TDN.Time_Lag_Simulcast
			, CCR.Prime_Start_Time = TDN.Prime_Start_Time
			, CCR.OffPrime_Start_Time = TDN.Off_Prime_Start_Time
			, CCR.Prime_End_Time = TDN.Prime_End_Time
			, CCR.OffPrime_End_Time = TDN.Off_Prime_End_Time
			, CCR.Run_Def_Type = ISNULL(TDN.Run_Definition_Type,'')
			--select CCR.Defined_Runs,TDN.Defined_Runs,*
			FROM Content_Channel_Run CCR
			INNER JOIN #TempData_New TDN 
			ON TDN.Acq_Deal_Code = CCR.Acq_Deal_Code AND TDN.Acq_Deal_Run_Code = CCR.Acq_Deal_Run_Code AND TDN.Title_Content_Code = CCR.Title_Content_Code 
			AND TDN.Right_Start_Date = CCR.Rights_Start_Date AND TDN.Right_End_Date = CCR.Rights_End_Date AND TDN.Channel_Code = CCR.Channel_Code
			AND (ISNULL(CCR.Defined_Runs,0) <> ISNULL(TDN.Defined_Runs,0) OR ISNULL(CCR.Prime_Runs,0) <> ISNULL(TDN.Prime_Run,0) 
			OR ISNULL(CCR.OffPrime_Runs,0) <> ISNULL(TDN.Off_Prime_Run,0) OR  ISNULL(CCR.Right_Rule_Code,0) <> ISNULL(TDN.Right_Rule_Code,0)
			OR ISNULL(CCR.Time_Lag_Simulcast,'00:00:00.0000000') <> ISNULL(TDN.Time_Lag_Simulcast,'00:00:00.0000000')
			OR ISNULL(CCR.Prime_Start_Time,'00:00:00.0000000') <>  ISNULL(TDN.Prime_Start_Time,'00:00:00.0000000')
			OR ISNULL(CCR.OffPrime_Start_Time,'00:00:00.0000000') <> ISNULL(TDN.Off_Prime_Start_Time,'00:00:00.0000000')
			OR ISNULL(CCR.Prime_End_Time,'00:00:00.0000000') <> ISNULL(TDN.Prime_End_Time,'00:00:00.0000000')
			OR ISNULL(CCR.OffPrime_End_Time,'00:00:00.0000000') <> ISNULL(TDN.Off_Prime_End_Time,'00:00:00.0000000')
			OR ISNULL(CCR.Run_Def_Type,'') <> ISNULL(TDN.Run_Definition_Type,'')
			) AND Is_Archive='N'

				

			--Delete existing Records in Content_Channel_Run from #TempData_New 

			SELECT * INTO #Temp_Content_Channel_Run
			FROM Content_Channel_Run WHERE Acq_Deal_Code=@Acq_Deal_Code AND Is_Archive='N'

			--select 'delete',
			--TCR.Title_Content_Code , TN.Title_Content_Code
			--, TCR.Rights_Start_Date , TN.Right_Start_Date , TCR.Rights_End_Date , TN.Right_End_Date , TCR.Channel_Code , TN.Channel_Code
			--, ISNULL(TCR.Defined_Runs,0) , ISNULL(TN.Defined_Runs,0) , ISNULL(TCR.Prime_Runs,0) ,ISNULL( TN.Prime_Run,0)
			-- , ISNULL(TCR.OffPrime_Runs,0) , ISNULL(TN.Off_Prime_Run,0) , ISNULL(TCR.Right_Rule_Code,0) , ISNULL(TN.Right_Rule_Code,0)
			-- ,ISNULL(TCR.Time_Lag_Simulcast,'00:00:00.0000000') , ISNULL(TN.Time_Lag_Simulcast,'00:00:00.0000000')
			-- ,ISNULL(TCR.Prime_Start_Time,'00:00:00.0000000') ,  ISNULL(TN.Prime_Start_Time,'00:00:00.0000000')
			-- ,ISNULL(TCR.OffPrime_Start_Time,'00:00:00.0000000') , ISNULL(TN.Off_Prime_Start_Time,'00:00:00.0000000')
			-- ,ISNULL(TCR.Prime_End_Time,'00:00:00.0000000') , ISNULL(TN.Prime_End_Time,'00:00:00.0000000')
			-- ,ISNULL(TCR.OffPrime_End_Time,'00:00:00.0000000') , ISNULL(TN.Off_Prime_End_Time,'00:00:00.0000000')

			-- FROM #TempData_New TN
			--INNER JOIN #Temp_Content_Channel_Run TCR 
			--ON TCR.Acq_Deal_Code = TN.Acq_Deal_Code AND TCR.Acq_Deal_Run_Code = TN.Acq_Deal_Run_Code AND TCR.Title_Content_Code = TN.Title_Content_Code
			--AND TCR.Rights_Start_Date = TN.Right_Start_Date AND TCR.Rights_End_Date = TN.Right_End_Date AND TCR.Channel_Code = TN.Channel_Code
			--AND ISNULL(TCR.Defined_Runs,0) = ISNULL(TN.Defined_Runs,0) AND ISNULL(TCR.Prime_Runs,0) =ISNULL( TN.Prime_Run,0)
			--AND ISNULL(TCR.OffPrime_Runs,0) = ISNULL(TN.Off_Prime_Run,0) AND ISNULL(TCR.Right_Rule_Code,0) = ISNULL(TN.Right_Rule_Code,0)
			--AND ISNULL(TCR.Time_Lag_Simulcast,'00:00:00.0000000') = ISNULL(TN.Time_Lag_Simulcast,'00:00:00.0000000')
			--AND ISNULL(TCR.Prime_Start_Time,'00:00:00.0000000') =  ISNULL(TN.Prime_Start_Time,'00:00:00.0000000')
			--AND ISNULL(TCR.OffPrime_Start_Time,'00:00:00.0000000') = ISNULL(TN.Off_Prime_Start_Time,'00:00:00.0000000')
			--AND ISNULL(TCR.Prime_End_Time,'00:00:00.0000000') = ISNULL(TN.Prime_End_Time,'00:00:00.0000000')
			--AND ISNULL(TCR.OffPrime_End_Time,'00:00:00.0000000') = ISNULL(TN.Off_Prime_End_Time,'00:00:00.0000000')
			--AND ISNULL(TCR.Run_Def_Type,'') = ISNULL(TN.Run_Definition_Type,'')

			--select * from #TempData_New
			
			DELETE TN FROM #TempData_New TN
			INNER JOIN #Temp_Content_Channel_Run TCR 
			ON TCR.Acq_Deal_Code = TN.Acq_Deal_Code AND TCR.Acq_Deal_Run_Code = TN.Acq_Deal_Run_Code AND TCR.Title_Content_Code = TN.Title_Content_Code
			AND TCR.Rights_Start_Date = TN.Right_Start_Date AND TCR.Rights_End_Date = TN.Right_End_Date AND TCR.Channel_Code = TN.Channel_Code
			AND ISNULL(TCR.Defined_Runs,0) = ISNULL(TN.Defined_Runs,0) AND ISNULL(TCR.Prime_Runs,0) =ISNULL( TN.Prime_Run,0)
			AND ISNULL(TCR.OffPrime_Runs,0) = ISNULL(TN.Off_Prime_Run,0) AND ISNULL(TCR.Right_Rule_Code,0) = ISNULL(TN.Right_Rule_Code,0)
			AND ISNULL(TCR.Time_Lag_Simulcast,'00:00:00.0000000') = ISNULL(TN.Time_Lag_Simulcast,'00:00:00.0000000')
			AND ISNULL(TCR.Prime_Start_Time,'00:00:00.0000000') =  ISNULL(TN.Prime_Start_Time,'00:00:00.0000000')
			AND ISNULL(TCR.OffPrime_Start_Time,'00:00:00.0000000') = ISNULL(TN.Off_Prime_Start_Time,'00:00:00.0000000')
			AND ISNULL(TCR.Prime_End_Time,'00:00:00.0000000') = ISNULL(TN.Prime_End_Time,'00:00:00.0000000')
			AND ISNULL(TCR.OffPrime_End_Time,'00:00:00.0000000') = ISNULL(TN.Off_Prime_End_Time,'00:00:00.0000000')
			AND ISNULL(TCR.Run_Def_Type,'') = ISNULL(TN.Run_Definition_Type,'')
			--select * from #TempData_New
			--SET Is_Archive for Deleted Run Definition
			--select * FROM Content_Channel_Run CCR 
			--LEFT JOIN Acq_Deal_Run_Channel ADRC ON ADRC.Acq_Deal_Run_Code = CCR.Acq_Deal_Run_Code AND ADRC.Channel_Code = CCR.Channel_Code 
			--where  CCR.Acq_Deal_Code=@Acq_Deal_Code AND ADRC.Acq_Deal_Run_Code IS NULL

			UPDATE CCR SET CCR.Is_Archive='Y' FROM Content_Channel_Run CCR 
			LEFT JOIN Acq_Deal_Run_Channel ADRC ON ADRC.Acq_Deal_Run_Code = CCR.Acq_Deal_Run_Code AND ADRC.Channel_Code = CCR.Channel_Code 
			where  CCR.Acq_Deal_Code=@Acq_Deal_Code AND ADRC.Acq_Deal_Run_Code IS NULL

			--Insert New Run Definitions
			INSERT INTO Content_Channel_Run(Acq_Deal_Code, Acq_Deal_Run_Code, Title_Content_Code, Title_Code, Channel_Code, Run_Type, Rights_Start_Date, Rights_End_Date,
			Right_Rule_Code, Defined_Runs, Prime_Start_Time, Prime_End_Time, OffPrime_Start_Time, OffPrime_End_Time, Prime_Runs, OffPrime_Runs, Inserted_On,
			Record_Status, Time_Lag_Simulcast, Is_Archive, Run_Def_Type)	
			SELECT DISTINCT Acq_Deal_Code,Acq_Deal_Run_Code,Title_Content_Code,	Title_Code,Channel_Code,Run_Type,Right_Start_Date,Right_End_Date
			,Right_Rule_Code,Defined_Runs,Prime_Start_Time,Prime_End_Time,Off_Prime_Start_Time,Off_Prime_End_Time,Prime_Run,Off_Prime_Run,Inserted_On,
			Record_Status, Time_Lag_Simulcast,'N', Run_Definition_Type FROM #TempData_New

			--select * from #TempData_Final

			--select *  FROM Content_Channel_Run CCR 
			--LEFT JOIN #TempData_Final ADRC ON ADRC.Acq_Deal_Run_Code = CCR.Acq_Deal_Run_Code AND ADRC.Channel_Code = CCR.Channel_Code 
			--AND ADRC.Right_Start_Date = CCR.Rights_Start_Date AND ADRC.Right_End_Date = CCR.Rights_End_Date
			--where  CCR.Acq_Deal_Code=3181 AND ADRC.Acq_Deal_Run_Code IS NULL
			
			UPDATE CCR SET CCR.Is_Archive='Y' FROM Content_Channel_Run CCR 
			LEFT JOIN #TempData_Final ADRC ON ADRC.Acq_Deal_Run_Code = CCR.Acq_Deal_Run_Code AND ADRC.Channel_Code = CCR.Channel_Code 
			AND ADRC.Right_Start_Date = CCR.Rights_Start_Date AND ADRC.Right_End_Date = CCR.Rights_End_Date
			where  CCR.Acq_Deal_Code=@Acq_Deal_Code AND ADRC.Acq_Deal_Run_Code IS NULL
				
	END TRY			
	BEGIN CATCH				
		DECLARE @ErSeverity INT,@ErState INT 		
		SET @Is_Error   = 'Y'       	
		SET @Error_Desc = 'Error_Desc : ' +  ERROR_MESSAGE() + ' ;ErrorNumber : ' + CAST(ERROR_NUMBER() AS VARCHAR)  + ' ;ERROR_Line: '  
							+ CAST(ERROR_Line() AS VARCHAR)+' Deal_Code: '  + CAST(@Acq_Deal_Code AS VARCHAR)
		RAISERROR (@Error_Desc,@ErSeverity,@ErState)
		PRINT @Error_Desc
	END CATCH
END