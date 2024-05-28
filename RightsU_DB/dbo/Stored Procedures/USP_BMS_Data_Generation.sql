CREATE PROCEDURE [dbo].[USP_BMS_Data_Generation] 
AS
BEGIN
	-- ==================================[BMS_Asset_Ref_Key]===========
	-- Author:		AdeshArote
	-- Create date: 08 Apr, 2024
	-- Description:	It will generate data that can be fetched through package and will be sent to BV
	-- =============================================

	SET NOCOUNT ON;	
	DECLARE @Deal_Code INT = 0
	IF NOT EXISTS(SELECT TOP 1 BMS_Process_Deals_Code FROM  BMS_Process_Deals WHERE Record_Status = 'W')
	BEGIN
		DECLARE CUS_Deal_Process CURSOR FOR 
		SELECT Acq_Deal_Code FROM BMS_Process_Deals WHERE Record_Status = 'P' ORDER BY BMS_Process_Deals_Code ASC
		OPEN CUS_Deal_Process
		FETCH NEXT FROM CUS_Deal_Process INTO @Deal_Code
		WHILE(@@FETCH_STATUS = 0)
		BEGIN

			BEGIN /********************************DELETE Temp Table if Exists ****************/
				
				IF OBJECT_ID('tempdb..#TempData') IS NOT NULL DROP TABLE #TempData
				IF OBJECT_ID('tempdb..#SharedRound') IS NOT NULL DROP TABLE #SharedRound
				IF OBJECT_ID('tempdb..#Dummy_TempData_New') IS NOT NULL DROP TABLE #Dummy_TempData_New
				IF OBJECT_ID('tempdb..#TempData_New') IS NOT NULL DROP TABLE #TempData_New
				IF OBJECT_ID('tempdb..#Temp_BMS_Deal_Content') IS NOT NULL DROP TABLE #Temp_BMS_Deal_Content
				IF OBJECT_ID('tempdb..#Temp_BMS_Deal_Content_Rights') IS NOT NULL DROP TABLE #Temp_BMS_Deal_Content_Rights
				IF OBJECT_ID('tempdb..#runCounter') IS NOT NULL DROP TABLE #runCounter
				IF OBJECT_ID('tempdb..#MatchDealRuns') IS NOT NULL DROP TABLE #MatchDealRuns
				IF OBJECT_ID('tempdb..#DiffRuns') IS NOT NULL DROP TABLE #DiffRuns
				IF OBJECT_ID('tempdb..#DiffRunsYear') IS NOT NULL DROP TABLE #DiffRunsYear
				IF OBJECT_ID('tempdb..#tblChannelUpdate') IS NOT NULL DROP TABLE #tblChannelUpdate
			
				CREATE TABLE #runCounter
				(
					CNT INT,
					RN INT,
					Acq_Deal_Run_Code INT,
					SD Datetime,
					ED Datetime,
					DiffCNT INT
				)

				CREATE TABLE #MatchDealRuns
				(
					RN_Code INT,
					Acq_Deal_Run_Code INT,
					SDate Datetime,
					EDate Datetime,
					Title_Code INT,
					Add_Or_Sub VARCHAR(1),
					DiffCNT INT
				)
				CREATE TABLE #tblChannelUpdate
				(
					Acq_Deal_Run_Code INT,
					Channel_Code INT,
					Title_Code INT,
					Changed_Runs INT
				)
				
				CREATE TABLE #Temp_BMS_Deal_Content
				(
					BMS_Deal_Content_Code INT,
					BMS_Deal_Code INT,
					BMS_Asset_Code INT,
					[Start_Date] DATETIME,
					End_Date DATETIME,
					Yearwise_No INT
				)

			END

			 /********************************Delcare Variables****************/

			DECLARE  @Is_Amendment CHAR(1)  = 'N',@BMS_Deal_Code INT = 0,@License_Fees DECIMAL = 0.0

			/********************************Set Amendment Flag****************/
			SELECT TOP 1 @Is_Amendment = CASE WHEN BV.Acq_Deal_Code > 0 THEN 'Y' ELSE 'N' END, @BMS_Deal_Code = BV.BMS_Deal_Code
			FROM BMS_Deal BV WHERE ISNULL(BV.Acq_Deal_Code,0) = @Deal_Code

			PRINT '1'
    
			SELECT T.N AS Row_Num INTO #TempDummy
			FROM  (
			  SELECT TOP(5000) ROW_NUMBER() OVER(ORDER BY 1/0)
			  FROM sys.all_objects AS o1, sys.all_objects AS o2
			) AS T(N)
	
			SELECT
				ROW_NUMBER() OVER(ORDER BY 1/0) as RN, 'N' AS Is_Update,
				CAST(
					CASE
						WHEN Run_Type = 'U' 
							THEN -1
						WHEN Is_Yearwise_Definition = 'Y' AND Is_Channel_Definition_Rights = 'Y' AND Run_Type <> 'U'
							THEN CASE WHEN Channel_Weightage_YearWise = 0 THEN 0 ELSE Channel_Weightage_YearWise END
						WHEN Is_Yearwise_Definition = 'Y' AND Is_Channel_Definition_Rights = 'N' AND Run_Type <> 'U'
							THEN CASE WHEN No_Of_Runs = 0 THEN 0 ELSE ROUND((No_Of_Runs * 100) / No_Of_Runs, 0)  END
						WHEN Is_Yearwise_Definition = 'N' AND Is_Channel_Definition_Rights = 'Y' AND Run_Type <> 'U' AND Run_Definition_Type NOT in ('S', 'N')
							THEN Min_Runs
						WHEN Is_Yearwise_Definition = 'N' AND Is_Channel_Definition_Rights = 'Y' AND Run_Type <> 'U' AND Run_Definition_Type in ('S', 'N')
							THEN ROUND((No_Of_Runs * Channel_Weightage) / 100, 0)
						ELSE No_Of_Runs END
					AS INT) AS 'Total_Runs',
				CAST(temp.Row_Num AS VARCHAR) AS Episode_Number, 0 [CurIden_BMS_Deal], 0 [CurIden_BMS_Deal_Content], 0 [CurIden_BMS_Deal_Content_Rights],
				0 [CurIden_BMS_Asset], 0 [Min_Plays], 0 [Max_Plays], * INTO #TempData 
			FROM (
				SELECT DISTINCT 
					RIGHT('0' + CONVERT(varchar,CAST([Duration_In_Min] AS INT) / 60),2) + ':' + right('0' + CONVERT(VARCHAR,CAST([Duration_In_Min] AS INT) % 60),2)	+ ':00.0000000' AS Duration_In_Min,
					SUBSTRING(T.Title_Name,0,79) AS Title_Name, T.Synopsis AS Synopsis, Lang.Language_Code RU_Language_Code, Lang.Ref_Language_Key,
					AD.Deal_Type_Code, ADRT.Episode_From, ADRT.Episode_To, CH.Channel_Code [RU_Channel_Code], CH.Ref_Station_Key [BMS_Station_Key],
					ADRun.Is_Rule_Right, RR.Right_Rule_Code [RU_Right_Rule_Code], RR.Ref_Right_Rule_Key [BMS_Right_Rule_Ref_Key], SAP_WBS.SAP_WBS_Code [SAP_WBS_Code], 
					SAP_WBS.BMS_Key [SAP_WBS_Ref_Key], NULL [BMS_Asset_Code], CAST(NULL AS VARCHAR(50)) [BMS_Asset_Ref_Key], 'PRO' [Asset_Type], 
					ADRun.Run_Type, ADRun.Acq_Deal_Run_Code, ADRun.Is_Channel_Definition_Rights, ADRun.Is_Yearwise_Definition, Run_Definition_Type, ADRC.Min_Runs,			
					CASE WHEN ADRun.Is_Yearwise_Definition = 'Y' THEN ADRYR.No_Of_Runs ELSE ADRun.No_Of_Runs END AS No_Of_Runs,
					CASE WHEN ADRun.Is_Channel_Definition_Rights ='Y' AND ADRun.Run_Type <> 'U'
						THEN CASE WHEN ADRun.No_Of_Runs = 0 THEN 0 ELSE CAST(((ISNULL(ADRC.Min_Runs, 0) * 100) / ISNULL(ADRun.No_Of_Runs, 0)) AS NUMERIC(6, 3)) END
						ELSE 0 
					END 'Channel_Weightage',
					CASE WHEN ADRun.Is_Channel_Definition_Rights ='Y' AND ADRun.Is_Yearwise_Definition = 'Y' AND ADRun.Run_Type <> 'U'
						THEN CASE WHEN ISNULL(ADRun.No_Of_Runs,0) = 0 THEN 0 ELSE ADRCYR.Defined_Runs
						END 
					END 'Channel_Weightage_YearWise',
					NULL [Utilised_Run],
					CASE WHEN ADRYR.Acq_Deal_Run_Yearwise_Run_Code IS NULL THEN ADR.Actual_Right_Start_Date ELSE ADRYR.Start_Date END Right_Start_Date,
					CASE WHEN ADRYR.Acq_Deal_Run_Yearwise_Run_Code IS NULL THEN 
						CASE
							WHEN ADR.Right_Type = 'U' 
							THEN CASE WHEN ADR.Actual_Right_End_Date IS NULL THEN CAST('31 Dec 9999' AS DATETIME) ELSE ADR.Actual_Right_End_Date END
							ELSE ADR.Actual_Right_End_Date 
						END
					ELSE ADRYR.End_Date END Right_End_Date,
					ADR.Actual_Right_Start_Date [Content_Start_Date], 
					CASE 
						WHEN ADR.Right_Type = 'U' THEN CASE WHEN ADR.Actual_Right_End_Date IS NULL THEN CAST('31 Dec 9999' AS DATETIME) ELSE ADR.Actual_Right_End_Date END
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
					CASE 
						WHEN ADR.Right_Type = 'U' 
						THEN CASE WHEN ADR.Actual_Right_End_Date IS NULL THEN CAST('31 Dec 9999' AS DATETIME) ELSE ADR.Actual_Right_End_Date END
						ELSE ADR.Actual_Right_End_Date 
					END [End_Date], 
					'1001' [Status_SLUId], '24001' [Type_SLUId], 
					AD.Agreement_Date [Acquisition_Date]
				FROM Acq_Deal AD 
				INNER JOIN Vendor V ON AD.Vendor_Code = V.Vendor_Code
				INNER JOIN Currency Cur ON AD.Currency_Code = Cur.Currency_Code
				INNER JOIN Entity E ON AD.Entity_Code = E.Entity_Code
				INNER JOIN Category Cat ON AD.Category_Code = Cat.Category_Code
				INNER JOIN Acq_Deal_Movie ADM ON AD.Acq_Deal_Code= ADM.Acq_Deal_Code
				INNER JOIN Title T ON ADM.Title_Code = T.Title_Code
				INNER JOIN Acq_Deal_Rights ADR ON AD.Acq_Deal_Code = ADR.Acq_Deal_Code AND ADR.Actual_Right_Start_Date IS NOT NULL
					--(
					--	ADR.Actual_Right_Start_Date IS NOT NULL --AND ADR.Actual_Right_End_Date IS NOT NULL
					--)
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
				--LEFT JOIN BMS_Asset BA ON T.Title_Code = BA.RU_Title_Code AND BA.Episode_No BETWEEN ADRT.Episode_From AND ADRT.Episode_To
				LEFT JOIN Acq_Deal_Run_Channel ADRC ON ADRun.Acq_Deal_Run_Code = ADRC.Acq_Deal_Run_Code
				LEFT JOIN Channel CH ON ADRC.Channel_Code = CH.Channel_Code
				LEFT JOIN Acq_Deal_Budget ADB ON AD.Acq_Deal_Code = ADB.Acq_Deal_Code AND ADB.Title_Code = ADM.Title_Code
				LEFT JOIN SAP_WBS ON ADB.SAP_WBS_Code = SAP_WBS.SAP_WBS_Code
				LEFT JOIN Acq_Deal_Run_Yearwise_Run ADRYR ON ADRun.Acq_Deal_Run_Code = ADRYR.Acq_Deal_Run_Code
				LEFT JOIN Acq_Deal_Run_ChannelYear_Run ADRCYR ON ADRun.Acq_Deal_Run_Code = ADRCYR.Acq_Deal_Run_Code AND ADRYR.Start_Date = ADRCYR.Start_Date
				AND ADRYR.End_Date = ADRCYR.End_Date AND ADRC.Channel_Code = ADRCYR.Channel_Code
				WHERE 1=1 AND AD.Acq_Deal_Code = @Deal_Code 
			) AS TBL
			INNER JOIN #TempDummy temp ON temp.Row_Num between TBL.Episode_From AND TBL.Episode_To
			--Where Cast(TBL.Content_End_Date As Date) > Cast(GETDATE() As Date)
			PRINT '2'
			DROP TABLE #TempDummy

			UPDATE #TempData SET Start_Date = (SELECT Min(Start_Date) FROM #TempData), End_Date = (SELECT Max(End_Date) FROM #TempData)
	
			UPDATE temp SET temp.BMS_Asset_Ref_Key = BA.BMS_Asset_Ref_Key			
			FROM #TempData temp 
			INNER JOIN BMS_Asset BA ON BA.RU_Title_Code = temp.RU_Title_Code 					
			AND ISNULL(BA.Episode_Number, 0) = ISNULL(temp.Episode_Number, 0)

			PRINT '3'
			/******** For shared & NA type definition *********************************************************************/
			SELECT No_Of_Runs AS TotalRuns, Acq_Deal_Run_Code,Right_Start_date 
			INTO #SharedRound
			FROM #TempData
				WHERE Run_Definition_Type IN ('S', 'N') AND No_Of_Runs > 0
			GROUP BY Acq_Deal_Run_Code, No_Of_Runs, RU_Channel_Code,Right_Start_Date

			/******** Update Total Runs and Content Start and End Date *********************************************************************/
			UPDATE temp SET  temp.Total_Runs = shared.TotalRuns, Max_Plays=shared.TotalRuns
			FROM #TempData temp 
			INNER JOIN #SharedRound shared ON temp.Acq_Deal_Run_Code = shared.Acq_Deal_Run_Code AND temp.Right_Start_date=shared.Right_Start_date		

			UPDATE TD SET TD.Content_Start_Date = TEMP.CONTENT_START_DATE, TD.Content_End_Date = TEMP.Content_End_Date
			FROM #TEMPDATA TD
			INNER JOIN 
			(
				SELECT MIN(CONTENT_START_DATE) AS CONTENT_START_DATE,MAX(Content_End_Date) AS Content_End_Date,RU_TITLE_CODE,Episode_From,Episode_To 
				FROM #TEMPDATA GROUP BY RU_TITLE_CODE,Episode_From,Episode_To
			) TEMP
			ON TD.RU_TITLE_CODE = TEMP.RU_TITLE_CODE AND TD.Episode_From =TEMP.Episode_From AND TD.Episode_To =TEMP.Episode_To 
				AND ISNULL(TD.Is_Yearwise_Definition,'N') = 'N'
	
			--DELETE FROM #TEMPDATA WHERE CAST(Content_End_Date AS DATE) < CAST(GETDATE() AS DATE)

			/********************************Calculate License_Fees****************/
			SELECT @License_Fees = SUM(Deal_Cost) FROM Acq_Deal_Cost WHERE Acq_Deal_Code = @Deal_Code

			PRINT '4'
			BEGIN TRY
				BEGIN TRAN	
				
				UPDATE BMS_Process_Deals SET Record_Status = 'W',Process_Start=GETDATE()  WHERE Acq_Deal_Code = @Deal_Code							
				
				IF(@Is_Amendment = 'N')
				BEGIN

					INSERT INTO BMS_Deal (
						Acq_Deal_Code, BMS_Deal_Ref_Key, Is_Archived, RU_Licensor_Code, RU_Payee_Code, RU_Currency_Code, RU_Licensee_Code,
						RU_Category_Code, BMS_Licensor_Code, BMS_Payee_Code, BMS_Currency_Code, BMS_Licensee_Code, BMS_Category_Code,
						License_Fees, 
						[Description], Contact, Lic_Ref_No, Revision, [Start_Date], [End_Date], Status_SLUId, Type_SLUId,
						Acquisition_Date, Record_Status, Inserted_ON, Created_On, Updated_On, Is_Active)
					SELECT 
						DISTINCT 
							Acq_Deal_Code, BMS_Deal_Ref_Key, Is_Archived, [RU_Licensor_Code], [RU_Payee_Code], [RU_Currency_Code], [RU_Licensee_Code], 
							[RU_Category_Code], [BMS_Licensor_Code], [BMS_Payee_Code], [BMS_Currency_Code], [BMS_Licensee_Code], [BMS_Category_Code], 
							@License_Fees [License_Fees],
							[Description], [Contact], Agreement_No, [Revision], [Start_Date], [End_Date], [Status_SLUId], [Type_SLUId], 
							[Acquisition_Date], 'P', GETDATE(), GETDATE(), GETDATE(), 'Y'
					FROM #TempData
			
					UPDATE #TempData SET CurIden_BMS_Deal = (SELECT SCOPE_IDENTITY())
					PRINT '5'
				
				END
				ELSE
				BEGIN

					UPDATE #TempData SET CurIden_BMS_Deal = @BMS_Deal_Code

					IF NOT EXISTS (
						SELECT TOP 1 BD.BMS_Deal_Code 
						FROM BMS_Deal BD
						INNER JOIN #TempData TD ON BD.Acq_Deal_Code = TD.Acq_Deal_Code
						AND BD.RU_Category_Code = TD.RU_Category_Code AND BD.RU_Currency_Code = TD.RU_Currency_Code
						AND BD.RU_Licensee_Code = TD.RU_Licensee_Code AND BD.RU_Licensor_Code = TD.RU_Licensor_Code
						AND ISNULL(BD.RU_Payee_Code,0) = ISNULL(TD.RU_Payee_Code,0) AND ISNULL(BD.License_Fees,0.0) = ISNULL(@License_Fees,0.0)
						AND BD.[Description] = TD.[Description] AND ISNULL(BD.[Contact],0)=ISNULL(TD.[Contact],0)
						AND ISNULL(BD.[Revision],0)=ISNULL(TD.[Revision],0) AND BD.[Start_Date]=TD.[Start_Date]
						AND BD.[End_Date]=TD.[End_Date] AND BD.[Status_SLUId]=TD.[Status_SLUId]
						AND BD.Type_SLUId=TD.Type_SLUId AND BD.Acquisition_Date=TD.Acquisition_Date
						WHERE BD.BMS_Deal_Code = @BMS_Deal_Code
					)
					BEGIN

						UPDATE BV SET BV.Acquisition_Date = TD.Acquisition_Date			
						, BV.RU_Licensor_Code = TD.RU_Licensor_Code, BV.RU_Payee_Code = TD.RU_Payee_Code
						, BV.RU_Currency_Code = TD.RU_Currency_Code, BV.RU_Licensee_Code = TD.RU_Licensee_Code
						, BV.RU_Category_Code = TD.RU_Category_Code, BV.BMS_Licensor_Code = TD.BMS_Licensor_Code			
						, BV.BMS_Payee_Code = TD.BMS_Payee_Code, BV.BMS_Currency_Code = TD.BMS_Currency_Code
						, BV.BMS_Licensee_Code = TD.BMS_Licensee_Code, BV.BMS_Category_Code = TD.BMS_Category_Code			
						, BV.License_Fees = @License_Fees, BV.[Description] = TD.[Description]
						, BV.[Contact] = TD.[Contact], BV.[Revision] = TD.[Revision]
						, BV.[Start_Date] = TD.[Start_Date], BV.[End_Date] = TD.[End_Date]
						, BV.[Status_SLUId] = TD.[Status_SLUId], BV.[Type_SLUId] = TD.[Type_SLUId]
						, Record_Status='P', Updated_On = GETDATE()
						FROM BMS_Deal BV
						INNER JOIN #TempData TD ON BV.Acq_Deal_Code = TD.Acq_Deal_Code
						WHERE BV.Acq_Deal_Code =@Deal_Code 
						AND BV.BMS_Deal_Code = @BMS_Deal_Code

					END
					PRINT '6'
				END	
				PRINT '7'
				/********************************BMS_Asset****************/					

				INSERT INTO BMS_Asset 
				(
					BMS_Asset_Ref_Key, Duration, RU_Title_Code, Title, Title_Listing, Language_Code, Ref_Language_Key, 
					RU_ProgramCategory_Code, 
					Ref_BMS_ProgramCategroy, 
					Episode_Title, 
					Episode_Season, Episode_Number, Synopsis, Is_Archived, Record_Status, Created_On, Updated_On, Is_Active
				)					
				SELECT DISTINCT [BMS_Asset_Ref_Key], [Duration_In_Min], [RU_Title_Code], [Title_Name], [Title_Name], [RU_Language_Code], [Ref_Language_Key], 
					(
						SELECT Columns_Value_Code FROM Map_Extended_Columns WHERE Columns_Code = 1 And Record_Code = temp.RU_Title_Code
					),
					(
						SELECT Ref_BMS_Code FROM [dbo].[Extended_Columns_Value] WHERE Columns_Value_Code In (
							SELECT Columns_Value_Code FROM Map_Extended_Columns WHERE Columns_Code = 1 And Record_Code = temp.RU_Title_Code
						)
					),
					CASE WHEN Deal_Type_Code IN (1,10,21,22,33,1034,1035) THEN NULL ELSE SUBSTRING([Title_Name],0,68) + ' Episode ' + CAST([Episode_Number] AS VARCHAR) END,
					NULL, [Episode_Number], [Synopsis], 'false', 'P', GETDATE(), GETDATE(), 'Y'
				FROM #TempData temp WHERE 1=1 AND temp.BMS_Asset_Ref_Key IS NULL
				AND (
					(
						ISNULL(temp.Deal_Type_Code,1) > 1 
						AND (
							temp.RU_Title_Code IN (
								SELECT RU_Title_Code FROM BMS_Asset BA
							) AND 
							CAST(temp.Episode_Number AS VARCHAR(100)) NOT IN (
								SELECT CAST(Episode_Number AS VARCHAR(100)) 
								FROM BMS_Asset BA WHERE BA.RU_Title_Code = temp.RU_Title_Code
							)
						)
					) OR
					temp.RU_Title_Code NOT IN (select RU_Title_Code FROM BMS_Asset BA ) --WHERE BA.RU_Title_Code = temp.RU_Title_Code)
				)
				
				PRINT '8'

				DECLARE @AssetPrefix VARCHAR(20) = '', @IsBMSOwner CHAR(1) = 'N'
				SET @AssetPrefix = (SELECT Parameter_Value FROM System_Parameter_New WHERE Parameter_Name='BMS_API_Asset_Prefix')
				SET @IsBMSOwner = (SELECT Parameter_Value FROM System_Parameter_New WHERE Parameter_Name='IsBMS_Schedule_Owner')
				
				UPDATE temp SET temp.CurIden_BMS_Asset = BA.BMS_Asset_Code
				FROM BMS_Asset BA
				INNER JOIN #TempData temp ON BA.RU_Title_Code = temp.RU_Title_Code AND ISNULL(BA.Episode_Number, 0) = ISNULL(temp.Episode_Number, 0)				
		
				IF(@IsBMSOwner = 'Y')
				BEGIN
					
					UPDATE BMS_Asset SET BMS_Asset_Ref_Key =  @AssetPrefix + CAST(BMS_Asset_Code AS VARCHAR) WHERE ISNULL(BMS_Asset_Ref_Key, '') = ''
					UPDATE #TempData SET BMS_Asset_Ref_Key =  @AssetPrefix + CAST(CurIden_BMS_Asset AS VARCHAR) WHERE ISNULL(BMS_Asset_Ref_Key, '') = ''

					UPDATE tc SET tc.Ref_BMS_Content_Code = ba.BMS_Asset_Ref_Key
					FROM BMS_Asset ba
					INNER JOIN Title_Content tc ON ba.RU_Title_Code = tc.Title_Code AND ISNULL(ba.Episode_Number, 0) = ISNULL(tc.Episode_No, 0)
					WHERE ba.BMS_Asset_Code IN (
						SELECT ISNULL(CurIden_BMS_Asset, 0) FROM #TempData
					)

				END

				UPDATE BA SET BA.Duration = [Duration_In_Min], BA.Title = temp.Title_Name, 
					BA.Title_Listing = temp.Title_Name, BA.Language_Code = temp.[RU_Language_Code], 
					BA.[Ref_Language_Key] = temp.Ref_Language_Key, BA.RU_ProgramCategory_Code = (
						SELECT Columns_Value_Code FROM Map_Extended_Columns WHERE Columns_Code = 1 And Record_Code = temp.RU_Title_Code
					), 
					Ref_BMS_ProgramCategroy = (
						SELECT TOP 1 Ref_BMS_Code FROM [dbo].[Extended_Columns_Value] WHERE Columns_Value_Code In (
							SELECT Columns_Value_Code FROM Map_Extended_Columns WHERE Columns_Code = 1 And Record_Code = temp.RU_Title_Code
						)
					), 
					BA.[Synopsis] = temp.[Synopsis], ba.Updated_On = GETDATE()
				FROM BMS_Asset BA
				INNER JOIN #TempData temp ON --BA.BMS_Deal_Code = temp.CurIden_BMS_Deal AND
					BA.RU_Title_Code = temp.RU_Title_Code AND ISNULL(BA.Episode_Number, 0) = ISNULL(temp.Episode_Number, 0)
					AND (
						BA.Title <> temp.Title_Name OR
						BA.Language_Code <> temp.RU_Language_Code OR
						BA.Synopsis <> temp.Synopsis OR
						BA.Duration  <> Duration_In_Min OR
						BA.RU_ProgramCategory_Code NOT IN(						
							SELECT ISNULL(Columns_Value_Code,0) FROM Map_Extended_Columns WHERE Columns_Code = 1 And Record_Code = temp.RU_Title_Code 
						)
					)
			
				/********************************Insert into new Temp Table****************/						
				PRINT '9'	
				SELECT DISTINCT Total_Runs, Episode_Number, CurIden_BMS_Deal, CurIden_BMS_Deal_Content, CurIden_BMS_Deal_Content_Rights
					, CurIden_BMS_Asset, Min_Plays, Max_Plays, Duration_In_Min, Title_Name
					, Synopsis,RU_Language_Code, Ref_Language_Key, Deal_Type_Code, Episode_From, Episode_To
					, RU_Channel_Code, BMS_Station_Key, Is_Rule_Right, RU_Right_Rule_Code
					, BMS_Right_Rule_Ref_Key, SAP_WBS_Code, SAP_WBS_Ref_Key, BMS_Asset_Code
					, BMS_Asset_Ref_Key, Asset_Type, Run_Type, Acq_Deal_Run_Code
					, Is_Channel_Definition_Rights, Is_Yearwise_Definition, Run_Definition_Type
					, Min_Runs, No_Of_Runs, Channel_Weightage, Channel_Weightage_YearWise, Utilised_Run
					, CASE WHEN Is_Yearwise_Definition = 'Y' THEN [Right_Start_Date] ELSE Content_Start_Date  END AS Right_Start_Date
					, CASE WHEN Is_Yearwise_Definition = 'Y' THEN Right_End_Date ELSE Content_End_Date  END AS Right_End_Date 						
					, Acq_Deal_Code, RU_Title_Code, BMS_Deal_Ref_Key, Is_Archived, RU_Licensor_Code, RU_Payee_Code, RU_Currency_Code
					, RU_Licensee_Code, RU_Category_Code, BMS_Licensor_Code, BMS_Payee_Code, BMS_Currency_Code
					, BMS_Licensee_Code, BMS_Category_Code, Description, Contact, Agreement_No, Revision, Status_SLUId
					, Type_SLUId,Acquisition_Date,Row_Num, Content_Start_Date 
					INTO #Dummy_TempData_New
				FROM #TempData

				SELECT ROW_NUMBER() OVER (Partition BY RU_Channel_Code, Content_Start_Date,CurIden_BMS_Asset ORDER BY RU_Channel_Code,Right_Start_Date,Right_End_Date) YearWise_No,
					   * INTO #TempData_New
				FROM #Dummy_TempData_New 
	
				DROP TABLE #TempData			
				DROP TABLE #Dummy_TempData_New						
		
		
				/********************************Deal_Content**********************************/						
				IF(@Is_Amendment = 'N')
				BEGIN

					INSERT INTO BMS_Deal_Content (BMS_Deal_Code, BMS_Deal_Ref_Key, BMS_Deal_Content_Ref_Key, BMS_Asset_Code, BMS_Asset_Ref_Key, 
						Asset_Type, Title, Start_Date, End_Date, Record_Status, Is_Archived, Created_On, Updated_On, Is_Active)
					SELECT DISTINCT CurIden_BMS_Deal, [BMS_Deal_Ref_Key], NULL [BMS_Deal_Content_Ref_Key], [CurIden_BMS_Asset], [BMS_Asset_Ref_Key],
						[Asset_Type], [Title_Name], NULL, NULL, 'P', 'false', GETDATE(), GETDATE(), 'Y'
					FROM #TempData_New
										
					UPDATE temp SET temp.CurIden_BMS_Deal_Content = BDC.BMS_Deal_Content_Code
					FROM BMS_Deal_Content BDC
					INNER JOIN #TempData_New temp ON temp.CurIden_BMS_Deal = BDC.BMS_Deal_Code
					AND BDC.BMS_Asset_Code = temp.CurIden_BMS_Asset	

				END
				ELSE
				BEGIN

					INSERT INTO #Temp_BMS_Deal_Content(BMS_Deal_Content_Code, BMS_Deal_Code, BMS_Asset_Code, [Start_Date], End_Date, Yearwise_No)
					SELECT DISTINCT BDC.BMS_Deal_Content_Code, BDC.BMS_Deal_Code, BDC.BMS_Asset_Code, NULL, NULL, 0
					FROM BMS_Deal_Content BDC WHERE BDC.BMS_Deal_Code = @BMS_Deal_Code
					
					UPDATE temp SET temp.CurIden_BMS_Deal_Content = BDC.BMS_Deal_Content_Code
					FROM #Temp_BMS_Deal_Content BDC
					INNER JOIN #TempData_New temp ON temp.CurIden_BMS_Deal = BDC.BMS_Deal_Code
					AND BDC.BMS_Asset_Code = temp.CurIden_BMS_Asset
	 
					UPDATE BDC SET BDC.[Start_Date] = NULL --TD.[Right_Start_Date]
						, BDC.End_Date = NULL--TD.[Right_End_Date],
						, Record_Status = 'P', BDC.Title = TD.[Title_Name], BMS_Asset_Code=TD.[CurIden_BMS_Asset]
						, BDC.BMS_Asset_Ref_Key= TD.[BMS_Asset_Ref_Key], BDC.Updated_On = GETDATE()
					FROM #TempData_New TD 
					INNER JOIN BMS_Deal_Content BDC ON BDC.BMS_Asset_Code = Td.CurIden_BMS_Asset
					INNER JOIN #Temp_BMS_Deal_Content TBDC ON TD.CurIden_BMS_Deal_Content = TBDC.BMS_Deal_Content_Code
					AND BDC.BMS_Deal_Code = @BMS_Deal_Code AND BDC.Title <> TD.[Title_Name]

					INSERT INTO BMS_Deal_Content (BMS_Deal_Code, BMS_Deal_Ref_Key, BMS_Deal_Content_Ref_Key, BMS_Asset_Code, BMS_Asset_Ref_Key, 
						Asset_Type, Title, Start_Date, End_Date, Record_Status, Is_Archived, Created_On, Updated_On, Is_Active)
					SELECT DISTINCT CurIden_BMS_Deal, [BMS_Deal_Ref_Key], NULL [BMS_Deal_Content_Ref_Key], [CurIden_BMS_Asset], [BMS_Asset_Ref_Key],
						[Asset_Type], [Title_Name], NULL, NULL, 'P', 'false', GETDATE(), GETDATE(), 'Y'
					FROM #TempData_New TD
					WHERE TD.CurIden_BMS_Deal_Content = 0 OR TD.CurIden_BMS_Deal_Content IS NULL

					TRUNCATE TABLE #Temp_BMS_Deal_Content

					INSERT INTO #Temp_BMS_Deal_Content(BMS_Deal_Content_Code, BMS_Deal_Code, BMS_Asset_Code, [Start_Date], End_Date, Yearwise_No)
					SELECT BDC.BMS_Deal_Content_Code, BDC.BMS_Deal_Code, BDC.BMS_Asset_Code, NULL, NULL, 0
					FROM BMS_Deal_Content BDC WHERE BDC.BMS_Deal_Code = @BMS_Deal_Code
					
					UPDATE temp SET temp.CurIden_BMS_Deal_Content = BDC.BMS_Deal_Content_Code
					FROM #Temp_BMS_Deal_Content BDC
					INNER JOIN #TempData_New temp ON temp.CurIden_BMS_Deal = BDC.BMS_Deal_Code
					AND BDC.BMS_Asset_Code = temp.CurIden_BMS_Asset

				END						
			
				/******************************** BMS_Deal_Content_Rights **********************************/						
				IF(@Is_Amendment = 'N')
				BEGIN

					PRINT 'Is_Amendment - No'
					INSERT INTO BMS_Deal_Content_Rights (BMS_Deal_Content_Code, BMS_Deal_Content_Ref_Key, RU_Channel_Code, BMS_Deal_Content_Rights_Ref_Key, 
						BMS_Station_Code, RU_Right_Rule_Code, BMS_Right_Rule_Ref_Key, SAP_WBS_Code, SAP_WBS_Ref_Key, 
						BMS_Asset_Code, BMS_Asset_Ref_Key, Asset_Type, Title, License_Fees, Total_Runs, Utilised_Run, Start_Date, End_Date, 
						Blackout_From_1, Blackout_To_1, Blackout_From_2, Blackout_To_2, Blackout_From_3, Blackout_To_3, YearWise_No, Record_Status,
						Min_Runs,
						Max_Runs,
						Acq_Deal_Run_Code, Is_Archived, Created_On, Updated_On, Is_Active
					)
					SELECT DISTINCT [CurIden_BMS_Deal_Content], NULL [BMS_Deal_Content_Ref_Key], [RU_Channel_Code], NULL [BMS_Deal_Content_Rights_Ref_Key],
						[BMS_Station_Key], [RU_Right_Rule_Code], [BMS_Right_Rule_Ref_Key], [SAP_WBS_Code], [SAP_WBS_Ref_Key],
						CurIden_BMS_Asset, [BMS_Asset_Ref_Key], [Asset_Type], [Title_Name], 0, [Total_Runs], [Utilised_Run], [Right_Start_Date], [Right_End_Date],
						NULL, NULL, NULL, NULL, NULL, NULL, YearWise_No, 'P',
						CASE WHEN Run_Definition_Type = 'S' OR Run_Definition_Type = 'N' THEN Min_Plays ELSE NULL END,--Run_Definition_Type
						CASE WHEN Run_Definition_Type = 'S' OR Run_Definition_Type = 'N' THEN Max_Plays ELSE NULL END,--Run_Definition_Type				
						Acq_Deal_Run_Code, 'false', GETDATE(), GETDATE(), 'Y'
					FROM #TempData_New

				END
				ELSE
				BEGIN		
					/*
					*** IMPORTANT NOTE ***
					By Prathesh Sir, on 06 Nov 2015
					While Amendment of deal no need to send DaysUsed (Utilised_Run), BV may have scheduled run so this should not be update in BV
					*/		
					SELECT BDCR.BMS_Deal_Content_Rights_Code, BDCR.BMS_Deal_Content_Code,BDCR.RU_Channel_Code,BDCR.BMS_Asset_Code, BDCR.YearWise_No,BDC.Is_Archived
					INTO #Temp_BMS_Deal_Content_Rights
					FROM BMS_Deal_Content_Rights BDCR
					INNER JOIN BMS_Deal_Content BDC ON BDCR.BMS_Deal_Content_Code = BDC.BMS_Deal_Content_Code AND BDC.BMS_Deal_Code = @BMS_Deal_Code							

					UPDATE temp SET temp.CurIden_BMS_Deal_Content_Rights = BDCR.BMS_Deal_Content_Rights_Code
					FROM #Temp_BMS_Deal_Content_Rights BDCR
					INNER JOIN #TempData_New temp ON BDCR.BMS_Deal_Content_Code = temp.CurIden_BMS_Deal_Content
													 AND BDCR.RU_Channel_Code = temp.RU_Channel_Code
													 AND BDCR.YearWise_No = temp.YearWise_No 
						
					
					UPDATE BDCR SET BDCR.RU_Right_Rule_Code = temp.RU_Right_Rule_Code, BDCR.BMS_Right_Rule_Ref_Key = temp.BMS_Right_Rule_Ref_Key,
									BDCR.SAP_WBS_Code = temp.SAP_WBS_Code, BDCR.SAP_WBS_Ref_Key = temp.SAP_WBS_Ref_Key,
									BDCR.Title = temp.Title_Name, BDCR.Total_Runs = temp.Total_Runs,
									BDCR.[Start_Date] = temp.Right_Start_Date, BDCR.End_Date = temp.Right_End_Date,
									BDCR.Record_Status = 'P', BDCR.Acq_Deal_Run_Code=temp.Acq_Deal_Run_Code,
									BDCR.Min_Runs = CASE WHEN Run_Definition_Type = 'S' OR Run_Definition_Type = 'N' THEN temp.Min_Plays ELSE NULL END,
									BDCR.Max_Runs = CASE WHEN Run_Definition_Type = 'S' OR Run_Definition_Type = 'N' THEN temp.Max_Plays ELSE NULL END,	
									BMS_Station_Code = temp.BMS_Station_Key, BDCR.Updated_On = GETDATE()
					FROM #TempData_New temp 
					INNER JOIN BMS_Deal_Content_Rights BDCR ON temp.RU_Channel_Code = BDCR.RU_Channel_Code 
					AND temp.CurIden_BMS_Deal_Content_Rights = BDCR.BMS_Deal_Content_Rights_Code
					AND (
						ISNULL(BDCR.RU_Right_Rule_Code,0) <> ISNULL(temp.RU_Right_Rule_Code,0) OR
						ISNULL(BDCR.SAP_WBS_Code,0) <> ISNULL(temp.SAP_WBS_Code,0) OR
						BDCR.Title <> temp.Title_Name OR
						ISNULL(BDCR.Total_Runs,0) <> ISNULL(temp.Total_Runs,0) OR
						ISNULL(CONVERT(VARCHAR,BDCR.[Start_Date],103),'') <> ISNULL(CONVERT(VARCHAR,temp.[Right_Start_Date]  ,103),'') OR
						ISNULL(CONVERT(VARCHAR,BDCR.End_Date,103),'') <> ISNULL(CONVERT(VARCHAR,temp.Right_End_Date  ,103),'') OR
						ISNULL(BDCR.Min_Runs,0) <> ISNULL(temp.Min_Plays,0) OR
						ISNULL(BDCR.Max_Runs,0) <> ISNULL(temp.Max_Plays,0)
					) 						
					
					INSERT INTO BMS_Deal_Content_Rights (BMS_Deal_Content_Code, BMS_Deal_Content_Ref_Key, RU_Channel_Code, BMS_Deal_Content_Rights_Ref_Key, 
						BMS_Station_Code, RU_Right_Rule_Code, BMS_Right_Rule_Ref_Key, SAP_WBS_Code, SAP_WBS_Ref_Key, 
						BMS_Asset_Code, BMS_Asset_Ref_Key, Asset_Type, Title, License_Fees, Total_Runs, Start_Date, End_Date, 
						Blackout_From_1, Blackout_To_1, Blackout_From_2, Blackout_To_2, Blackout_From_3, Blackout_To_3, YearWise_No, Record_Status,
						Min_Runs,
						Max_Runs,
						Acq_Deal_Run_Code, Is_Archived, Created_On, Updated_On, Is_Active
					)
					SELECT DISTINCT [CurIden_BMS_Deal_Content], NULL [BMS_Deal_Content_Ref_Key], TD.[RU_Channel_Code], NULL [BMS_Deal_Content_Rights_Ref_Key],
							[BMS_Station_Key], TD.[RU_Right_Rule_Code], TD.[BMS_Right_Rule_Ref_Key], TD.[SAP_WBS_Code], TD.[SAP_WBS_Ref_Key],
							CurIden_BMS_Asset, TD.[BMS_Asset_Ref_Key], TD.[Asset_Type], [Title_Name], 0, TD.[Total_Runs], [Right_Start_Date], [Right_End_Date],
							NULL, NULL, NULL, NULL, NULL, NULL,TD.YearWise_No, 'P',
							CASE WHEN Run_Definition_Type = 'S' OR Run_Definition_Type = 'N' THEN Min_Plays ELSE NULL END,--Run_Definition_Type
							CASE WHEN Run_Definition_Type = 'S' OR Run_Definition_Type = 'N' THEN Max_Plays ELSE NULL END,--Run_Definition_Type				
							Acq_Deal_Run_Code, 'false', GETDATE(), GETDATE(), 'Y'
					FROM #TempData_New TD 			
					WHERE 1 =1 
					AND (TD.CurIden_BMS_Deal_Content_Rights = 0 OR TD.CurIden_BMS_Deal_Content_Rights IS NULL) 

				END			
				
				UPDATE BDCR SET BDCR.BMS_Deal_Content_Ref_Key = BDC.BMS_Deal_Content_Ref_Key 
				FROM BMS_Deal_Content_Rights BDCR
				INNER JOIN BMS_Deal_Content BDC ON BDCR.BMS_Deal_Content_Code = BDC.BMS_Deal_Content_Code
				WHERE ISNULL(BDCR.BMS_Deal_Content_Ref_Key, 0) = 0
				AND ISNULL(BDC.BMS_Deal_Content_Ref_Key, 0) > 0

				/************************Set BMS_Deal_Content Is_Active Flag ***********************************************************/
				
				UPDATE BDC SET BDC.Is_Active='Y'
				FROM BMS_Deal_Content BDC
				WHERE BDC.BMS_Deal_Code = @BMS_Deal_Code 

				UPDATE BDC SET BDC.Is_Active = 'N'
				FROM BMS_Deal_Content BDC
				WHERE BDC.BMS_Deal_Code = @BMS_Deal_Code
				AND 
				(
					BDC.BMS_Asset_Code NOT IN (SELECT CurIden_BMS_Asset FROM #TempData_New) OR 
					(
						BDC.[Start_Date] NOT IN (
							SELECT TN.[Right_Start_Date] FROM #TempData_New TN WHERE TN.CurIden_BMS_Asset = BDC.BMS_Asset_Code
						)
						AND BDC.[End_Date] NOT IN (
							SELECT TN.[Right_End_Date] FROM #TempData_New TN WHERE TN.CurIden_BMS_Asset = BDC.BMS_Asset_Code
						)
					)
				)

				/************************Set BMS_Deal_Content_Rights Is_Active Flag ***********************************************************/

				UPDATE BVDCR SET BVDCR.Is_Active=BDC.Is_Active
				FROM BMS_Deal_Content_Rights BVDCR
				JOIN BMS_Deal_Content BDC ON BDC.BMS_Deal_Content_Code=BVDCR.BMS_Deal_Content_Code
				WHERE BDC.BMS_Deal_Code = @BMS_Deal_Code

				UPDATE TBVDCR SET TBVDCR.Is_Active = 'N'
				FROM BMS_Deal_Content_Rights TBVDCR
				INNER JOIN #TempData_New temp ON TBVDCR.BMS_Deal_Content_Code=temp.CurIden_BMS_Deal_Content
				WHERE
				(
					TBVDCR.RU_Channel_Code NOT IN (
						SELECT temp.RU_Channel_Code FROM #TempData_New temp 					
					)
					OR
					TBVDCR.YearWise_No NOT IN (
						SELECT temp.YearWise_No FROM #TempData_New temp
						WHERE TBVDCR.RU_Channel_Code = temp.RU_Channel_Code	AND temp.CurIden_BMS_Asset = TBVDCR.BMS_Asset_Code													
					)	
				)
			
				UPDATE BMS_Process_Deals SET Record_Status = 'D',Process_End=GETDATE() WHERE Acq_Deal_Code = @Deal_Code						

				COMMIT
				
			END TRY
			BEGIN CATCH
				SELECT ERROR_MESSAGE(), ERROR_Line()
				ROLLBACK
			END CATCH

			IF OBJECT_ID('tempdb..#TempData') IS NOT NULL DROP TABLE #TempData
			IF OBJECT_ID('tempdb..#SharedRound') IS NOT NULL DROP TABLE #SharedRound
			IF OBJECT_ID('tempdb..#Dummy_TempData_New') IS NOT NULL DROP TABLE #Dummy_TempData_New
			IF OBJECT_ID('tempdb..#TempData_New') IS NOT NULL DROP TABLE #TempData_New
			IF OBJECT_ID('tempdb..#Temp_BMS_Deal_Content') IS NOT NULL DROP TABLE #Temp_BMS_Deal_Content
			IF OBJECT_ID('tempdb..#Temp_BMS_Deal_Content_Rights') IS NOT NULL DROP TABLE #Temp_BMS_Deal_Content_Rights
			IF OBJECT_ID('tempdb..#runCounter') IS NOT NULL DROP TABLE #runCounter
			IF OBJECT_ID('tempdb..#MatchDealRuns') IS NOT NULL DROP TABLE #MatchDealRuns
			IF OBJECT_ID('tempdb..#DiffRuns') IS NOT NULL DROP TABLE #DiffRuns
			IF OBJECT_ID('tempdb..#DiffRunsYear') IS NOT NULL DROP TABLE #DiffRunsYear
			IF OBJECT_ID('tempdb..#tblChannelUpdate') IS NOT NULL DROP TABLE #tblChannelUpdate

			FETCH NEXT FROM CUS_Deal_Process INTO @Deal_Code
		
		END--While loop
		CLOSE CUS_Deal_Process
		DEALLOCATE CUS_Deal_Process
	
	END --if End 

END