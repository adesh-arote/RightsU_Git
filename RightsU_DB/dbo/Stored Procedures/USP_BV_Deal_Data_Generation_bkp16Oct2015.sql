CREATE PROCEDURE [dbo].[USP_BV_Deal_Data_Generation_bkp16Oct2015]
	@Deal_Code INT
AS
BEGIN
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_BV_Deal_Data_Generation_bkp16Oct2015]', 'Step 1', 0, 'Started Procedure', 0, ''
	-- ==================================f[BV_Asset_Ref_Key]===========
	-- Author:		Faisal Khan
	-- Create date: 13 Oct, 2015
	-- Description:	It will generate data that can be fetched through package and will be sent to BV
	-- =============================================

		SET NOCOUNT ON;
	
		DECLARE  @Is_Amendment CHAR(1)  = 'N'
		/********************************Set Amendment Flag****************/
		SELECT TOP 1 @Is_Amendment = CASE WHEN  BV.Acq_Deal_Code > 0 THEN 'Y' ELSE 'N' END 
		FROM BV_Deal BV (NOLOCK) WHERE ISNULL(BV.Acq_Deal_Code,0) = @Deal_Code
    
		SELECT T.N AS Row_Num INTO #TempDummy
		FROM  (
		  SELECT TOP(5000) ROW_NUMBER() OVER(ORDER BY 1/0)
		  FROM sys.all_objects AS o1, sys.all_objects AS o2 (NOLOCK)
		) AS T(N)
	
			SELECT 
				--ROW_NUMBER() OVER (Partition BY RU_Channel_Code, Content_Start_Date ORDER BY RU_Channel_Code) YearWise_No, 
				CAST(
					CASE
						WHEN Run_Type = 'U' AND No_Of_Runs = 0 THEN Min_Runs
						WHEN Is_Yearwise_Definition = 'Y' AND Is_Channel_Definition_Rights = 'Y' AND Run_Type <> 'U'
							THEN CASE WHEN Channel_Weightage = 0 THEN 0 ELSE  ROUND((No_Of_Runs * 100) / Channel_Weightage, 0) END
						WHEN Is_Yearwise_Definition = 'Y' AND Is_Channel_Definition_Rights = 'N' AND Run_Type <> 'U'
							THEN CASE WHEN No_Of_Runs = 0 THEN 0 ELSE   ROUND((No_Of_Runs * 100) / No_Of_Runs, 0)  END
						WHEN Is_Yearwise_Definition = 'N' AND Is_Channel_Definition_Rights = 'Y' AND Run_Type <> 'U' AND Run_Definition_Type NOT in ('S', 'N')
							THEN Min_Runs
						WHEN Is_Yearwise_Definition = 'N' AND Is_Channel_Definition_Rights = 'Y' AND Run_Type <> 'U' AND Run_Definition_Type in ('S', 'N')
							THEN ROUND((No_Of_Runs * Channel_Weightage) / 100, 0) 
						ELSE No_Of_Runs END 
					AS INT) AS 'Total_Runs',
			temp.Row_Num AS Episode_Number, 0 [CurIden_BV_Deal], 
			0 [CurIden_BV_Deal_Content],
			0 [CurIden_BV_Asset],
			* INTO #TempData FROM (
			SELECT 
				Distinct 
				--BV_Asset
				T.Duration_In_Min, T.Title_Name, Cast(T.Synopsis As Varchar(80)) Synopsis, Lang.Language_Code RU_Language_Code, Lang.Ref_Language_Key,
				AD.Deal_Type_Code,
			
				--Rights
				ADRT.Episode_From, ADRT.Episode_To,
				CH.Channel_Code [RU_Channel_Code], CH.Ref_Station_Key [BV_Station_Key],
				ADRun.Is_Rule_Right, RR.Right_Rule_Code [RU_Right_Rule_Code], RR.Ref_Right_Rule_Key [BV_Right_Rule_Ref_Key],
				SAP_WBS.SAP_WBS_Code [SAP_WBS_Code], SAP_WBS.BMS_Key [SAP_WBS_Ref_Key],
				--BA.BV_Asset_Code [BV_Asset_Code], BA.BV_Asset_Ref_Key [BV_Asset_Ref_Key], 'PRO' [Asset_Type], BA.Title,
				NULL [BV_Asset_Code], CAST(NULL AS INT) [BV_Asset_Ref_Key], 'PRO' [Asset_Type],
				ADRun.Run_Type, ADRun.Acq_Deal_Run_Code,
				ADRun.Is_Channel_Definition_Rights, ADRun.Is_Yearwise_Definition, Run_Definition_Type, ADRC.Min_Runs, 
			
				CASE WHEN ADRun.Is_Yearwise_Definition = 'Y' THEN ADRYR.No_Of_Runs ELSE ADRun.No_Of_Runs END No_Of_Runs,
				CASE WHEN ADRun.Is_Channel_Definition_Rights ='Y' AND ADRun.Run_Type <> 'U'
					THEN 
						CASE WHEN ADRun.No_Of_Runs = 0 THEN 0 ELSE CAST(((ISNULL(ADRC.Min_Runs, 0) * 100) / ISNULL(ADRun.No_Of_Runs, 0)) AS NUMERIC(6, 3)) END
				ELSE 0 END 'Channel_Weightage',
				--CASE WHEN ADRun.Is_Yearwise_Definition  = 'Y' AND ADRun.Run_Type <> 'U'
				--	THEN CAST(((ADRYR.No_of_Runs * 100) / ISNULL(ADRun.No_Of_Runs, 0)) AS INT) ELSE 0 END 'Year_Weightage', 
			
				NULL [Utilised_Run],
				CASE WHEN ADRYR.Acq_Deal_Run_Yearwise_Run_Code IS NULL THEN ADR.Actual_Right_Start_Date ELSE ADRYR.Start_Date END Right_Start_Date,
				CASE WHEN ADRYR.Acq_Deal_Run_Yearwise_Run_Code IS NULL THEN 
					CASE ADR.Right_Type WHEN 'U' THEN CAST('31 Dec 9999' AS DATETIME) ELSE ADR.Actual_Right_End_Date END
				ELSE ADRYR.End_Date END Right_End_Date,
			
				--Content
				ADR.Actual_Right_Start_Date [Content_Start_Date], 
				CASE 
					WHEN ADR.Right_Type = 'U' THEN CAST('31 Dec 9999' AS DATETIME) 
					WHEN ADR.Right_Type = 'Y' AND ADR.Is_Tentative = 'Y' AND ADR.Actual_Right_Start_Date IS NOT NULL 
						THEN DATEADD(MONTH, CAST(SUBSTRING(Term, CHARINDEX('.', Term, 0) + 1 , LEN(Term)) AS INT), DATEADD(YEAR, CAST(SUBSTRING(Term, 0, CHARINDEX('.', Term, 0)) AS INT), Actual_Right_Start_Date))
					ELSE ADR.Actual_Right_End_Date 
				END [Content_End_Date],
			
				--Deal
				AD.Acq_Deal_Code, T.Title_Code [RU_Title_Code], AD.Ref_BMS_Code [BV_Deal_Ref_Key], 'false' [Is_Archived], V.Vendor_Code [RU_Licensor_Code], NULL [RU_Payee_Code], 
				Cur.Currency_Code [RU_Currency_Code], E.Entity_Code [RU_Licensee_Code], Cat.Category_Code [RU_Category_Code],
				V.Ref_Vendor_Key [BV_Licensor_Code], NULL [BV_Payee_Code], Cur.Ref_Currency_Key [BV_Currency_Code], 
				E.Ref_Entity_Key [BV_Licensee_Code], Cat.Ref_Category_Key [BV_Category_Code],
				AD.Deal_Desc [Description], NULL [Contact], AD.Agreement_No, NULL [Revision], 
				ADR.Actual_Right_Start_Date [Start_Date], 
				CASE ADR.Right_Type WHEN 'U' THEN CAST('31 Dec 9999' AS DATETIME) ELSE ADR.Actual_Right_End_Date END [End_Date], 
				'1001' [Status_SLUId], '24001' [Type_SLUId], 
				AD.Agreement_Date [Acquisition_Date]
			FROM Acq_Deal AD  (NOLOCK)
			INNER JOIN Vendor V (NOLOCK) ON AD.Vendor_Code = V.Vendor_Code
			INNER JOIN Currency Cur (NOLOCK) ON AD.Currency_Code = Cur.Currency_Code
			INNER JOIN Entity E (NOLOCK) ON AD.Entity_Code = E.Entity_Code
			INNER JOIN Category Cat (NOLOCK) ON AD.Category_Code = Cat.Category_Code
			INNER JOIN Acq_Deal_Movie ADM  (NOLOCK) ON AD.Acq_Deal_Code= ADM.Acq_Deal_Code
			INNER JOIN Title T (NOLOCK) ON ADM.Title_Code = T.Title_Code
			INNER JOIN Acq_Deal_Rights ADR (NOLOCK) ON AD.Acq_Deal_Code = ADR.Acq_Deal_Code
				AND (ADR.Right_Type NOT IN ('M') OR ADR.Is_Tentative = 'Y' AND ADR.Right_Start_Date IS NOT NULL)
			INNER JOIN Acq_Deal_Rights_Title ADRTitle (NOLOCK) ON ADM.Title_Code = ADRTitle.Title_code AND ADR.Acq_Deal_Rights_Code = ADRTitle.Acq_Deal_Rights_Code
			INNER JOIN Acq_Deal_Rights_Platform ADRP (NOLOCK) ON ADR.Acq_Deal_Rights_Code = ADRP.Acq_Deal_Rights_Code
				AND ADRP.Platform_Code IN (SELECT Platform_Code FROM [Platform] (NOLOCK) where Is_No_Of_Run = 'Y')
			INNER JOIN Language Lang (NOLOCK) ON T.Title_Language_Code = Lang.Language_Code
			INNER JOIN Acq_Deal_Run ADRun (NOLOCK) ON AD.Acq_Deal_Code =  ADRun.Acq_Deal_Code AND ADRun.Is_Channel_Definition_Rights = 'Y'
			INNER JOIN Acq_Deal_Run_Title ADRT (NOLOCK) ON ADRun.Acq_Deal_Run_Code = ADRT.Acq_Deal_Run_Code AND ADRT.Title_Code = T.Title_Code
		
			LEFT JOIN Right_Rule RR (NOLOCK) ON ADRun.Right_Rule_Code = RR.Right_Rule_Code
			--LEFT JOIN BV_Asset BA ON T.Title_Code = BA.RU_Title_Code AND BA.Episode_No BETWEEN ADRT.Episode_From AND ADRT.Episode_To
			LEFT JOIN Acq_Deal_Run_Channel ADRC (NOLOCK) ON ADRun.Acq_Deal_Run_Code = ADRC.Acq_Deal_Run_Code
			LEFT JOIN Channel CH (NOLOCK) ON ADRC.Channel_Code = CH.Channel_Code
			LEFT JOIN Acq_Deal_Budget ADB (NOLOCK) ON AD.Acq_Deal_Code = ADB.Acq_Deal_Code AND ADB.Title_Code = ADM.Title_Code
			LEFT JOIN SAP_WBS (NOLOCK) ON ADB.SAP_WBS_Code = SAP_WBS.SAP_WBS_Code
			LEFT JOIN Acq_Deal_Run_Yearwise_Run ADRYR (NOLOCK) ON ADRun.Acq_Deal_Run_Code = ADRYR.Acq_Deal_Run_Code

			WHERE 1=1 AND AD.Acq_Deal_Code = @Deal_Code
		) AS TBL
		INNER JOIN #TempDummy temp ON temp.Row_Num between TBL.Episode_From AND TBL.Episode_To

		DROP TABLE #TempDummy
	
		UPDATE #TempData SET Start_Date = (SELECT Min(Start_Date) FROM #TempData), End_Date = (SELECT Max(End_Date) FROM #TempData)
	
		UPDATE #TempData Set Episode_Number = NULL WHERE Deal_Type_Code IN (1, 20, 21, 22)
	
		UPDATE temp SET temp.BV_Asset_Ref_Key = BA.BV_Asset_Ref_Key
		FROM #TempData temp 
			INNER JOIN BV_Asset BA ON BA.RU_Title_Code = temp.RU_Title_Code AND ISNULL(BA.Episode_Number, 0) = ISNULL(temp.Episode_Number, 0)
	
		/******** For shared & NA type definition ********/
		SELECT No_Of_Runs AS TotalRuns, Acq_Deal_Run_Code,Right_Start_date 
		INTO #SharedRound
		FROM #TempData
			WHERE Run_Definition_Type IN ('S', 'N') AND No_Of_Runs > 0
		GROUP BY Acq_Deal_Run_Code, No_Of_Runs, RU_Channel_Code,Right_Start_Date

		UPDATE temp set temp.Total_Runs = shared.TotalRuns
			FROM #TempData temp 
			INNER JOIN #SharedRound shared ON temp.Acq_Deal_Run_Code = shared.Acq_Deal_Run_Code
			AND temp.Right_Start_date=shared.Right_Start_date

		BEGIN TRY
			BEGIN TRAN			
			--Deal		
			IF(@Is_Amendment = 'N')
			BEGIN	
				INSERT INTO BV_Deal (
					Acq_Deal_Code, BV_Deal_Ref_Key, Is_Archived, RU_Licensor_Code, RU_Payee_Code, RU_Currency_Code, RU_Licensee_Code,
					RU_Category_Code, BV_Licensor_Code, BV_Payee_Code, BV_Currency_Code, BV_Licensee_Code, BV_Category_Code,
					License_Fees, 
					[Description], Contact, Lic_Ref_No, Revision, [Start_Date], [End_Date], Status_SLUId, Type_SLUId,
					Acquisition_Date, Record_Status)
				SELECT 
					DISTINCT 
						Acq_Deal_Code, BV_Deal_Ref_Key, Is_Archived, [RU_Licensor_Code], [RU_Payee_Code], [RU_Currency_Code], [RU_Licensee_Code], 
						[RU_Category_Code], [BV_Licensor_Code], [BV_Payee_Code], [BV_Currency_Code], [BV_Licensee_Code], [BV_Category_Code], 
						(select sum(Deal_Cost) From Acq_Deal_Cost (NOLOCK) where Acq_Deal_Code = @Deal_Code) [License_Fees],
						[Description], [Contact], Agreement_No, [Revision], [Start_Date], [End_Date], [Status_SLUId], [Type_SLUId], 
						[Acquisition_Date], 'P'
				FROM #TempData
			
				UPDATE #TempData SET CurIden_BV_Deal = (SELECT SCOPE_IDENTITY())
			
				END
			ELSE
			BEGIN		
				UPDATE #TempData SET CurIden_BV_Deal = (SELECT TOP 1 BV.BV_Deal_Code 
				FROM BV_Deal BV  
				WHERE BV.Acq_Deal_Code IN(SELECT T.Acq_Deal_Code FROM #TempData T))
			
				UPDATE BV SET BV.Acquisition_Date = TD.Acquisition_Date			
				,BV.RU_Licensor_Code = TD.RU_Licensor_Code
				,BV.RU_Payee_Code = TD.RU_Payee_Code
				,BV.RU_Currency_Code = TD.RU_Currency_Code
				,BV.RU_Licensee_Code = TD.RU_Licensee_Code
				,BV.RU_Category_Code = TD.RU_Category_Code
				,BV.BV_Licensor_Code = TD.BV_Licensor_Code			
				,BV.BV_Payee_Code = TD.BV_Payee_Code
				,BV.BV_Currency_Code = TD.BV_Currency_Code
				,BV.BV_Licensee_Code = TD.BV_Licensee_Code			
				,BV.BV_Category_Code = TD.BV_Category_Code
				,BV.License_Fees = (select sum(Deal_Cost) From Acq_Deal_Cost (NOLOCK) where Acq_Deal_Code = @Deal_Code) 
				,BV.[Description] = TD.[Description]
				,BV.[Contact] = TD.[Contact]
				,BV.[Revision] = TD.[Revision]
				,BV.[Start_Date] = TD.[Start_Date]
				,BV.[End_Date] = TD.[End_Date]
				,BV.[Status_SLUId] = TD.[Status_SLUId]
				,BV.[Type_SLUId] = TD.[Type_SLUId]
				,Record_Status='P'
				--SELECT BV.*
				FROM BV_Deal  BV (NOLOCK)
				INNER JOIN #TempData TD ON BV.Acq_Deal_Code = TD.Acq_Deal_Code
				WHERE BV.Acq_Deal_Code =@Deal_Code
			END	
				--UPDATE #TempData SET CurIden_BV_Deal = (SELECT SCOPE_IDENTITY())
			
		
			--BV_Asset
		
			INSERT INTO BV_Asset 
					(
						--BV_Deal_Code, 
						BV_Asset_Ref_Key, Duration, 
						RU_Title_Code, Title, Title_Listing, Language_Code, Ref_Language_Key, 
						RU_ProgramCategory_Code,
						Ref_BMS_ProgramCategroy,					
						Episode_Title, 
						Episode_Season, Episode_Number, Synopsis, Is_Archived, Record_Status
					)					
					SELECT 
					DISTINCT 
						--[CurIden_BV_Deal], 
						[BV_Asset_Ref_Key], CONVERT(VARCHAR, dateadd(MI,[Duration_In_Min],'00:00:00'), 108), 
						[RU_Title_Code], [Title_Name], [Title_Name], [RU_Language_Code], [Ref_Language_Key], 
						(						
								SELECT Columns_Value_Code fROM Map_Extended_Columns (NOLOCK) Where Columns_Code = 1 And Record_Code = temp.RU_Title_Code
						),
						(
							SELECT Ref_BMS_Code fROM [dbo].[Extended_Columns_Value] (NOLOCK) Where Columns_Value_Code In (
								SELECT Columns_Value_Code fROM Map_Extended_Columns (NOLOCK) Where Columns_Code = 1 And Record_Code = temp.RU_Title_Code)
						),
						--CASE Deal_Type_Name WHEN 'Movie' THEN NULL ELSE 'Episode ' + CAST([Episode_No] AS VARCHAR) END, 					
						CASE WHEN Deal_Type_Code IN (1, 20, 21, 22) THEN NULL ELSE 'Episode ' + CAST([Episode_Number] AS VARCHAR) END,
						NULL, [Episode_Number], [Synopsis], 'false', 'P'
					FROM #TempData temp WHERE 1=1
					AND 
					(
						(
						temp.RU_Title_Code IN (select RU_Title_Code From BV_Asset BA (NOLOCK))-- WHERE BA.RU_Title_Code = temp.RU_Title_Code)
						AND ISNULL(temp.Episode_Number, 0) NOT IN (select ISNULL(Episode_Number, 0) From BV_Asset BA (NOLOCK) WHERE BA.RU_Title_Code = temp.RU_Title_Code)
						)
						OR
						temp.RU_Title_Code NOT IN (select RU_Title_Code From BV_Asset BA (NOLOCK) ) --WHERE BA.RU_Title_Code = temp.RU_Title_Code)
					)
			
					UPDATE temp SET temp.CurIden_BV_Asset = BA.BV_Asset_Code
					FROM BV_Asset BA 
					INNER JOIN #TempData temp ON --BA.BV_Deal_Code = temp.CurIden_BV_Deal AND
						BA.RU_Title_Code = temp.RU_Title_Code
						AND ISNULL(BA.Episode_Number, 0) = ISNULL(temp.Episode_Number, 0)
					
					UPDATE BA SET BA.Duration = CONVERT(VARCHAR, dateadd(MI,temp.Duration_In_Min,'00:00:00'), 108)
					,BA.Title=temp.Title_Name
					,BA.Title_Listing=temp.Title_Name
					,BA.Language_Code= temp.[RU_Language_Code]
					,BA.[Ref_Language_Key]=temp.Ref_Language_Key
					,BA.RU_ProgramCategory_Code=(						
								SELECT Columns_Value_Code fROM Map_Extended_Columns (NOLOCK) Where Columns_Code = 1 And Record_Code = temp.RU_Title_Code
						)
					,Ref_BMS_ProgramCategroy= (
							SELECT Ref_BMS_Code fROM [dbo].[Extended_Columns_Value] (NOLOCK) Where Columns_Value_Code In (
								SELECT Columns_Value_Code fROM Map_Extended_Columns (NOLOCK) Where Columns_Code = 1 And Record_Code = temp.RU_Title_Code)
						)
					,BA.[Synopsis]=temp.[Synopsis]
					,Record_Status = 'P'
					FROM BV_Asset BA 
					INNER JOIN #TempData temp ON --BA.BV_Deal_Code = temp.CurIden_BV_Deal AND
						BA.RU_Title_Code = temp.RU_Title_Code
						AND ISNULL(BA.Episode_Number, 0) = ISNULL(temp.Episode_Number, 0)
				--Insert into new Temp Table						
					SELECT 
						ROW_NUMBER() OVER (Partition BY RU_Channel_Code, Content_Start_Date,CurIden_BV_Asset ORDER BY RU_Channel_Code) YearWise_No
						,* INTO #TempData_New
					FROM #TempData
				DROP TABLE #TempData
				--Deal_Content
				IF(@Is_Amendment = 'N')
				BEGIN	
					INSERT INTO BV_Deal_Content (
						BV_Deal_Code, BV_Deal_Ref_Key, BV_Deal_Content_Ref_Key, BV_Asset_Code, BV_Asset_Ref_Key, 
						Asset_Type, Title, Start_Date, End_Date, Record_Status,Is_Archived
					)
					SELECT 
						DISTINCT 
							CurIden_BV_Deal, [BV_Deal_Ref_Key], NULL [BV_Deal_Content_Ref_Key], [CurIden_BV_Asset], [BV_Asset_Ref_Key],
							[Asset_Type], [Title_Name], [Content_Start_Date], [Content_End_Date], 'P','false'
					FROM #TempData_New				 				
				
					UPDATE temp SET temp.CurIden_BV_Deal_Content = BDC.BV_Deal_Content_Code
					FROM BV_Deal_Content BDC 
						INNER JOIN #TempData_New temp ON temp.CurIden_BV_Deal = BDC.BV_Deal_Code
						AND BDC.BV_Asset_Code = temp.CurIden_BV_Asset			
				END
				ELSE
				BEGIN	
					INSERT INTO BV_Deal_Content (
						BV_Deal_Code, BV_Deal_Ref_Key, BV_Deal_Content_Ref_Key, BV_Asset_Code, BV_Asset_Ref_Key, 
						Asset_Type, Title, Start_Date, End_Date, Record_Status,Is_Archived
					)
					SELECT 
						DISTINCT 
							CurIden_BV_Deal, [BV_Deal_Ref_Key], NULL [BV_Deal_Content_Ref_Key], [CurIden_BV_Asset], [BV_Asset_Ref_Key],
							[Asset_Type], [Title_Name], [Content_Start_Date], [Content_End_Date], 'P','false'
					FROM #TempData_New TD
					WHERE TD.CurIden_BV_Asset NOT IN
					(
						SELECT BV_Asset_Code FROM BV_Deal_Content (NOLOCK) WHERE BV_Deal_Code IN
						(SELECT BV_Deal_Code FROM BV_Deal (NOLOCK) WHERE Acq_Deal_Code = @Deal_Code )
					)
				
					UPDATE temp SET temp.CurIden_BV_Deal_Content = BDC.BV_Deal_Content_Code
					FROM BV_Deal_Content BDC 
					INNER JOIN #TempData_New temp ON temp.CurIden_BV_Deal = BDC.BV_Deal_Code
					AND BDC.BV_Asset_Code = temp.CurIden_BV_Asset	
				
					UPDATE BDC SET BDC.[Start_Date] = TD.[Content_Start_Date]
					,BDC.End_Date = TD.[Content_End_Date],Record_Status = 'P'
					,BDC.Title = TD.[Title_Name]
					,BV_Asset_Code=TD.[CurIden_BV_Asset]
					,BV_Asset_Ref_Key= TD.[BV_Asset_Ref_Key]
					FROM #TempData_New TD 
						INNER JOIN BV_Deal_Content BDC 
						 ON TD.CurIden_BV_Deal = BDC.BV_Deal_Code AND BDC.BV_Asset_Code = Td.CurIden_BV_Asset				
			
				END
			
				--BV_Deal_Content_Rights
				IF(@Is_Amendment = 'N')
				BEGIN		
				INSERT INTO BV_Deal_Content_Rights (
					BV_Deal_Content_Code, BV_Deal_Content_Ref_Key, RU_Channel_Code, BV_Deal_Content_Rights_Ref_Key, 
					BV_Station_Code, RU_Right_Rule_Code, BV_Right_Rule_Ref_Key, SAP_WBS_Code, SAP_WBS_Ref_Key, 
					BV_Asset_Code, BV_Asset_Ref_Key, Asset_Type,
					Title, License_Fees, Total_Runs, Utilised_Run, Start_Date, End_Date, 
					Blackout_From_1, Blackout_To_1, Blackout_From_2, Blackout_To_2, Blackout_From_3, Blackout_To_3,YearWise_No, Record_Status
					)

				SELECT
					DISTINCT 
						[CurIden_BV_Deal_Content], NULL [BV_Deal_Content_Ref_Key], [RU_Channel_Code], NULL [BV_Deal_Content_Rights_Ref_Key],
						[BV_Station_Key], [RU_Right_Rule_Code], [BV_Right_Rule_Ref_Key], [SAP_WBS_Code], [SAP_WBS_Ref_Key],
						CurIden_BV_Asset, [BV_Asset_Ref_Key], [Asset_Type],
						[Title_Name], 0, [Total_Runs], [Utilised_Run], [Right_Start_Date], [Right_End_Date],
						NULL, NULL, NULL, NULL, NULL, NULL,YearWise_No, 'P'
				FROM #TempData_New
				END
				ELSE
				BEGIN
					INSERT INTO BV_Deal_Content_Rights (
						BV_Deal_Content_Code, BV_Deal_Content_Ref_Key, RU_Channel_Code, BV_Deal_Content_Rights_Ref_Key, 
						BV_Station_Code, RU_Right_Rule_Code, BV_Right_Rule_Ref_Key, SAP_WBS_Code, SAP_WBS_Ref_Key, 
						BV_Asset_Code, BV_Asset_Ref_Key, Asset_Type,
						Title, License_Fees, Total_Runs, Utilised_Run, Start_Date, End_Date, 
						Blackout_From_1, Blackout_To_1, Blackout_From_2, Blackout_To_2, Blackout_From_3, Blackout_To_3,YearWise_No, Record_Status
					)
					SELECT
						DISTINCT 
							[CurIden_BV_Deal_Content], NULL [BV_Deal_Content_Ref_Key], TD.[RU_Channel_Code], NULL [BV_Deal_Content_Rights_Ref_Key],
							[BV_Station_Key], TD.[RU_Right_Rule_Code], TD.[BV_Right_Rule_Ref_Key], TD.[SAP_WBS_Code], TD.[SAP_WBS_Ref_Key],
							CurIden_BV_Asset, TD.[BV_Asset_Ref_Key], TD.[Asset_Type],
							[Title_Name], 0, TD.[Total_Runs], TD.[Utilised_Run], [Right_Start_Date], [Right_End_Date],
							NULL, NULL, NULL, NULL, NULL, NULL,TD.YearWise_No, 'P'
					FROM #TempData_New TD 			
					WHERE TD.RU_Channel_Code NOT IN
					(
						SELECT BDCR.RU_Channel_Code FROM BV_Deal_Content_Rights BDCR  (NOLOCK)
						INNER JOIN BV_Deal_Content BDC (NOLOCK) ON BDCR.BV_Deal_Content_Code = BDC.BV_Deal_Content_Code 
						INNER JOIN BV_Deal BD (NOLOCK) ON BDC.BV_Deal_Code = BD.BV_Deal_Code 
						WHERE BD.Acq_Deal_Code = @Deal_Code
					) 
					OR
					TD.CurIden_BV_Asset NOT IN
					(
						SELECT BDCR.BV_Asset_Code FROM BV_Deal_Content_Rights BDCR  (NOLOCK)
						INNER JOIN BV_Deal_Content BDC (NOLOCK) ON BDCR.BV_Deal_Content_Code = BDC.BV_Deal_Content_Code 
							AND BDCR.RU_Channel_Code = TD.RU_Channel_Code
						INNER JOIN BV_Deal BD (NOLOCK) ON BDC.BV_Deal_Code = BD.BV_Deal_Code 
						WHERE BD.Acq_Deal_Code = @Deal_Code
					) 
			
					UPDATE BDCR 
						SET 
							BDCR.RU_Right_Rule_Code = temp.RU_Right_Rule_Code,
							BDCR.BV_Right_Rule_Ref_Key = temp.BV_Right_Rule_Ref_Key,
							BDCR.SAP_WBS_Code = temp.SAP_WBS_Code,
							BDCR.SAP_WBS_Ref_Key = temp.SAP_WBS_Ref_Key,
							BDCR.Title = temp.Title_Name,
							BDCR.Total_Runs = temp.Total_Runs,
							--BDCR.T = temp.Total_Runs, -- Update No OF Run  OR Utilized Run 
							BDCR.Start_Date = temp.Right_Start_Date,
							BDCR.End_Date = temp.Right_End_Date,
							BDCR.Record_Status = 'P'
					FROM #TempData_New temp INNER JOIN BV_Deal_Content_Rights BDCR 
						ON temp.RU_Channel_Code = BDCR.RU_Channel_Code
						AND temp.YearWise_No = BDCr.YearWise_No
						AND temp.CurIden_BV_Deal_Content = BDCR.BV_Deal_Content_Code
						AND temp.CurIden_BV_Asset = BDCR.BV_Asset_Code
					INSERT INTO BV_Deal_Content_Rights (
						BV_Deal_Content_Code, BV_Deal_Content_Ref_Key, RU_Channel_Code, BV_Deal_Content_Rights_Ref_Key, 
						BV_Station_Code, RU_Right_Rule_Code, BV_Right_Rule_Ref_Key, SAP_WBS_Code, SAP_WBS_Ref_Key, 
						BV_Asset_Code, BV_Asset_Ref_Key, Asset_Type,
						Title, License_Fees, Total_Runs, Utilised_Run, Start_Date, End_Date, 
						Blackout_From_1, Blackout_To_1, Blackout_From_2, Blackout_To_2, Blackout_From_3, Blackout_To_3,YearWise_No, Record_Status
					)
					SELECT
						DISTINCT 
							[CurIden_BV_Deal_Content], NULL [BV_Deal_Content_Ref_Key], TD.[RU_Channel_Code], NULL [BV_Deal_Content_Rights_Ref_Key],
							[BV_Station_Key], TD.[RU_Right_Rule_Code], TD.[BV_Right_Rule_Ref_Key], TD.[SAP_WBS_Code], TD.[SAP_WBS_Ref_Key],
							CurIden_BV_Asset, TD.[BV_Asset_Ref_Key], TD.[Asset_Type],
							[Title_Name], 0, TD.[Total_Runs], TD.[Utilised_Run], [Right_Start_Date], [Right_End_Date],
							NULL, NULL, NULL, NULL, NULL, NULL,TD.YearWise_No, 'P'
				FROM #TempData_New TD 
				WHERE TD.YearWise_No NOT IN 					
				(
					SELECT BDCR.YearWise_No FROM BV_Deal_Content_Rights BDCR (NOLOCK)
					WHERE BDCR.RU_Channel_Code = TD.RU_Channel_Code
						AND TD.CurIden_BV_Asset = BDCR.BV_Asset_Code					
						AND TD.CurIden_BV_Deal_Content = BDCR.BV_Deal_Content_Code
				)
					
			
				END
			COMMIT
		END TRY
		BEGIN CATCH
			SELECT ERROR_MESSAGE(), ERROR_Line()
			ROLLBACK
		END CATCH
		--DROP TABLE #TempData_New

		IF OBJECT_ID('tempdb..#SharedRound') IS NOT NULL DROP TABLE #SharedRound
		IF OBJECT_ID('tempdb..#TempData') IS NOT NULL DROP TABLE #TempData
		IF OBJECT_ID('tempdb..#TempData_New') IS NOT NULL DROP TABLE #TempData_New
		IF OBJECT_ID('tempdb..#TempDummy') IS NOT NULL DROP TABLE #TempDummy

	
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_BV_Deal_Data_Generation_bkp16Oct2015]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END