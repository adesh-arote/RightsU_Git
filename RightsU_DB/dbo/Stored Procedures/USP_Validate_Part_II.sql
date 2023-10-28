CREATE Procedure USP_Validate_Part_II (@Cur_Title_code INT = 0, @Cur_From_Episode_No INT = 0, @Cur_To_Episode_No INT = 0,@Syn_Deal_Rights_Code INT = 0,
@Deal_Rights_Platform Deal_rights_platform READONLY, @Deal_Rights_Territory Deal_Rights_Territory READONLY,
@Deal_Rights_Subtitling Deal_Rights_Subtitling READONLY, @Deal_Rights_Dubbing Deal_Rights_Dubbing READONLY,@Temp_Episode_No Temp_Episode_No READONLY,
@Deal_Right_Title_WithEpsNo Deal_Right_Title_WithEpsNo READONLY, @Acq_Deal_Rights Acq_Deal_Rights READONLY, @Deal_Rights_Title Deal_Rights_Title READONLY,
@TempPromoter TempPromoter READONLY)
As
Begin	
	DECLARE @IS_PUSH_BACK_SAME_DEAL CHAR(1) ='N', @Is_Autopush CHAR(1) = 'N', @Sql NVARCHAR(1000),@DB_Name VARCHAR(1000),@Agreement_No VARCHAR(100);
	SELECT @IS_PUSH_BACK_SAME_DEAL  = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'VALIDATE_PUSHBACK_SAME_DEAL'		
		
	DECLARE @Right_Start_Date DATETIME,
	@Right_End_Date DATETIME,
	@Right_Type CHAR(1),
	@Is_Exclusive CHAR(1),
	@Is_Title_Language_Right CHAR(1),
	@Is_Sub_License CHAR(1),
	@Is_Tentative CHAR(1),
	@Sub_License_Code Int,
	@Deal_Rights_Code Int,
	@Deal_Pushback_Code Int,
	@Deal_Code Int,
	@Title_Code Int,
	@Platform_Code Int,
	@Is_Theatrical_Right CHAR(1),
	@Is_Error Char(1) = 'N',
	@CallFrom varchar(2)

	-- Assign Values To Local Variable 
	SELECT 
		@Deal_Code=dr.Syn_Deal_Code,
		@Deal_Rights_Code = Syn_Deal_Rights_Code, 
		@Deal_Pushback_Code = CASE WHEN @CallFrom = 'SP' THEN dr.Syn_Deal_Rights_Code ELSE 0 END,
		@Right_Start_Date=dr.Right_Start_Date,
		@Right_End_Date=dr.Right_End_Date,
		@Right_Type=dr.Right_Type,
		@Is_Exclusive=dr.Is_Exclusive,
		@Is_Tentative=dr.Is_Tentative,
		@Is_Sub_License=dr.Is_Sub_License,
		@Sub_License_Code=dr.Sub_License_Code,
		@Is_Title_Language_Right=dr.Is_Title_Language_Right,	
		@Title_Code=0,
		@Platform_Code=0,
		@Is_Theatrical_Right=ISNULL(dr.Is_Theatrical_Right,'N')
	FROM Syn_Deal_Rights dr WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code

	IF OBJECT_ID('TEMPDB..#Dup_Records_Language') IS NOT NULL DROP TABLE #Dup_Records_Language
	IF OBJECT_ID('TEMPDB..#Acq_Deal_Rights') IS NOT NULL DROP TABLE #Acq_Deal_Rights
	IF OBJECT_ID('TEMPDB..#Temp_Episode_No') IS NOT NULL DROP TABLE #Temp_Episode_No
	IF OBJECT_ID('TEMPDB..#Deal_Right_Title_WithEpsNo') IS NOT NULL DROP TABLE #Deal_Right_Title_WithEpsNo

	CREATE Table #Dup_Records_Language
	(
		[id]						INT,
		[Title_Code]				INT,
		[Platform_Code]				INT,
		[Territory_Code]			INT,
		[Country_Code]				INT,
		[Right_Start_Date]			DATETIME,
		[Right_End_Date]			DATETIME,
		[Right_Type]				VARCHAR (50),
		[Territory_Type]			CHAR (1),
		[Is_Sub_License]			CHAR (1),
		[Is_Title_Language_Right]	CHAR (1),
		[Subtitling_Language]		INT,
		[Dubbing_Language]			INT,
		[Promoter_Group_Code]		INT,
		[Promoter_Remarks_Code]		INT,
		[Deal_Code]					INT,
		[Deal_Rights_Code]			INT,
		[Deal_Pushback_Code]		INT,
		[Agreement_No]				VARCHAR (MAX),
		[ErrorMSG]					VARCHAR (MAX),
		[Episode_From]				INT,
		[Episode_To]				INT,
		[IsPushback]				CHAR (1)      
	)
	CREATE Table #TempCombination
	(
		ID Int IDENTITY(1,1),
		Agreement_No Varchar(1000),
		Title_Code Int,	
		Episode_From Int,
		Episode_To Int,
		Platform_Code Int,
		Right_Type  CHAR(1),
		Right_Start_Date DATETIME,
		Right_End_Date DATETIME,
		Is_Title_Language_Right CHAR(1),
		Country_Code Int,
		Terrirory_Type CHAR(1),
		Is_exclusive CHAR(1),
		Subtitling_Language_Code Int,
		Dubbing_Language_Code Int,
		Promoter_Group_Code		INT,
		Promoter_Remarks_Code	INT,
		Data_From CHAR(1),
		Is_Available CHAR(1),
		Error_Description NVARCHAR(MAX),
		Sum_of Int,
		Partition_Of Int
	)
	CREATE Table #TempCombination_Session
	(
		ID Int IDENTITY(1,1),
		Agreement_No Varchar(1000),
		Title_Code Int,	
		Episode_From Int,
		Episode_To Int,
		Platform_Code Int,
		Right_Type  CHAR(1),
		Right_Start_Date DATETIME,
		Right_End_Date DATETIME,
		Is_Title_Language_Right CHAR(1),
		Country_Code Int,
		Terrirory_Type CHAR(1),
		Is_exclusive CHAR(1),
		Subtitling_Language_Code Int,
		Dubbing_Language_Code Int,
		Promoter_Group_Code		INT,
		Promoter_Remarks_Code	INT,
		Data_From CHAR(1),
		Is_Available CHAR(1),
		Error_Description NVARCHAR(MAX),
		Sum_of Int,
		Partition_Of Int,
		MessageUpadated CHAR(1) DEFAULT('N')
	)

	SELECT * INTO #Acq_Deal_Rights FROM @Acq_Deal_Rights
	SELECT * INTO #Temp_Episode_No FROM @Temp_Episode_No
	SELECT * INTO #Deal_Right_Title_WithEpsNo FROM @Deal_Right_Title_WithEpsNo
	SELECT * INTO #TempPromoter FROM @TempPromoter
	Begin

		Begin ----------------- CHECK TITLE WITH EPISODE EXISTS OR NOT

			SELECT Distinct ADR.Acq_Deal_Rights_Code, ADRT.Title_Code, ADRT.Episode_From, ADRT.Episode_To, ADR.SubCnt, ADR.DubCnt,
							ADR.Sum_of, ADR.Partition_Of
			InTo #Acq_Titles_With_Rights
			FROM #Acq_Deal_Rights ADR
			Inner Join dbo.Acq_Deal_Rights_Title ADRT On ADR.Acq_Deal_Rights_Code=ADRT.Acq_Deal_Rights_Code
			WHERE ADRT.Title_Code = @Cur_Title_code AND (
				(@Cur_From_Episode_No Between ADRT.Episode_From AND ADRT.Episode_To) OR
				(@Cur_To_Episode_No Between ADRT.Episode_From AND ADRT.Episode_To) OR
				(ADRT.Episode_From Between @Cur_From_Episode_No AND @Cur_To_Episode_No) OR
				(ADRT.Episode_To Between @Cur_From_Episode_No AND @Cur_To_Episode_No)
			)
			SELECT Distinct Title_Code, Episode_From, Episode_To InTo #Acq_Titles FROM #Acq_Titles_With_Rights
				
			PRINT 'AD 5.1 ' + CAST(@Cur_Title_code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)
			
			SELECT Title_Code, Episode_No InTo #Acq_Avail_Title_Eps
			FROM (
				SELECT Distinct t.Title_Code, a.Episode_No 
				FROM #Temp_Episode_No A 
				Cross Apply #Acq_Titles T 
				WHERE A.Episode_No Between T.Episode_FROM AND T.Episode_To
			) As B 

			SELECT ROW_NUMBER() Over(Order By Title_Code, Episode_No Asc) RowId, * InTo #Title_Not_Acquire FROM #Deal_Right_Title_WithEpsNo deps
			WHERE deps.Episode_No Not In (
				SELECT Episode_No FROM #Acq_Avail_Title_Eps aeps WHERE deps.Title_Code = aeps.Title_Code
			)

			Drop Table #Acq_Avail_Title_Eps
				
			PRINT 'AD 5.2 ' + CAST(@Cur_Title_code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)
				
			Create Table #Temp_NA_Title(
				Title_Code Int,
				Episode_From Int,
				Episode_To Int,
				Status Char(1)
			)

			Declare @Cur_Inner_Title_code Int = 0, @Cur_Episode_No Int = 0, @Prev_Title_Code Int = 0, @Prev_Episode_No Int
			Declare CUS_EPS Cursor For 
				SELECT Title_code, Episode_No FROM #Title_Not_Acquire Order By Title_code Asc, Episode_No  Asc
			Open CUS_EPS
			Fetch Next FROM CUS_EPS InTo @Cur_Inner_Title_code, @Cur_Episode_No
			While(@@FETCH_STATUS = 0)
			Begin
	
				If(@Cur_Inner_Title_code <> @Prev_Title_Code)
				Begin

					If Exists(SELECT TOP 1 * FROM #Temp_NA_Title WHERE Status = 'U' AND Title_Code = @Prev_Title_Code)
					Begin
						UPDATE #Temp_NA_Title Set Episode_To = @Prev_Episode_No, Status = 'A' WHERE Status = 'U' AND Title_Code = @Prev_Title_Code
					END

					Insert InTo #Temp_NA_Title(Title_Code, Episode_From, Status)
					SELECT @Cur_Inner_Title_code, @Cur_Episode_No, 'U'
					Set @Prev_Title_Code = @Cur_Inner_Title_code
				END
				ELSE If(@Cur_Inner_Title_code = @Prev_Title_Code AND @Cur_Episode_No <> (@Prev_Episode_No + 1))
				Begin
					If Exists(SELECT TOP 1 * FROM #Temp_NA_Title WHERE Status = 'U' AND Title_Code = @Cur_Inner_Title_code)
					Begin
						UPDATE #Temp_NA_Title Set Episode_To = @Prev_Episode_No, Status = 'A' WHERE Status = 'U' AND Title_Code = @Cur_Inner_Title_code
					END
		
					Insert InTo #Temp_NA_Title(Title_Code, Episode_From, Status)
					SELECT @Cur_Inner_Title_code, @Cur_Episode_No, 'U'
				END
	
				Set @Prev_Episode_No = @Cur_Episode_No

				Fetch Next FROM CUS_EPS InTo @Cur_Inner_Title_code, @Cur_Episode_No
			END
			Close CUS_EPS
			Deallocate CUS_EPS

			Drop Table #Title_Not_Acquire
					
			PRINT 'AD 5.3 ' + CAST(@Cur_Title_code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)
			
			If Exists(SELECT TOP 1 * FROM #Temp_NA_Title WHERE Status = 'U' AND Title_Code = @Prev_Title_Code)
			Begin
				UPDATE #Temp_NA_Title Set Episode_To = @Prev_Episode_No, Status = 'A' WHERE Status = 'U' AND Title_Code = @Prev_Title_Code
			END

			If Exists(SELECT TOP 1 * FROM #Temp_NA_Title)
			Begin
				Insert InTo Syn_Deal_Rights_Error_Details(Syn_Deal_Rights_Code, Title_Name, Platform_Name, Right_Start_Date, Right_End_Date, 
															Right_Type, Is_Sub_Licence, Is_Title_Language_Right, Country_Name, Subtitling_Language, 
															Dubbing_Language, Agreement_No, ErrorMsg, Episode_From, Episode_To, Inserted_On,IsPushback)
				SELECT @Syn_Deal_Rights_Code, t.Title_Name, 'NA', Null, Null, 
						'NA', 'NA', 'NA', 'NA', 'NA', 
						'NA', 'NA', 'Title not acquired', Episode_From, Episode_To, GETDATE(), Null
				FROM #Temp_NA_Title tnt
				Inner Join Title t On tnt.Title_Code = t.Title_Code
						
				PRINT 'AD 5.4 ' + CAST(@Cur_Title_code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)
			
				Drop Table #Temp_NA_Title

				UPDATE Syn_Deal_Rights Set Right_Status = 'E' WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
				Set @Is_Error = 'Y'
			END
			--ELSE
			--Begin
			--	UPDATE Syn_Deal_Rights Set Right_Status = 'C' WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
			--END

		END ------------------------------ END
			
		PRINT 'AD 6 ' + CAST(@Cur_Title_code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)
			
		Begin ----------------- CHECK PLATFORM AND TITLE & EPISODE EXISTS OR NOT

			SELECT Distinct DRT.Title_Code, Episode_From, Episode_To, DRP.Platform_Code
			InTo #Temp_Platforms
			FROM #Acq_Titles DRT
			Inner Join @Deal_Rights_Platform DRP On 1 = 1

			Drop Table #Acq_Titles

			SELECT art.*, adrp.Platform_Code InTo #Temp_Acq_Platform FROM #Acq_Titles_With_Rights art
			Inner Join Acq_Deal_Rights_Platform adrp On adrp.Acq_Deal_Rights_Code = art.Acq_Deal_Rights_Code
			Inner Join @Deal_Rights_Platform drp On adrp.Platform_Code = drp.Platform_Code

			Drop Table #Acq_Titles_With_Rights

			Delete FROM #Temp_Acq_Platform WHERE Platform_Code Not In (SELECT Platform_Code FROM #Temp_Platforms)

			SELECT Distinct DRT.Title_Code, Episode_From, Episode_To, DRT.Platform_Code InTo #NA_Platforms
			FROM #Temp_Platforms DRT
			WHERE DRT.Platform_Code Not In (
				SELECT ap.Platform_Code FROM #Temp_Acq_Platform ap
				WHERE DRT.Title_Code = ap.Title_Code AND DRT.Episode_From = ap.Episode_From AND DRT.Episode_To = ap.Episode_To
			)

			Delete FROM #Temp_Platforms WHERE #Temp_Platforms.Platform_Code In (
				SELECT np.Platform_Code FROM #NA_Platforms np
				WHERE np.Title_Code = #Temp_Platforms.Title_Code AND np.Episode_From = #Temp_Platforms.Episode_From AND np.Episode_To = #Temp_Platforms.Episode_To
			)

			Insert InTo #Dup_Records_Language(Agreement_No, Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, Territory_Type,
										Right_Start_Date, Right_End_Date, Right_Type, Is_Sub_License, ErrorMSG, Is_Title_Language_Right
			)
			SELECT '', 0, Title_Code, Episode_From, Episode_To, Platform_Code, 0, '', 
					@Right_Start_Date, @Right_End_Date, @Right_Type, @Is_Sub_License, 'Platform not acquired', @Is_Title_Language_Right 
			FROM #NA_Platforms np

			Drop Table #NA_Platforms

		END ------------------------------ END
			
		PRINT 'AD 7 ' + CAST(@Cur_Title_code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)
						
		Begin ----------------- CHECK COUNTRY AND PLATFORM AND TITLE & EPISODE EXISTS OR NOT
			
			SELECT Distinct tp.Title_Code, tp.Episode_From, tp.Episode_To, tp.Platform_Code, tc.Country_Code InTo #Temp_Country
			FROM #Temp_Platforms tp
			Inner Join @Deal_Rights_Territory TC On 1 = 1

			Drop Table #Temp_Platforms
				
			PRINT 'AD 7.1 ' + CAST(@Cur_Title_code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)
				
			Declare @Thetrical_Platform_Code Int = 0, @Domestic_Country Int = 0
			SELECT @Thetrical_Platform_Code = CAST(Parameter_Value As Int) FROM System_Parameter_New WHERE Parameter_Name = 'THEATRICAL_PLATFORM_CODE'
			SELECT @Domestic_Country = CAST(Parameter_Value As Int) FROM System_Parameter_New WHERE Parameter_Name = 'INDIA_COUNTRY_CODE'

			If Exists(SELECT TOP 1 * FROM #Temp_Country WHERE Platform_Code = @Thetrical_Platform_Code AND Country_Code = @Domestic_Country)
			Begin
				
				Insert InTo #Temp_Country
				SELECT tp.Title_Code, tp.Episode_From, tp.Episode_To, tp.Platform_Code, c.Country_Code
				FROM (
					SELECT * FROM #Temp_Country WHERE Platform_Code = @Thetrical_Platform_Code AND Country_Code = @Domestic_Country
				) As tp Inner Join Country c On c.Parent_Country_Code = tp.Country_Code

				Delete FROM #Temp_Country WHERE Platform_Code = @Thetrical_Platform_Code AND Country_Code = @Domestic_Country

			END
		
			PRINT 'AD 7.2 ' + CAST(@Cur_Title_code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)
				

			SELECT Acq_Deal_Rights_Code, CASE WHEN srter.Territory_Type = 'G' THEN td.Country_Code ELSE srter.Country_Code END Country_Code InTo #Acq_Country
			FROM (
				SELECT Acq_Deal_Rights_Code, Territory_Code, Country_Code,  Territory_Type 
				FROM Acq_Deal_Rights_Territory  
				WHERE Acq_Deal_Rights_Code In (SELECT Acq_Deal_Rights_Code FROM #Acq_Deal_Rights)
			) srter
			Left Join Territory_Details td On srter.Territory_Code = td.Territory_Code
				
			PRINT 'AD 7.3 ' + CAST(@Cur_Title_code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)
				
			SELECT tap.*, adc.Country_Code InTo #Temp_Acq_Country FROM #Temp_Acq_Platform tap
			Inner Join #Acq_Country adc On tap.Acq_Deal_Rights_Code = adc.Acq_Deal_Rights_Code

			Drop Table #Acq_Country
			Drop Table #Temp_Acq_Platform
				
			PRINT 'AD 7.4 ' + CAST(@Cur_Title_code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)
				
			If Exists(SELECT TOP 1 * FROM #Temp_Acq_Country WHERE Platform_Code = @Thetrical_Platform_Code AND Country_Code = @Domestic_Country)
			Begin
				
				Insert InTo #Temp_Acq_Country(Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, Sum_of, partition_of)
				SELECT tp.Acq_Deal_Rights_Code, tp.Title_Code, tp.Episode_From, tp.Episode_To, tp.Platform_Code, c.Country_Code,tp.Sum_of, tp.partition_of
				FROM (
					SELECT * FROM #Temp_Acq_Country WHERE Platform_Code = @Thetrical_Platform_Code AND Country_Code = @Domestic_Country
				) As tp Inner Join Country c On c.Parent_Country_Code = tp.Country_Code

				Delete FROM #Temp_Acq_Country WHERE Platform_Code = @Thetrical_Platform_Code AND Country_Code = @Domestic_Country

			END
			
			PRINT 'AD 7.5 ' + CAST(@Cur_Title_code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)
				
			Delete FROM #Temp_Acq_Country WHERE Country_Code Not In (SELECT Country_Code FROM #Temp_Country)

			SELECT Distinct DRC.Title_Code, DRC.Episode_From, DRC.Episode_To, DRC.Platform_Code, DRC.Country_Code InTo #NA_Country
			FROM #Temp_Country DRC
			WHERE DRC.Country_Code Not In (
				SELECT ac.Country_Code FROM #Temp_Acq_Country ac
				WHERE DRC.Title_Code = ac.Title_Code AND DRC.Episode_From = ac.Episode_From AND DRC.Episode_To = ac.Episode_To AND DRC.Platform_Code = ac.Platform_Code
			)
				
			PRINT 'AD 7.6 ' + CAST(@Cur_Title_code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)
				
			Delete FROM #Temp_Country WHERE #Temp_Country.Country_Code In (
				SELECT np.Country_Code FROM #NA_Country np
				WHERE np.Title_Code = #Temp_Country.Title_Code AND np.Episode_From = #Temp_Country.Episode_From 
						AND np.Episode_To = #Temp_Country.Episode_To AND np.Platform_Code = #Temp_Country.Platform_Code
			)
			
			PRINT 'AD 7.7 ' + CAST(@Cur_Title_code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)
				
			Insert InTo #Dup_Records_Language(Agreement_No, Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, Territory_Type,
										Right_Start_Date, Right_End_Date, Right_Type, Is_Sub_License, ErrorMSG, Is_Title_Language_Right
			)
			SELECT '', 0, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, '', 
					@Right_Start_Date, @Right_End_Date, @Right_Type, @Is_Sub_License, 'Region not acquired', @Is_Title_Language_Right 
			FROM #NA_Country np

			Drop Table #NA_Country
				
			PRINT 'AD 7.8 ' + CAST(@Cur_Title_code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)
				
			If(@Is_Title_Language_Right = 'Y')
			Begin
				INSERT INTO #TempCombination_Session(Title_Code, Episode_From, Episode_To, Platform_Code, Right_Type, Right_Start_Date, Right_End_Date, Is_Title_Language_Right,
														Country_Code, Terrirory_Type, Is_exclusive, Subtitling_Language_Code, Dubbing_Language_Code,
														Data_From, Is_Available, Error_Description,
														Sum_of,partition_of)
				SELECT DISTINCT T.Title_Code, T.Episode_From, T.Episode_To, T.Platform_Code, @Right_Type, @Right_Start_Date, @Right_End_Date, @Is_Title_Language_Right,
					T.Country_Code, 'I', @Is_Exclusive, 0, 0,
					'S', 'N', 'Session',
					CASE 
						WHEN @Right_End_Date Is Null THEN 0 ELSE DATEDIFF(D, @Right_Start_Date, DATEADD(D, 1, @Right_End_Date))
					END Sum_of,
					CASE 
						WHEN @Right_End_Date Is Null THEN 0 ELSE DATEDIFF(D, @Right_Start_Date, DATEADD(D, 1, @Right_End_Date))
					END partition_of
				FROM #Temp_Country T
			END
				
			PRINT 'AD 7.9 ' + CAST(@Cur_Title_code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)
				
			INSERT INTO #TempCombination
			(
				Agreement_No, Title_Code, Episode_From, Episode_To, Platform_Code, Right_Type, 
				Right_Start_Date, Right_End_Date, Is_Title_Language_Right, Country_Code, Terrirory_Type, Is_exclusive, 
				Subtitling_Language_Code, Dubbing_Language_Code, Data_From, Is_Available, Error_Description,SUM_of,partition_of
			)
			SELECT DISTINCT ADR.Agreement_No, ac.Title_Code, ac.Episode_From, ac.Episode_To, ac.Platform_Code, ADR.Right_Type, 
				ADR.Actual_Right_Start_Date, ADR.Actual_Right_End_Date, ADR.Is_Title_Language_Right, ac.Country_Code, 'I', ADR.Is_Exclusive, 
				0, 0, 'T', 'N', 'View Data', ac.SUM_of, ac.partition_of
			FROM #Temp_Acq_Country ac 
			Inner Join #Acq_Deal_Rights ADR On ADR.Acq_Deal_Rights_Code= ac.Acq_Deal_Rights_Code
			WHERE ADR.Is_Title_Language_Right = 'Y'
		END ------------------------------ END
			
		PRINT 'AD 8 ' + CAST(@Cur_Title_code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)
			
		Begin ----------------- CHECK SUBTITLING AND COUNTRY AND PLATFORM AND TITLE & EPISODE EXISTS OR NOT
			SELECT Distinct tp.Title_Code, tp.Episode_From, tp.Episode_To, tp.Platform_Code, tp.Country_Code, ts.Subtitling_Code
			InTo #Temp_Subtitling
			FROM #Temp_Country tp
			Inner Join @Deal_Rights_Subtitling ts On 1 = 1
				
			PRINT 'AD 8.1 ' + CAST(@Cur_Title_code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)
			
			If Exists(SELECT TOP 1 * FROM @Deal_Rights_Subtitling)
			Begin

				SELECT Acq_Deal_Rights_Code, CASE WHEN sub.Language_Type = 'G' THEN lgd.Language_Code ELSE sub.Language_Code END Language_Code 
				InTo #Acq_Sub FROM (
					SELECT Acq_Deal_Rights_Code, Language_Type, Language_Code, Language_Group_Code 
					FROM Acq_Deal_Rights_Subtitling adrs 
					WHERE Acq_Deal_Rights_Code In (SELECT Acq_Deal_Rights_Code FROM #Acq_Deal_Rights)
				)As sub
				Left Join Language_Group_Details lgd On sub.Language_Group_Code = lgd.Language_Group_Code 
						
				PRINT 'AD 8.2 ' + CAST(@Cur_Title_code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)
			
				Delete FROM #Acq_Sub WHERE Language_Code Not In (SELECT Subtitling_Code FROM @Deal_Rights_Subtitling)

				SELECT tac.*, adrs.Language_Code InTo #Temp_Acq_Subtitling FROM #Temp_Acq_Country tac
				Inner Join #Acq_Sub adrs On tac.Acq_Deal_Rights_Code = adrs.Acq_Deal_Rights_Code 

				Drop Table #Acq_Sub
						
				PRINT 'AD 8.3 ' + CAST(@Cur_Title_code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)
			
				SELECT Distinct DRC.Title_Code, DRC.Episode_From, DRC.Episode_To, DRC.Platform_Code, DRC.Country_Code, DRC.Subtitling_Code InTo #NA_Subtitling
				FROM #Temp_Subtitling DRC
				WHERE DRC.Subtitling_Code Not In (
					SELECT asub.Language_Code FROM #Temp_Acq_Subtitling asub
					WHERE DRC.Title_Code = asub.Title_Code AND DRC.Episode_From = asub.Episode_From AND DRC.Episode_To = asub.Episode_To 
					AND DRC.Platform_Code = asub.Platform_Code AND DRC.Country_Code = asub.Country_Code
				)
						
				PRINT 'AD 8.4 ' + CAST(@Cur_Title_code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)
			
				Delete FROM #Temp_Subtitling WHERE #Temp_Subtitling.Subtitling_Code In (
					SELECT asub.Subtitling_Code FROM #NA_Subtitling asub
					WHERE #Temp_Subtitling.Title_Code = asub.Title_Code AND #Temp_Subtitling.Episode_From = asub.Episode_From AND #Temp_Subtitling.Episode_To = asub.Episode_To 
					AND #Temp_Subtitling.Platform_Code = asub.Platform_Code AND #Temp_Subtitling.Country_Code = asub.Country_Code
				)

				PRINT 'AD 8.5 ' + CAST(@Cur_Title_code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)
			
				Insert InTo #Dup_Records_Language(Agreement_No, Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, Territory_Type,
											Right_Start_Date, Right_End_Date, Right_Type, Is_Sub_License, ErrorMSG, Is_Title_Language_Right, Subtitling_Language, Dubbing_Language
				)
				SELECT '', 0, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, '', 
						@Right_Start_Date, @Right_End_Date, @Right_Type, @Is_Sub_License, 'Subtitling Language not acquired', @Is_Title_Language_Right, Subtitling_Code, 0
				FROM #NA_Subtitling nsub
					
				Drop Table #NA_Subtitling
						
				PRINT 'AD 8.6 ' + CAST(@Cur_Title_code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)
			
				INSERT INTO #TempCombination_Session(Title_Code, Episode_From, Episode_To, Platform_Code, Right_Type, Right_Start_Date, Right_End_Date, Is_Title_Language_Right,
														Country_Code, Terrirory_Type, Is_exclusive, Subtitling_Language_Code, Dubbing_Language_Code,
														Data_From, Is_Available, Error_Description,
														Sum_of,partition_of)
				SELECT DISTINCT T.Title_Code, T.Episode_From, T.Episode_To, T.Platform_Code, @Right_Type, @Right_Start_Date, @Right_End_Date, @Is_Title_Language_Right,
					T.Country_Code, 'I', @Is_Exclusive, Subtitling_Code, 0,
					'S', 'N', 'Session',
					CASE 
						WHEN @Right_End_Date Is Null THEN 0 ELSE DATEDIFF(D, @Right_Start_Date, DATEADD(D, 1, @Right_End_Date))
					END Sum_of,
					CASE 
						WHEN @Right_End_Date Is Null THEN 0 ELSE DATEDIFF(D, @Right_Start_Date, DATEADD(D, 1, @Right_End_Date))
					END partition_of
				FROM #Temp_Subtitling T
						
				PRINT 'AD 8.7 ' + CAST(@Cur_Title_code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)
			
				INSERT INTO #TempCombination
				(
					Agreement_No, Title_Code, Episode_From, Episode_To, Platform_Code, Right_Type, 
					Right_Start_Date, Right_End_Date, Is_Title_Language_Right, Country_Code, Terrirory_Type, Is_exclusive, 
					Subtitling_Language_Code, Dubbing_Language_Code, Data_From, Is_Available, Error_Description,SUM_of,partition_of
				)
				SELECT DISTINCT ADR.Agreement_No, ac.Title_Code, ac.Episode_From, ac.Episode_To, ac.Platform_Code, ADR.Right_Type, 
					ADR.Actual_Right_Start_Date, ADR.Actual_Right_End_Date, ADR.Is_Title_Language_Right, ac.Country_Code, 'I', ADR.Is_Exclusive, 
					Language_Code, 0, 'T', 'N', 'View Data', ac.SUM_of, ac.partition_of
				FROM #Temp_Acq_Subtitling ac 
				Inner Join #Acq_Deal_Rights ADR On ADR.Acq_Deal_Rights_Code= ac.Acq_Deal_Rights_Code
			END
			ELSE
			Begin	
				
				PRINT 'AD 8.8 ' + CAST(@Cur_Title_code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)
			
				Insert InTo #Dup_Records_Language(Agreement_No, Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, Territory_Type,
											Right_Start_Date, Right_End_Date, Right_Type, Is_Sub_License, ErrorMSG, Is_Title_Language_Right, Subtitling_Language, Dubbing_Language
				)
				SELECT '', 0, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, '', 
						@Right_Start_Date, @Right_End_Date, @Right_Type, @Is_Sub_License, 'Subtitling Language not acquired', @Is_Title_Language_Right, Subtitling_Code, 0
				FROM #Temp_Subtitling nsub

			END
		END ------------------------------ END
				
		PRINT 'AD 9 ' + CAST(@Cur_Title_code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)
				
		Begin ----------------- CHECK DUBBING AND COUNTRY AND PLATFORM AND TITLE & EPISODE EXISTS OR NOT

		SELECT Distinct tp.Title_Code, tp.Episode_From, tp.Episode_To, tp.Platform_Code, tp.Country_Code, ts.Dubbing_Code
		InTo #Temp_Dubbing
		FROM #Temp_Country tp
		Inner Join @Deal_Rights_Dubbing ts On 1 = 1

		If Exists(SELECT TOP 1 * FROM @Deal_Rights_Dubbing)
		Begin

			SELECT Acq_Deal_Rights_Code, CASE WHEN dub.Language_Type = 'G' THEN lgd.Language_Code ELSE dub.Language_Code END Language_Code InTo #Acq_Dub
			FROM (
				SELECT Acq_Deal_Rights_Code, Language_Type, Language_Code, Language_Group_Code 
				FROM Acq_Deal_Rights_Dubbing
				WHERE Acq_Deal_Rights_Code In (SELECT Acq_Deal_Rights_Code FROM #Acq_Deal_Rights)
			)As dub
			Left Join Language_Group_Details lgd On dub.Language_Group_Code = lgd.Language_Group_Code 
					
			Delete FROM #Acq_Dub WHERE Language_Code Not In (SELECT Dubbing_Code FROM @Deal_Rights_Dubbing)

			SELECT tac.*, adrs.Language_Code InTo #Temp_Acq_Dubbing FROM #Temp_Acq_Country tac
			Inner Join #Acq_Dub adrs On tac.Acq_Deal_Rights_Code = adrs.Acq_Deal_Rights_Code 

			Drop Table #Acq_Dub
					
			SELECT Distinct DRC.Title_Code, DRC.Episode_From, DRC.Episode_To, DRC.Platform_Code, DRC.Country_Code, DRC.Dubbing_Code InTo #NA_Dubbing
			FROM #Temp_Dubbing DRC
			WHERE DRC.Dubbing_Code Not In (
				SELECT adub.Language_Code FROM #Temp_Acq_Dubbing adub
				WHERE DRC.Title_Code = adub.Title_Code AND DRC.Episode_From = adub.Episode_From AND DRC.Episode_To = adub.Episode_To 
				AND DRC.Platform_Code = adub.Platform_Code AND DRC.Country_Code = adub.Country_Code
			)

			Delete FROM #Temp_Dubbing WHERE #Temp_Dubbing.Dubbing_Code In (
				SELECT adub.Dubbing_Code FROM #NA_Dubbing adub
				WHERE #Temp_Dubbing.Title_Code = adub.Title_Code AND #Temp_Dubbing.Episode_From = adub.Episode_From AND #Temp_Dubbing.Episode_To = adub.Episode_To 
				AND #Temp_Dubbing.Platform_Code = adub.Platform_Code AND #Temp_Dubbing.Country_Code = adub.Country_Code
			)
					
					
			Insert InTo #Dup_Records_Language(Agreement_No, Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, Territory_Type,
										Right_Start_Date, Right_End_Date, Right_Type, Is_Sub_License, ErrorMSG, Is_Title_Language_Right, Subtitling_Language, Dubbing_Language
			)
			SELECT '', 0, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, '', 
					@Right_Start_Date, @Right_End_Date, @Right_Type, @Is_Sub_License, 'Dubbing Language not acquired', @Is_Title_Language_Right, 0, Dubbing_Code
			FROM #NA_Dubbing nsub
					
			Drop Table #NA_Dubbing

			INSERT INTO #TempCombination_Session(Title_Code, Episode_From, Episode_To, Platform_Code, Right_Type, Right_Start_Date, Right_End_Date, Is_Title_Language_Right,
													Country_Code, Terrirory_Type, Is_exclusive, Subtitling_Language_Code, Dubbing_Language_Code,
													Data_From, Is_Available, Error_Description,
													Sum_of,partition_of)
			SELECT DISTINCT T.Title_Code, T.Episode_From, T.Episode_To, T.Platform_Code, @Right_Type, @Right_Start_Date, @Right_End_Date, @Is_Title_Language_Right,
				T.Country_Code, 'I', @Is_Exclusive, 0, Dubbing_Code,
				'S', 'N', 'Session',
				CASE 
					WHEN @Right_End_Date Is Null THEN 0 ELSE DATEDIFF(D, @Right_Start_Date, DATEADD(D, 1, @Right_End_Date))
				END Sum_of,
				CASE 
					WHEN @Right_End_Date Is Null THEN 0 ELSE DATEDIFF(D, @Right_Start_Date, DATEADD(D, 1, @Right_End_Date))
				END partition_of
			FROM #Temp_Dubbing T

			INSERT INTO #TempCombination
			(
				Agreement_No, Title_Code, Episode_From, Episode_To, Platform_Code, Right_Type, 
				Right_Start_Date, Right_End_Date, Is_Title_Language_Right, Country_Code, Terrirory_Type, Is_exclusive, 
				Subtitling_Language_Code, Dubbing_Language_Code, Data_From, Is_Available, Error_Description,SUM_of,partition_of
			)
			SELECT DISTINCT ADR.Agreement_No, ac.Title_Code, ac.Episode_From, ac.Episode_To, ac.Platform_Code, ADR.Right_Type, 
				ADR.Actual_Right_Start_Date, ADR.Actual_Right_End_Date, ADR.Is_Title_Language_Right, ac.Country_Code, 'I', ADR.Is_Exclusive, 
				0, ac.Language_Code, 'T', 'N', 'View Data', ac.SUM_of, ac.partition_of
			FROM #Temp_Acq_Dubbing ac 
			Inner Join #Acq_Deal_Rights ADR On ADR.Acq_Deal_Rights_Code= ac.Acq_Deal_Rights_Code
		END
		ELSE
		Begin
				
			Insert InTo #Dup_Records_Language(Agreement_No, Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, Territory_Type,
										Right_Start_Date, Right_End_Date, Right_Type, Is_Sub_License, ErrorMSG, Is_Title_Language_Right, Subtitling_Language, Dubbing_Language
			)
			SELECT '', 0, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, '', 
					@Right_Start_Date, @Right_End_Date, @Right_Type, @Is_Sub_License, 'Dubbing Language not acquired', @Is_Title_Language_Right, 0, Dubbing_Code
			FROM #Temp_Dubbing nsub

		END
	END ------------------------------ END
			
		PRINT 'AD 10 ' + CAST(@Cur_Title_code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)
		--SELECT COUNT(*) FROM #Temp_Subtitling
		--SELECT COUNT(*) FROM #Temp_Dubbing
		--RETURN
			
		IF(OBJECT_ID('TEMPDB..#TempPromoter') IS NOT NULL)
		BEGIN /*Check Promoter with Subtitle / Dubbing, Country, Platform, Title AND Episode*/
			IF EXISTS (SELECT TOP 1 * FROM #TempPromoter)
			BEGIN

					
				SELECT a.Acq_Deal_Rights_Code, a.Promoter_Group_Code, a.Promoter_Remarks_Code, a.Is_Title_Language_Right, a.SelectedInSyn
				into #AcqPromoter FROM (
				SELECT ADRP.Acq_Deal_Rights_Code AS Acq_Deal_Rights_Code, PG.Promoter_Group_Code AS Promoter_Group_Code, ADRPR.Promoter_Remarks_Code AS Promoter_Remarks_Code, 
				ISNULL(ADR.Is_Title_Language_Right, 'N') AS Is_Title_Language_Right, 'N' AS SelectedInSyn 
				FROM Acq_Deal_Rights ADR
				INNER JOIN Acq_Deal_Rights_Promoter ADRP ON ADR.Acq_Deal_Rights_Code = ADRP.Acq_Deal_Rights_Code
				INNER JOIN Acq_Deal_Rights_Promoter_Group ADRPG ON ADRPG.Acq_Deal_Rights_Promoter_Code = ADRP.Acq_Deal_Rights_Promoter_Code
				INNER JOIN Acq_Deal_Rights_Promoter_Remarks ADRPR ON ADRPR.Acq_Deal_Rights_Promoter_Code = ADRP.Acq_Deal_Rights_Promoter_Code
				INNER JOIN Promoter_Group PG ON PG.Parent_Group_Code = ADRPG.Promoter_Group_Code 
				WHERE ADRP.Acq_Deal_Rights_Code In (SELECT Acq_Deal_Rights_Code FROM #Acq_Deal_Rights)
				UNION
				SELECT ADRP.Acq_Deal_Rights_Code AS Acq_Deal_Rights_Code, ADRPG.Promoter_Group_Code AS Promoter_Group_Code, ADRPR.Promoter_Remarks_Code  AS Promoter_Remarks_Code, 
				ISNULL(ADR.Is_Title_Language_Right, 'N') AS Is_Title_Language_Right, 'N' AS SelectedInSyn 
				FROM Acq_Deal_Rights ADR
				INNER JOIN Acq_Deal_Rights_Promoter ADRP ON ADR.Acq_Deal_Rights_Code = ADRP.Acq_Deal_Rights_Code
				INNER JOIN Acq_Deal_Rights_Promoter_Group ADRPG ON ADRPG.Acq_Deal_Rights_Promoter_Code = ADRP.Acq_Deal_Rights_Promoter_Code
				INNER JOIN Acq_Deal_Rights_Promoter_Remarks ADRPR ON ADRPR.Acq_Deal_Rights_Promoter_Code = ADRP.Acq_Deal_Rights_Promoter_Code
				WHERE ADRP.Acq_Deal_Rights_Code In (SELECT Acq_Deal_Rights_Code FROM #Acq_Deal_Rights)
				) as a

				--SELECT ADRP.Acq_Deal_Rights_Code, PG.Promoter_Group_Code, ADRPR.Promoter_Remarks_Code, 
				--ISNULL(ADR.Is_Title_Language_Right, 'N') AS Is_Title_Language_Right, 'N' AS SelectedInSyn 
				--INTO #AcqPromoter FROM Acq_Deal_Rights ADR
				--INNER JOIN Acq_Deal_Rights_Promoter ADRP ON ADR.Acq_Deal_Rights_Code = ADRP.Acq_Deal_Rights_Code
				--INNER JOIN Acq_Deal_Rights_Promoter_Group ADRPG ON ADRPG.Acq_Deal_Rights_Promoter_Code = ADRP.Acq_Deal_Rights_Promoter_Code
				--INNER JOIN Acq_Deal_Rights_Promoter_Remarks ADRPR ON ADRPR.Acq_Deal_Rights_Promoter_Code = ADRP.Acq_Deal_Rights_Promoter_Code
				--INNER JOIN Promoter_Group PG ON PG.Parent_Group_Code = ADRPG.Promoter_Group_Code 
				--WHERE ADRP.Acq_Deal_Rights_Code In (SELECT Acq_Deal_Rights_Code FROM #Acq_Deal_Rights)

				UPDATE AP SET AP.SelectedInSyn = 'Y' FROM #AcqPromoter AP
				INNER JOIN #TempPromoter SP ON AP.Promoter_Group_Code = SP.Promoter_Group_Code AND AP.Promoter_Remarks_Code = SP.Promoter_Remarks_Code

				DELETE FROM #AcqPromoter WHERE SelectedInSyn <> 'Y'

				/* Start Validation For Promoter with Title Language*/
				IF(@Is_Title_Language_Right = 'Y')
				BEGIN
					SELECT TAC.*, AP.Is_Title_Language_Right, AP.Promoter_Group_Code, AP.Promoter_Remarks_Code 
					INTO #TempAcqPromoter_TL FROM #Temp_Acq_Country TAC
					INNER JOIN #AcqPromoter AP ON AP.Acq_Deal_Rights_Code = TAC.Acq_Deal_Rights_Code --AND AP.Is_Title_Language_Right = 'Y'

					SELECT DISTINCT TC.Title_Code, TC.Episode_From, TC.Episode_To, TC.Platform_Code, TC.Country_Code,
					TP.Promoter_Group_Code, TP.Promoter_Remarks_Code
					INTO #TempPromoter_TL FROM #Temp_Country TC
					INNER JOIN #TempPromoter TP ON 1 = 1


					IF(OBJECT_ID('TEMPDB..#TempPromoter_TL') IS NOT NULL)
					BEGIN
						SELECT DISTINCT TP.Title_Code, TP.Episode_From, TP.Episode_To, TP.Platform_Code, TP.Country_Code,
						TP.Promoter_Group_Code, TP.Promoter_Remarks_Code INTO #NA_Promoter_TL
						FROM #TempPromoter_TL TP WHERE
						CAST(TP.Promoter_Group_Code AS VARCHAR) + '~' + CAST(TP.Promoter_Remarks_Code AS VARCHAR) NOT IN (
							SELECT CAST(TAP.Promoter_Group_Code AS VARCHAR) + '~' + CAST(TAP.Promoter_Remarks_Code AS VARCHAR)
						FROM #TempAcqPromoter_TL TAP
						WHERE TAP.Title_Code = TP.Title_Code AND TAP.Episode_From = TP.Episode_From 
							AND TAP.Episode_To = TP.Episode_To AND TAP.Platform_Code = TP.Platform_Code AND TAP.Country_Code = TP.Country_Code --AND TAP.Is_Title_Language_Right = 'Y'
						)
					END
						
					IF(OBJECT_ID('TEMPDB..#NA_Promoter_TL') IS NOT NULL)
					BEGIN
						INSERT INTO #Dup_Records_Language(
							Agreement_No, Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, 
							Territory_Type,Right_Start_Date, Right_End_Date, Right_Type, Is_Sub_License, ErrorMSG, Is_Title_Language_Right, 
							Subtitling_Language, Dubbing_Language, Promoter_Group_Code, Promoter_Remarks_Code
						)
						SELECT '', 0, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, 
							'', @Right_Start_Date, @Right_End_Date, @Right_Type, @Is_Sub_License, 'Promoter combination not acquired', @Is_Title_Language_Right, 
							0, 0, Promoter_Group_Code, Promoter_Remarks_Code
						FROM #NA_Promoter_TL NPT
					END
					
				END
				/* END Validation For Promoter with Title Language*/
				IF(OBJECT_ID('TEMPDB..#Temp_Subtitling') IS NOT NULL AND OBJECT_ID('TEMPDB..#Temp_Acq_Subtitling') IS NOT NULL) 
				BEGIN 
					/* Start Validation For Promoter with SubTitling*/
					SELECT TAS.*, AP.Promoter_Group_Code, AP.Promoter_Remarks_Code INTO #TempAcqPromoter_Sub
					FROM #Temp_Acq_Subtitling TAS
					INNER JOIN #AcqPromoter AP ON AP.Acq_Deal_Rights_Code = TAS.Acq_Deal_Rights_Code 

					SELECT DISTINCT TS.Title_Code, TS.Episode_From, TS.Episode_To, TS.Platform_Code, TS.Country_Code, TS.Subtitling_Code,
					TP.Promoter_Group_Code, TP.Promoter_Remarks_Code
					INTO #TempPromoter_Sub FROM #Temp_Subtitling TS
					INNER JOIN #TempPromoter TP ON 1 = 1


					IF(OBJECT_ID('TEMPDB..#TempPromoter_Sub') IS NOT NULL)
					BEGIN
						SELECT DISTINCT TP.Title_Code, TP.Episode_From, TP.Episode_To, TP.Platform_Code, TP.Country_Code, TP.Subtitling_Code, 
						TP.Promoter_Group_Code, TP.Promoter_Remarks_Code INTO #NA_Promoter_Sub 
						FROM #TempPromoter_Sub TP WHERE 
						CAST(TP.Promoter_Group_Code AS VARCHAR) + '~' + CAST(TP.Promoter_Remarks_Code AS VARCHAR) NOT IN (
							SELECT CAST(TAP.Promoter_Group_Code AS VARCHAR) + '~' + CAST(TAP.Promoter_Remarks_Code AS VARCHAR) 
							FROM #TempAcqPromoter_Sub TAP 
							WHERE TAP.Title_Code = TP.Title_Code AND TAP.Episode_From = TP.Episode_From AND TAP.Episode_To = TP.Episode_To 
							AND TAP.Platform_Code = TP.Platform_Code AND TAP.Country_Code = TP.Country_Code AND TAP.Language_Code = TP.Subtitling_Code
						)
							
						IF(OBJECT_ID('TEMPDB..#NA_Promoter_Sub') IS NOT NULL)
						BEGIN
							Insert InTo #Dup_Records_Language(
								Agreement_No, Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, 
								Territory_Type,Right_Start_Date, Right_End_Date, Right_Type, Is_Sub_License, ErrorMSG, Is_Title_Language_Right, 
								Subtitling_Language, Dubbing_Language, Promoter_Group_Code, Promoter_Remarks_Code
							)
							SELECT '', 0, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, 
								'', @Right_Start_Date, @Right_End_Date, @Right_Type, @Is_Sub_License, 'Promoter combination not acquired', @Is_Title_Language_Right, 
								Subtitling_Code, 0, Promoter_Group_Code, Promoter_Remarks_Code
							FROM #NA_Promoter_Sub NPS
						END
					END
							
				END /* END Validation For Promoter with SubTitling*/
				IF(OBJECT_ID('TEMPDB..#Temp_Dubbing') IS NOT NULL AND OBJECT_ID('TEMPDB..#Temp_Acq_Dubbing') IS NOT NULL) 
				BEGIN 
					/* Start Validation For Promoter with Dubbing*/
					SELECT TAD.*, AP.Promoter_Group_Code, AP.Promoter_Remarks_Code INTO #TempAcqPromoter_Dub
					FROM #Temp_Acq_Dubbing TAD
					INNER JOIN #AcqPromoter AP ON AP.Acq_Deal_Rights_Code = TAD.Acq_Deal_Rights_Code

					SELECT DISTINCT TD.Title_Code, TD.Episode_From, TD.Episode_To, TD.Platform_Code, TD.Country_Code, TD.Dubbing_Code,
					TP.Promoter_Group_Code, TP.Promoter_Remarks_Code
					INTO #TempPromoter_Dub FROM #Temp_Dubbing TD
					INNER JOIN #TempPromoter TP ON 1 = 1

					IF(OBJECT_ID('TEMPDB..#TempPromoter_Dub') IS NOT NULL)
					BEGIN
						SELECT DISTINCT TP.Title_Code, TP.Episode_From, TP.Episode_To, TP.Platform_Code, TP.Country_Code, TP.Dubbing_Code,  
						TP.Promoter_Group_Code, TP.Promoter_Remarks_Code INTO #NA_Promoter_Dub 
						FROM #TempPromoter_Dub TP WHERE 
						CAST(TP.Promoter_Group_Code AS VARCHAR) + '~' + CAST(TP.Promoter_Remarks_Code AS VARCHAR) NOT IN (
							SELECT CAST(TAP.Promoter_Group_Code AS VARCHAR) + '~' + CAST(TAP.Promoter_Remarks_Code AS VARCHAR) FROM #TempAcqPromoter_Dub TAP 
							WHERE TAP.Title_Code = TP.Title_Code AND TAP.Episode_From = TP.Episode_From AND TAP.Episode_To = TP.Episode_To 
							AND TAP.Platform_Code = TP.Platform_Code AND TAP.Country_Code = TP.Country_Code AND TAP.Language_Code = TP.Dubbing_Code
						)
						IF(OBJECT_ID('TEMPDB..#NA_Promoter_Dub') IS NOT NULL)
						BEGIN
							
							Insert InTo #Dup_Records_Language(Agreement_No, Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, 
								Territory_Type,Right_Start_Date, Right_End_Date, Right_Type, Is_Sub_License, ErrorMSG, Is_Title_Language_Right, 
								Subtitling_Language, Dubbing_Language, Promoter_Group_Code, Promoter_Remarks_Code)
							SELECT '', 0, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, 
								'', @Right_Start_Date, @Right_End_Date, @Right_Type, @Is_Sub_License, 'Promoter combination not acquired', @Is_Title_Language_Right, 
								0, Dubbing_Code, Promoter_Group_Code, Promoter_Remarks_Code
							FROM #NA_Promoter_Dub NPD

							--DELETE TP FROM #TempPromoter_Dub TP
							--INNER JOIN #NA_Promoter_Dub NTP ON NTP.Title_Code = TP.Title_Code AND NTP.Episode_From = TP.Episode_From AND NTP.Episode_To = TP.Episode_To 
							--AND NTP.Platform_Code = TP.Platform_Code AND NTP.Country_Code = TP.Country_Code AND NTP.Dubbing_Code = TP.Dubbing_Code
							--AND NTP.Promoter_Group_Code = TP.Promoter_Group_Code AND NTP.Promoter_Remarks_Code = TP.Promoter_Remarks_Code
						END
					END
						
				END
				/* END Validation For Promoter with Dubbing*/
			END
		END
			
		PRINT 'AD 11 ' + CAST(@Cur_Title_code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)
			
		IF OBJECT_ID('TEMPDB..#Temp_Country') IS NOT NULL DROP TABLE #Temp_Country
		--IF(OBJECT_ID('TEMPDB..#Temp_Acq_Subtitling') IS NOT NULL) DROP TABLE #Temp_Acq_Subtitling
		--IF(OBJECT_ID('TEMPDB..#Temp_Acq_Dubbing') IS NOT NULL) DROP TABLE #Temp_Acq_Dubbing
		IF(OBJECT_ID('TEMPDB..#Temp_Subtitling') IS NOT NULL) DROP TABLE #Temp_Subtitling
		IF(OBJECT_ID('TEMPDB..#Temp_Dubbing') IS NOT NULL) DROP TABLE #Temp_Dubbing
		IF(OBJECT_ID('TEMPDB..#TempPromoter') IS NOT NULL) DROP TABLE #TempPromoter
		IF(OBJECT_ID('TEMPDB..#AcqPromoter') IS NOT NULL) DROP TABLE #AcqPromoter
		IF(OBJECT_ID('TEMPDB..#TempAcqPromoter_TL') IS NOT NULL) DROP TABLE #TempAcqPromoter_TL
		IF(OBJECT_ID('TEMPDB..#TempPromoter_TL') IS NOT NULL) DROP TABLE #TempPromoter_TL
		IF(OBJECT_ID('TEMPDB..#NA_Promoter_TL') IS NOT NULL) DROP TABLE #NA_Promoter_TL
		IF(OBJECT_ID('TEMPDB..#TempAcqPromoter_Sub') IS NOT NULL) DROP TABLE #TempAcqPromoter_Sub
		IF(OBJECT_ID('TEMPDB..#TempPromoter_Sub') IS NOT NULL) DROP TABLE #TempPromoter_Sub
		IF(OBJECT_ID('TEMPDB..#NA_Promoter_Sub') IS NOT NULL) DROP TABLE #NA_Promoter_Sub
		IF(OBJECT_ID('TEMPDB..#TempAcqPromoter_Dub') IS NOT NULL) DROP TABLE #TempAcqPromoter_Dub
		IF(OBJECT_ID('TEMPDB..#TempPromoter_Dub') IS NOT NULL) DROP TABLE #TempPromoter_Dub
		IF(OBJECT_ID('TEMPDB..#NA_Promoter_Dub') IS NOT NULL) DROP TABLE #NA_Promoter_Dub
		--IF(OBJECT_ID('TEMPDB..#Temp_Acq_Country') IS NOT NULL) Drop Table #Temp_Acq_Country
		--IF(OBJECT_ID('TEMPDB..#Temp_Acq_Subtitling') IS NOT NULL) Drop Table #Temp_Acq_Subtitling
		--IF(OBJECT_ID('TEMPDB..#Temp_Acq_Dubbing') IS NOT NULL) Drop Table #Temp_Acq_Dubbing
				
		--IF(OBJECT_ID('TEMPDB..#Acq_Deal_Rights') IS NOT NULL) Drop Table #Acq_Deal_Rights

		UPDATE b SET b.Sum_of = (
			SELECT SUM(c.Sum_of) FROM(
				SELECT DISTINCT a.Title_Code, a.Episode_From, a.Episode_To, a.Platform_Code, a.Country_Code, a.Subtitling_Language_Code, 
				a.Dubbing_Language_Code, a.Promoter_Group_Code, a.Promoter_Remarks_Code, a.Sum_of FROM #TempCombination AS a
			) AS c WHERE c.Title_Code = b.Title_Code AND c.Episode_From = b.Episode_From AND c.Episode_To = b.Episode_To AND
			c.Platform_Code = b.Platform_Code AND c.Country_Code = b.Country_Code AND c.Subtitling_Language_Code = b.Subtitling_Language_Code AND 
			c.Dubbing_Language_Code = b.Dubbing_Language_Code AND ISNULL(c.Promoter_Group_Code,0) = ISNULL(b.Promoter_Group_Code,0) AND
			ISNULL(c.Promoter_Remarks_Code,0) = ISNULL(b.Promoter_Remarks_Code,0)
							 
		) FROM #TempCombination b			
				
		PRINT 'AD 12 ' + CAST(@Cur_Title_code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)
			
		CREATE TABLE #Min_Right_Start_Date
		(
			Title_Code INT,
			Min_Start_Date DateTime
		)
			
		INSERT INTO #Min_Right_Start_Date
		SELECT T1.Title_Code,MIN(T1.Right_Start_Date) FROM  #TempCombination T1
		GROUP BY T1.Title_Code
			
		IF(@Right_Type ='U' AND EXISTS(SELECT TOP 1 Right_Type FROM #TempCombination WHERE Right_Type='U') AND NOT EXISTS(SELECT TOP 1 Right_Type FROM #TempCombination WHERE Right_Type='Y'))
		BEGIN				
			DELETE T1 				
			FROM #TempCombination T1 
			INNER JOIN #Min_Right_Start_Date MRSD ON T1.Title_Code = MRSD.Title_Code
			WHERE CONVERT(DATETIME, @Right_Start_Date, 103) < CONVERT(DATETIME, ISNULL(T1.Right_Start_Date,''), 103)				
		END
				
		PRINT 'AD 13 ' + CAST(@Cur_Title_code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)
			
		UPDATE t2 Set t2.Is_Available = 'Y'
		FROM #TempCombination_Session t2 
		LEFT join #Min_Right_Start_Date MRSD on T2.Title_Code = MRSD.Title_Code
		Inner Join #TempCombination t1 On 
		T1.Title_Code = T2.Title_Code AND 
		T1.Episode_From = T2.Episode_From AND 
		T1.Episode_To = T2.Episode_To AND 
		T1.Platform_Code = T2.Platform_Code AND 
		T1.Country_Code= T2.Country_Code AND 
		T1.Subtitling_Language_Code = T2.Subtitling_Language_Code AND 
		T1.Dubbing_Language_Code = T2.Dubbing_Language_Code  
		AND
		ISNULL(T1.Promoter_Group_Code,'') = ISNULL(T2.Promoter_Group_Code,'') AND 
		ISNULL(T1.Promoter_Remarks_Code,'') = ISNULL(T2.Promoter_Remarks_Code,'')
		AND 
		(
			(
				(t1.sum_of = (CASE WHEN T2.Right_Type != 'U' THEN DATEDIFF(d,@Right_Start_Date,DATEADD(d,1,@Right_End_Date))  ELSE 0 END)) OR
				(
					(T1.Right_Type = 'U' OR T2.Right_Type = 'U') AND
					(CONVERT(DATETIME, @Right_Start_Date, 103) >= CONVERT(DATETIME, ISNULL(MRSD.MIN_Start_DATE,t1.Right_Start_Date), 103))
				)
			)OR
			(t1.Partition_Of = (CASE WHEN T2.Right_Type != 'U' THEN DATEDIFF(d,@Right_Start_Date,DATEADD(d,1,@Right_End_Date))  ELSE 0 END))
		)AND 
		(
			((T1.Right_Type <> 'Y'  AND T1.Right_Type <> 'M') AND T2.Right_Type = 'U') OR
			((T1.Right_Type = 'Y' OR T1.Right_Type = 'M') AND (T2.Right_Type = 'Y' OR T2.Right_Type = 'M')) OR
			(T1.Right_Type = 'U' AND (T2.Right_Type = 'Y' OR T2.Right_Type = 'M'))
		)
		DROP TABLE #Min_Right_Start_Date
				
		PRINT 'AD 14 ' + CAST(@Cur_Title_code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)
			
		UPDATE TCS Set TCS.Error_Description = (
			CASE  
				WHEN (
					SELECT COUNT(*) Title_Code FROM #TempCombination TC WHERE TCS.Title_Code = TC.Title_Code
				) = 0 THEN 'TITLE_MISMATCH' ELSE '' 
			END + 
			CASE 
				WHEN (
					SELECT COUNT(*) FROM #TempCombination TC WHERE TCS.Title_Code = TC.Title_Code AND TC.Platform_Code = TCS.Platform_Code
				) = 0 THEN 'PLATFORM_MISMATCH' ELSE '' 
			END +
			CASE 
				WHEN (
					SELECT COUNT(*) Title_Code FROM #TempCombination TC WHERE TCS.Title_Code = TC.Title_Code 
					AND TC.Platform_Code = TCS.Platform_Code AND TC.Country_Code = TCS.Country_Code
				) = 0 THEN 'COUNTRY_MISMATCH' ELSE '' 
			END +
			CASE 
				WHEN TCS.Is_Title_Language_Right = 'Y' AND TCS.Subtitling_Language_Code = 0 AND TCS.Dubbing_Language_Code = 0 AND (
					SELECT COUNT(*) Title_Code FROM #TempCombination TC WHERE TCS.Title_Code = TC.Title_Code AND TC.Platform_Code = TCS.Platform_Code
					AND TC.Country_Code = TCS.Country_Code AND TCS.Subtitling_Language_Code = 0 AND 0 = TCS.Dubbing_Language_Code 
					AND TCS.Is_Title_Language_Right = TC.Is_Title_Language_Right
				) = 0 THEN 'TITLE_LANGAUGE_RIGHT' ELSE '' 
			END +
			CASE 
				WHEN TCS.Dubbing_Language_Code > 0 AND (
					SELECT COUNT(*) Title_Code FROM #TempCombination TC WHERE TCS.Title_Code = TC.Title_Code AND TC.Platform_Code = TCS.Platform_Code
					AND TC.Country_Code = TCS.Country_Code AND TCS.Subtitling_Language_Code = 0 
					AND TC.Dubbing_Language_Code = TCS.Dubbing_Language_Code
				) = 0 THEN 'DUBBING_LANGAUGE_RIGHT' ELSE '' 
			END +
			CASE 
				WHEN TCS.Subtitling_Language_Code > 0 AND (SELECT COUNT(*) Title_Code FROM #TempCombination TC 
							WHERE TCS.Title_Code = TC.Title_Code AND TC.Platform_Code = TCS.Platform_Code
									AND TC.Country_Code = TCS.Country_Code AND TCS.Subtitling_Language_Code = TC.Subtitling_Language_Code
									AND 0 = TCS.Dubbing_Language_Code) = 0 
				THEN 'SUBTITLING_LANGAUGE_RIGHT' ELSE '' 
			END +
			CASE 
				WHEN (SELECT COUNT(*) Title_Code FROM #TempCombination TC WHERE TCS.Title_Code = TC.Title_Code AND TC.Platform_Code = TCS.Platform_Code
					AND TC.Country_Code = TCS.Country_Code AND TCS.Subtitling_Language_Code = TC.Subtitling_Language_Code
					AND TC.Dubbing_Language_Code = TCS.Dubbing_Language_Code AND (
						( 
							(TCS.sum_of = (CASE WHEN TC.Right_Type != 'U' THEN DATEDIFF(d,@Right_Start_Date,DATEADD(d,1,@Right_End_Date))  ELSE 0 END))OR
							(
								(TCS.Right_Type = 'U' OR TC.Right_Type = 'U') AND
								(CONVERT(DATETIME, @Right_Start_Date, 103) >= CONVERT(DATETIME, ISNULL(TCS.Right_Start_Date,'') , 103))
							)
						)OR
						(TCS.partition_of = (CASE WHEN TC.Right_Type != 'U' THEN DATEDIFF(d,@Right_Start_Date,DATEADD(d,1,@Right_End_Date))  ELSE 0 END))           
					)
				) = 0 THEN 'RIGHT_PERIOD' ELSE '' 
			END
		) FROM #TempCombination_Session TCS
		WHERE Is_Available='N'
			
		PRINT 'AD 15 ' + CAST(@Cur_Title_code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)
			
		--SELECT Error_Description, * FROM #TempCombination_Session WHERE Title_Code = 5159 AND Is_Available='N'
		UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'TITLE_MISMATCHPLATFORM_MISMATCHCOUNTRY_MISMATCHTITLE_LANGAUGE_RIGHTSUBTITLING_LANGAUGE_RIGHTRIGHT_PERIOD', 'Title not acquired') WHERE Is_Available='N'
		UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'TITLE_MISMATCHPLATFORM_MISMATCHCOUNTRY_MISMATCHDUBBING_LANGAUGE_RIGHTRIGHT_PERIOD', 'Dubbing Language not acquired') WHERE Is_Available='N'
		UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'TITLE_MISMATCHPLATFORM_MISMATCHCOUNTRY_MISMATCHSUBTITLING_LANGAUGE_RIGHTRIGHT_PERIOD', 'Subtitling Language not acquired') WHERE Is_Available='N'
		UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'TITLE_MISMATCHPLATFORM_MISMATCHCOUNTRY_MISMATCHTITLE_LANGAUGE_RIGHTRIGHT_PERIOD', 'Title Language not acquired') WHERE Is_Available='N'
			
		UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'PLATFORM_MISMATCHCOUNTRY_MISMATCHTITLE_LANGAUGE_RIGHTSUBTITLING_LANGAUGE_RIGHTRIGHT_PERIOD', 'Platform not acquired')WHERE Is_Available='N'
		UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'PLATFORM_MISMATCHCOUNTRY_MISMATCHDUBBING_LANGAUGE_RIGHTRIGHT_PERIOD', 'Platform not acquired') WHERE Is_Available='N'
		UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'PLATFORM_MISMATCHCOUNTRY_MISMATCHSUBTITLING_LANGAUGE_RIGHTRIGHT_PERIOD', 'Platform not acquired')WHERE Is_Available='N'
		UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'PLATFORM_MISMATCHCOUNTRY_MISMATCHTITLE_LANGAUGE_RIGHTRIGHT_PERIOD', 'Platform not acquired')WHERE Is_Available='N'

		UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'TITLE_LANGAUGE_RIGHTSUBTITLING_LANGAUGE_RIGHTRIGHT_PERIOD', 'TITLE_LANGAUGE_RIGHT&SUBTITLING_LANGAUGE_RIGHT') WHERE Is_Available='N'
		UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'TITLE_LANGAUGE_RIGHTSUBTITLING_LANGAUGE_RIGHT', 'TITLE_LANGAUGE_RIGHT&SUBTITLING_LANGAUGE_RIGHT') WHERE Is_Available='N'

		UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'TITLE_LANGAUGE_RIGHTDUBBING_LANGAUGE_RIGHTRIGHT_PERIOD', 'TITLE_LANGAUGE_RIGHT&DUBBING_LANGAUGE_RIGHT') WHERE Is_Available='N'
		UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'TITLE_LANGAUGE_RIGHTDUBBING_LANGAUGE_RIGHT', 'TITLE_LANGAUGE_RIGHT&DUBBING_LANGAUGE_RIGHT') WHERE Is_Available='N'
			
		UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'TITLE_MISMATCHPLATFORM_MISMATCH', 'Title not acquired') WHERE Is_Available='N'

		UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'COUNTRY_MISMATCHTITLE_LANGAUGE_RIGHTRIGHT_PERIOD', 'Region not acquired')WHERE Is_Available='N'

		UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'SUBTITLING_LANGAUGE_RIGHTRIGHT_PERIOD', 'Subtitling Language not acquired')WHERE Is_Available='N'
		UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'DUBBING_LANGAUGE_RIGHTRIGHT_PERIOD', 'Dubbing Language not acquired')WHERE Is_Available='N'
		UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'TITLE_LANGAUGE_RIGHTRIGHT_PERIOD', 'Title Language not acquired')WHERE Is_Available='N'

		UPDATE #TempCombination_Session Set Error_Description = ' Rights period mismatch' WHERE Is_Available='N' AND Error_Description = ''
				
		PRINT 'AD 16 ' + CAST(@Cur_Title_code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)
			
		Insert InTo #Dup_Records_Language(Agreement_No, Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, Territory_Type,
											Right_Start_Date, Right_End_Date, Right_Type, Is_Sub_License, ErrorMSG, Is_Title_Language_Right, Subtitling_Language, Dubbing_Language
		)
		SELECT '', 0, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, '', 
				--Right_Start_Date, Right_End_Date, Right_Type, @Is_Sub_License, 'Rights Period Mismatch', Is_Title_Language_Right, Subtitling_Language_Code, Dubbing_Language_Code
				Right_Start_Date, Right_End_Date, Right_Type, @Is_Sub_License, Error_Description, Is_Title_Language_Right, Subtitling_Language_Code, Dubbing_Language_Code
		FROM #TempCombination_Session nsub WHERE Is_Available='N'
				
		PRINT 'AD 17 ' + CAST(@Cur_Title_code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)
			
		Declare @Deal_Type_Code Int = 0, @Deal_Type Varchar(20) = '', @Syn_Error CHAR(1) = 'N'
		SELECT @Deal_Type_Code = Deal_Type_Code FROM Syn_Deal WHERE Syn_Deal_Code = @Deal_Code
		SELECT @Deal_Type = [dbo].[UFN_GetDealTypeCondition](@Deal_Type_Code)
			
		--IF(ISNULL(@Is_Autopush, 'N') = 'Y')
		--BEGIN
		--	EXEC  [dbo].[USP_Syn_Autopush_Rights_Validation] @Syn_Deal_Rights_Code, @Syn_Error OUTPUT
		--END
			
		--SELECT @Syn_Error 

		If Exists(SELECT TOP 1 * FROM #Dup_Records_Language)
		Begin

			Insert InTo Syn_Deal_Rights_Error_Details(Syn_Deal_Rights_Code, Title_Name, Platform_Name, Right_Start_Date, Right_End_Date, 
														Right_Type, 
														Is_Sub_Licence, 
														Is_Title_Language_Right, 
														Country_Name, 
														Subtitling_Language, 
														Dubbing_Language, 
														Agreement_No, 
														Promoter_Group_Name,
														Promoter_Remark_DESC,
														ErrorMsg, Episode_From, Episode_To, Inserted_On, IsPushback)
			SELECT @Syn_Deal_Rights_Code, Title_Name, abcd.Platform_Hiearachy Platform_Name, Right_Start_Date as Right_Start_Date, Right_End_Date as Right_End_Date,
				CASE WHEN Right_Type = 'Y' THEN 'Year Based' WHEN Right_Type = 'U' THEN 'Perpetuity' ELSE 'Milestone' END Right_Type,
				CASE WHEN Is_Sub_License = 'Y'	THEN 'Yes' ELSE 'No' END Is_Sub_License,
				CASE WHEN Is_Title_Language_Right = 'Y' THEN 'Yes' ELSE 'No' END Is_Title_Language_Right,
				Country_Name,
				CASE WHEN ISNULL(Subtitling_Language,'')='' THEN 'NA' ELSE Subtitling_Language END Subtitling_Language,
				CASE WHEN ISNULL(Dubbing_Language,'')='' THEN 'NA' ELSE Dubbing_Language END Dubbing_Language,
				Agreement_No, Promoter_Group_Name, Promoter_Remark_Desc, 
				ISNULL(ErrorMSG ,'NA') ErrorMSG, Episode_From, Episode_To, GETDATE(), 'N'
			FROM(
				SELECT *,
				STUFF
				(
					(
					SELECT ', ' + C.Country_Name FROM Country C 
					WHERE c.Country_Code In(
						SELECT Distinct Country_Code FROM #Dup_Records_Language adrn
						WHERE a.Title_Code = adrn.Title_Code 
							AND a.Right_Start_Date = adrn.Right_Start_Date
							AND ISNULL(a.Right_End_Date,'') = ISNULL(adrn.Right_End_Date,'')
							AND a.Episode_From = adrn.Episode_From 
							AND a.Episode_To = adrn.Episode_To 
							AND ISNULL(a.Is_Sub_License,'') = ISNULL(adrn.Is_Sub_License,'') 
							AND ISNULL(a.Is_Title_Language_Right,'') = ISNULL(adrn.Is_Title_Language_Right,'')
							AND a.ErrorMSG = adrn.ErrorMSG
					) --AND C.Country_Code in (SELECT distinct Country_Code FROM #Deal_Rights_Territory)
					FOR XML PATH('')), 1, 1, ''
				) as Country_Name,
				STUFF
				(
					(
					SELECT ',' + CAST(P.Platform_Code as Varchar) 
					FROM Platform p WHERE p.Platform_Code In
					(
						SELECT Distinct Platform_Code FROM #Dup_Records_Language adrn
						WHERE a.Title_Code = adrn.Title_Code 
							AND a.Right_Start_Date = adrn.Right_Start_Date
							AND ISNULL(a.Right_End_Date,'') = ISNULL(adrn.Right_End_Date,'')
							AND a.Episode_From = adrn.Episode_From 
							AND a.Episode_To = adrn.Episode_To 
							AND ISNULL(a.Is_Sub_License,'') = ISNULL(adrn.Is_Sub_License,'') 
							AND ISNULL(a.Is_Title_Language_Right,'') = ISNULL(adrn.Is_Title_Language_Right,'')
							AND a.ErrorMSG = adrn.ErrorMSG
					)
					FOR XML PATH('')), 1, 1, ''
				) as Platform_Code,
				STUFF
				(
					(
					SELECT ', ' + l.Language_Name FROM Language l 
					WHERE l.Language_Code In(
						SELECT Distinct Subtitling_Language FROM #Dup_Records_Language adrn
						WHERE a.Title_Code = adrn.Title_Code 
							AND a.Right_Start_Date = adrn.Right_Start_Date
							AND ISNULL(a.Right_End_Date,'') = ISNULL(adrn.Right_End_Date,'')
							AND a.Episode_From = adrn.Episode_From 
							AND a.Episode_To = adrn.Episode_To 
							AND ISNULL(a.Is_Sub_License,'') = ISNULL(adrn.Is_Sub_License,'') 
							AND ISNULL(a.Is_Title_Language_Right,'') = ISNULL(adrn.Is_Title_Language_Right,'')
							AND a.ErrorMSG = adrn.ErrorMSG
					)
					FOR XML PATH('')), 1, 1, ''
				) as Subtitling_Language,
				STUFF
				(
					(
					SELECT ', ' + l.Language_Name FROM Language l 
					WHERE l.Language_Code In(
						SELECT Distinct Dubbing_Language FROM #Dup_Records_Language adrn
						WHERE a.Title_Code = adrn.Title_Code 
							AND a.Right_Start_Date = adrn.Right_Start_Date
							AND ISNULL(a.Right_End_Date,'') = ISNULL(adrn.Right_End_Date,'')
							AND a.Episode_From = adrn.Episode_From 
							AND a.Episode_To = adrn.Episode_To 
							AND ISNULL(a.Is_Sub_License,'') = ISNULL(adrn.Is_Sub_License,'') 
							AND ISNULL(a.Is_Title_Language_Right,'') = ISNULL(adrn.Is_Title_Language_Right,'')
							AND a.ErrorMSG = adrn.ErrorMSG
					)
					FOR XML PATH('')), 1, 1, ''
				) as Dubbing_Language,
				STUFF
				(
					(
					SELECT ', ' + t.Agreement_No FROM (
						SELECT Distinct Agreement_No FROM #Dup_Records_Language adrn
						WHERE a.Title_Code = adrn.Title_Code 
							AND a.Right_Start_Date = adrn.Right_Start_Date
							AND ISNULL(a.Right_End_Date,'') = ISNULL(adrn.Right_End_Date,'')
							AND a.Episode_From = adrn.Episode_From 
							AND a.Episode_To = adrn.Episode_To 
							AND ISNULL(a.Is_Sub_License,'') = ISNULL(adrn.Is_Sub_License,'') 
							AND ISNULL(a.Is_Title_Language_Right,'') = ISNULL(adrn.Is_Title_Language_Right,'')
							AND a.ErrorMSG = adrn.ErrorMSG
					) As t
					FOR XML PATH('')), 1, 1, ''
				) as Agreement_No
				FROM (
					SELECT T.Title_Code,
						DBO.UFN_GetTitleNameInFormat(@Deal_Type, T.Title_Name, Episode_From, Episode_To) AS Title_Name,
						ADR.Right_Start_Date, ADR.Right_End_Date,
						Is_Sub_License, Is_Title_Language_Right, ADR.ErrorMSG, Right_Type, Episode_From, Episode_To,
						PG.Hierarchy_Name AS Promoter_Group_Name , PR.Promoter_Remark_Desc
					FROM (
						SELECT Distinct Title_Code, Episode_From, Episode_To, Right_Start_Date, Right_End_Date, Is_Sub_License,
							Is_Title_Language_Right, ErrorMSG, Right_Type, Promoter_Group_Code, Promoter_Remarks_Code
						FROM #Dup_Records_Language
					) ADR
					INNER JOIN Title T ON T.Title_Code=ADR.Title_Code
					LEFT JOIN Promoter_Remarks PR ON PR.Promoter_Remarks_Code = ADR.Promoter_Remarks_Code
					LEFT JOIN Promoter_Group PG ON PG.Promoter_Group_Code = ADR.Promoter_Group_Code
				) as a
			) as MainOutput
			Cross Apply
			(
				SELECT * FROM [dbo].[UFN_Get_Platform_With_Parent](MainOutput.Platform_Code)
			) as abcd

			UPDATE Syn_Deal_Rights Set Right_Status = 'E' WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code

			Set @Is_Error = 'Y'
		END
		--ELSE If(@Is_Error = 'N')
		--Begin
		--	UPDATE Syn_Deal_Rights Set Right_Status = 'C' WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
		--END
				
		PRINT 'AD 18 ' + CAST(@Cur_Title_code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)
		TRUNCATE TABLE #TempCombination_Session
		TRUNCATE TABLE #TempCombination
		TRUNCATE TABLE #Dup_Records_Language
				
		PRINT 'AD 19 ' + CAST(@Syn_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)
		--IF(OBJECT_ID('TEMPDB..#Temp_Episode_No') IS NOT NULL) Drop Table #Temp_Episode_No
		--IF(OBJECT_ID('TEMPDB..#Deal_Right_Title_WithEpsNo') IS NOT NULL) Drop Table #Deal_Right_Title_WithEpsNo
		--IF(OBJECT_ID('TEMPDB..#Acq_Deal_Rights') IS NOT NULL) Drop Table #Acq_Deal_Rights

		------------------- LEVEL 1 CURSOR END

		IF(@Syn_Error = 'Y' OR @Is_Error = 'Y')
		BEGIN
			UPDATE Syn_Deal_Rights Set Right_Status = 'E' WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
		END
		--ELSE
		--BEGIN
		--	UPDATE Syn_Deal_Rights Set Right_Status = 'C' WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
		--END

		--Drop Table #TempCombination
		--Drop Table #TempCombination_Session
			
		Begin  ------------------------ SYNDICATION DUPLICATION VALIDATION

	
			Create Table #Syn_Deal_Rights_Subtitling
			(
				Syn_Deal_Rights_Code int 
				,Language_Type varchar(100)
				,Language_Group_Code int 
				,Language_Code int
			)
			
			Create Table #Syn_Deal_Rights_Dubbing
			(
				Syn_Deal_Rights_Code int 
				,Language_Type varchar(100)
				,Language_Group_Code int 
				,Language_Code int
			)

			Create Table #Syn_Rights_Code_Lang
			(
				Deal_Rights_Code int
			)

			--SELECT * FROM Syn_Acq_Mapping WHERE Syn_Deal_Rights_Code = @Deal_Rights_Code

			CREATE TABLE #NotInSynRights
			(
				Syn_Deal_Rights_Code INT,
				Acq_Deal_Rights_Code INT
			)

			DECLARE @ValidationStage VARCHAR(2) = 'S2'
			IF EXISTS(SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE ISNULL(Buyback_Syn_Rights_Code, 0) = @Deal_Rights_Code)
			BEGIN

				INSERT INTO #NotInSynRights(Syn_Deal_Rights_Code)
				SELECT Syn_Deal_Rights_Code FROM Syn_Acq_Mapping WHERE Deal_Rights_Code IN (
					SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE ISNULL(Buyback_Syn_Rights_Code, 0) = @Deal_Rights_Code
				)
				
			END
			ELSE
			BEGIN

				SET @ValidationStage = 'S4'

				INSERT INTO #NotInSynRights(Syn_Deal_Rights_Code, Acq_Deal_Rights_Code)
				SELECT DISTINCT ISNULL(Buyback_Syn_Rights_Code, 0), Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Rights_Code IN (
					SELECT Deal_Rights_Code FROM Syn_Acq_Mapping WHERE Syn_Deal_Rights_Code = @Deal_Rights_Code 
				) AND ISNULL(Buyback_Syn_Rights_Code, 0) > 0

				--SELECT DISTINCT ISNULL(Buyback_Syn_Rights_Code, 0), Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Rights_Code IN (
				--	SELECT Deal_Rights_Code FROM Syn_Acq_Mapping WHERE Syn_Deal_Rights_Code = @Deal_Rights_Code 
				--) AND ISNULL(Buyback_Syn_Rights_Code, 0) > 0

				--SELECT * FROM Syn_Acq_Mapping WHERE Syn_Deal_Rights_Code = @Deal_Rights_Code 

			END
				
			SELECT SDR.Syn_Deal_Rights_Code, SDR.Actual_Right_Start_Date, SDR.Actual_Right_End_Date, SDR.Right_Type, SDR.Is_Title_Language_Right, SDR.Syn_Deal_Code,
					(SELECT COUNT(*) FROM Syn_Deal_Rights_Subtitling a WHERE a.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code) Sub_Cnt,
					(SELECT COUNT(*) FROM Syn_Deal_Rights_Dubbing a WHERE a.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code) Dub_Cnt, 
					Is_Sub_License, Is_Exclusive, Is_Pushback
					InTo #Syn_Deal_Rights
			FROM Syn_Deal_Rights SDR
			inner join Syn_Deal SD ON SD.Syn_Deal_Code = SDR.Syn_Deal_Code
			WHERE SD.Deal_Workflow_Status NOT IN ('AR') AND
			(
				(
					SDR.Right_Type ='Y'
					AND
					(
						(
							CONVERT(DATETIME, @Right_Start_Date, 103)  BETWEEN
							CONVERT(DATETIME, SDR.Actual_Right_Start_Date, 103) AND CONVERT(DATETIME, SDR.Actual_Right_End_Date, 103)
						)
						OR
						(
							CONVERT(DATETIME, @Right_End_Date, 103)   BETWEEN 
							CONVERT(DATETIME, SDR.Actual_Right_Start_Date, 103) AND CONVERT(DATETIME, SDR.Actual_Right_End_Date, 103)
						)
						OR
						(
							CONVERT(DATETIME, SDR.Actual_Right_Start_Date, 103) BETWEEN
							CONVERT(DATETIME, @Right_Start_Date, 103) AND CONVERT(DATETIME, @Right_End_Date, 103)
						)
						AND
						(
							CONVERT(DATETIME, SDR.Actual_Right_End_Date, 103) BETWEEN 
							CONVERT(DATETIME, @Right_Start_Date, 103) AND CONVERT(DATETIME, @Right_End_Date, 103)
						)
					)
				)
				OR
				(
					(SDR.Right_Type ='U'  AND @Right_Type='U')	
					OR
					(
						(SDR.Right_Type ='U' AND @Right_Type='Y')
						AND
						(					
							CONVERT(DATETIME, @Right_End_Date, 103) >= CONVERT(DATETIME, SDR.Actual_Right_Start_Date, 103)				
						)
					)
					OR
					(
						(SDR.Right_Type ='Y'  AND @Right_Type='U')					
						AND
						(
							CONVERT(DATETIME, @Right_Start_Date, 103)  BETWEEN 
							CONVERT(DATETIME, SDR.Actual_Right_Start_Date, 103) AND CONVERT(DATETIME, SDR.Actual_Right_End_Date, 103)
						)
					)
				)
			)
			AND
			(
				(
					@CallFrom = 'SP' AND (
						ISNULL(Is_Pushback, 'N') = 'N' OR (SDR.Syn_Deal_Code = @Deal_Code AND @IS_PUSH_BACK_SAME_DEAL = 'Y')
					)
				)
				OR
				(
					(@CallFrom = 'SR')
					AND 
					(
						(ISNULL(Is_Exclusive, 'N') = 'Y' AND @Is_Exclusive ='N')
						OR ((ISNULL(Is_Exclusive,'N') = 'N' OR ISNULL(Is_Exclusive,'N') IN ('Y', 'C')) AND @Is_Exclusive IN ('Y', 'C'))
						OR SDR.Syn_Deal_Code = @Deal_Code
					)
				)
			)
			AND SDR.Syn_Deal_Rights_Code <> @Deal_Rights_Code 
			--AND SDR.Syn_Deal_Rights_Code NOT IN (
			--	SELECT nin.Syn_Deal_Rights_Code FROM #NotInSynRights nin
			--)

			IF(@ValidationStage = 'S2')
			BEGIN

				DELETE FROM #Syn_Deal_Rights WHERE Syn_Deal_Rights_Code IN (
					SELECT nin.Syn_Deal_Rights_Code FROM #NotInSynRights nin
				)

			END

			Begin ----------------- CHECK FOR TITLES

				SELECT SDR.Syn_Deal_Rights_Code
						,SDRT.Title_Code
						,SDRT.Episode_From
						,SDRT.Episode_To 
				InTo #Syn_Deal_Rights_Title 
				FROM #Syn_Deal_Rights SDR 
				Inner Join Syn_Deal_Rights_Title SDRT on SDR.Syn_Deal_Rights_Code = SDRT.Syn_Deal_Rights_Code
				WHERE Title_Code in (
					SELECT Title_Code FROM @Deal_Rights_Title inTitle
					WHERE 
						((inTitle.Episode_From Between SDRT.Episode_From AND SDRT.Episode_To) 
					OR	(inTitle.Episode_To Between SDRT.Episode_From AND SDRT.Episode_To) 
					OR	(SDRT.Episode_From Between inTitle.Episode_From AND inTitle.Episode_To) 
					OR  (SDRT.Episode_To Between inTitle.Episode_From AND inTitle.Episode_To))
					AND inTitle.Title_Code = @Cur_Title_code AND inTitle.Episode_From = @Cur_From_Episode_No AND inTitle.Episode_To = @Cur_To_Episode_No
				)

				Delete FROM #Syn_Deal_Rights WHERE Syn_Deal_Rights_Code Not In (
					SELECT Syn_Deal_Rights_Code FROM #Syn_Deal_Rights_Title
				)
			END ----------------- END

			Begin ----------------- CHECK FOR PLATFORMS
				
				SELECT DISTINCT SDR.Syn_Deal_Rights_Code 
						,SDRP.Platform_Code 
						into #Syn_Deal_Rights_Platform 
				FROM #Syn_Deal_Rights_Title SDR 
				Inner Join Syn_Deal_Rights_Platform SDRP on SDRP.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code
				WHERE Platform_Code in (SELECT Platform_Code FROM @Deal_Rights_Platform)

				--IF(@ValidationStage = 'S5')
				--BEGIN

				--	--SELECT * 
				--	DELETE sdrp
				--	FROM #Syn_Deal_Rights_Platform sdrp
				--	INNER JOIN #NotInSynRights nin ON nin.Syn_Deal_Rights_Code = sdrp.Syn_Deal_Rights_Code
				--	INNER JOIN Acq_Deal_Rights_Platform adrp ON nin.Acq_Deal_Rights_Code = adrp.Acq_Deal_Rights_Code AND sdrp.Platform_Code = adrp.Platform_Code

				--END
					
				Delete FROM #Syn_Deal_Rights_Title WHERE Syn_Deal_Rights_Code not in (
					SELECT Syn_Deal_Rights_Code FROM #Syn_Deal_Rights_Platform
				)

				Delete FROM #Syn_Deal_Rights WHERE Syn_Deal_Rights_Code not in (
					SELECT Syn_Deal_Rights_Code FROM #Syn_Deal_Rights_Title
				)

			END ----------------- END
				
			Begin ----------------- CHECK FOR COUNTRY
				
				SELECT a.Syn_Deal_Rights_Code, a.Country_Code into #Syn_Deal_Rights_Territory 
				FROM (
					SELECT SDR.Syn_Deal_Rights_Code, CASE WHEN SDRT.Territory_Type = 'I' THEN SDRT.Country_Code ELSE TD.Country_Code END Country_Code
					FROM #Syn_Deal_Rights SDR 
					Inner Join Syn_Deal_Rights_Territory SDRT on SDRT.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code
					Left Join Territory_Details TD On SDRT.Territory_Code = TD.Territory_Code
				) As a	
				Inner Join @Deal_Rights_Territory DRT On a.Country_Code = DRT.Country_Code
					
				--IF(@ValidationStage = 'S5')
				--BEGIN

				--	SELECT * 
				--	--DELETE sdrt
				--	FROM #Syn_Deal_Rights_Territory sdrt
				--	INNER JOIN #NotInSynRights nin ON nin.Syn_Deal_Rights_Code = sdrt.Syn_Deal_Rights_Code
				--	INNER JOIN (
				--		SELECT DISTINCT Acq_Deal_Rights_Code, CASE WHEN ADRT.Territory_Type = 'G' THEN TD.Country_Code ELSE ADRT.Country_Code END AS Country_Code 
				--		FROM Acq_Deal_Rights_Territory ADRT
				--		LEFT JOIN Territory_Details TD On ADRT.Territory_Code = TD.Territory_Code
				--		WHERE adrt.Acq_Deal_Rights_Code IN (
				--			SELECT Acq_Deal_Rights_Code FROM #NotInSynRights
				--		)
				--	) adrt1 ON nin.Acq_Deal_Rights_Code = adrt1.Acq_Deal_Rights_Code AND adrt1.Country_Code = sdrt.Country_Code

				--END

				delete FROM #Syn_Deal_Rights_Platform WHERE Syn_Deal_Rights_Code not in (
					SELECT Syn_Deal_Rights_Code FROM #Syn_Deal_Rights_Territory
				)
				delete FROM #Syn_Deal_Rights_Title WHERE Syn_Deal_Rights_Code not in (
					SELECT Syn_Deal_Rights_Code FROM #Syn_Deal_Rights_Platform
				)

				delete FROM #Syn_Deal_Rights WHERE Syn_Deal_Rights_Code not in (
					SELECT Syn_Deal_Rights_Code FROM #Syn_Deal_Rights_Title
				)
			END ----------------- END
				
			Begin ----------------- CHECK FOR SUBTITLING
				
				IF((SELECT COUNT(ISNULL(Subtitling_Code,0)) FROM @Deal_Rights_Subtitling)>0)
				BEGIN

					insert into #Syn_Deal_Rights_Subtitling(Syn_Deal_Rights_Code,Language_Type, Language_Group_Code,Language_Code)
					SELECT Syn_Deal_Rights_Code, a.Language_Type, a.Language_Group_Code, Language_Code FROM (
						SELECT SDR.Syn_Deal_Rights_Code,SDRS.Language_Type,SDRS.Language_Group_Code,
								CASE WHEN SDRS.Language_Type = 'L' THEN SDRS.Language_Code  ELSE LGD.Language_Code END Language_Code
						FROM #Syn_Deal_Rights SDR 
						Inner Join Syn_Deal_Rights_Subtitling SDRS on SDRS.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code
						Left Join Language_Group_Details LGD On SDRS.Language_Group_Code = LGD.Language_Group_Code
					) as a
					Inner Join @Deal_Rights_Subtitling DRS ON DRS.Subtitling_Code=a.Language_Code

					--IF(@ValidationStage = 'S4')
					--BEGIN

					--	DELETE sdrt
					--	FROM #Syn_Deal_Rights_Subtitling sdrt
					--	INNER JOIN #NotInSynRights nin ON nin.Syn_Deal_Rights_Code = sdrt.Syn_Deal_Rights_Code
					--	INNER JOIN (
					--		SELECT DISTINCT Acq_Deal_Rights_Code, CASE WHEN ADRT.Language_Type = 'L' THEN ADRT.Language_Code ELSE TD.Language_Code END AS Language_Code 
					--		FROM Acq_Deal_Rights_Subtitling ADRT
					--		LEFT JOIN Language_Group_Details TD On ADRT.Language_Group_Code = TD.Language_Group_Code
					--		WHERE adrt.Acq_Deal_Rights_Code IN (
					--			SELECT Acq_Deal_Rights_Code FROM #NotInSynRights
					--		)
					--	) adrt1 ON adrt1.Acq_Deal_Rights_Code = nin.Acq_Deal_Rights_Code AND adrt1.Language_Code = sdrt.Language_Code

					--END

				END
					
			END ----------------- END
		
			Begin ----------------- CHECK FOR DUBBING
				
				IF((SELECT COUNT(ISNULL(Dubbing_Code,0)) FROM @Deal_Rights_Dubbing)>0)
				BEGIN
					insert into #Syn_Deal_Rights_Dubbing(Syn_Deal_Rights_Code,Language_Type ,Language_Group_Code,Language_Code)
					SELECT Syn_Deal_Rights_Code,a.Language_Type, a.Language_Group_Code, Language_Code 
					FROM (
						SELECT SDR.Syn_Deal_Rights_Code,SDRD.Language_Type,SDRD.Language_Group_Code, 
								CASE WHEN SDRD.Language_Type = 'L' THEN SDRD.Language_Code ELSE LGD.Language_Code END Language_Code
						FROM #Syn_Deal_Rights SDR
						Inner Join Syn_Deal_Rights_Dubbing SDRD on SDRD.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code
						Left Join Language_Group_Details LGD On SDRD.Language_Group_Code = LGD.Language_Group_Code
					) as a
					Inner Join @Deal_Rights_Dubbing DRD ON DRD.Dubbing_Code=a.Language_Code
						
					--IF(@ValidationStage = 'S5')
					--BEGIN

					--	DELETE sdrt
					--	FROM #Syn_Deal_Rights_Dubbing sdrt
					--	INNER JOIN #NotInSynRights nin ON nin.Syn_Deal_Rights_Code = sdrt.Syn_Deal_Rights_Code
					--	INNER JOIN (
					--		SELECT DISTINCT Acq_Deal_Rights_Code, CASE WHEN ADRT.Language_Type = 'L' THEN ADRT.Language_Code ELSE TD.Language_Code END AS Language_Code 
					--		FROM Acq_Deal_Rights_Dubbing ADRT
					--		LEFT JOIN Language_Group_Details TD On ADRT.Language_Group_Code = TD.Language_Group_Code
					--		WHERE adrt.Acq_Deal_Rights_Code IN (
					--			SELECT Acq_Deal_Rights_Code FROM #NotInSynRights
					--		)
					--	) adrt1 ON adrt1.Acq_Deal_Rights_Code = nin.Acq_Deal_Rights_Code AND adrt1.Language_Code = sdrt.Language_Code

					--END

				END

			END ----------------- END

			IF(
				(SELECT COUNT(ISNULL(Subtitling_Code,0)) FROM @Deal_Rights_Subtitling) = 0
				AND (SELECT COUNT(ISNULL(Dubbing_Code,0)) FROM @Deal_Rights_Dubbing) = 0
				AND @Is_Title_Language_Right = 'Y'
			)
			BEGIN
					
				DELETE FROM #Syn_Deal_Rights WHERE Is_Title_Language_Right = 'N'

			END
			ELSE IF (
				((SELECT COUNT(ISNULL(Subtitling_Code, 0)) FROM @Deal_Rights_Subtitling) > 0
					OR (SELECT COUNT(ISNULL(Dubbing_Code, 0)) FROM @Deal_Rights_Dubbing) > 0
				) AND @Is_Title_Language_Right = 'N'
			)
			BEGIN

				DELETE FROM #Syn_Deal_Rights WHERE Syn_Deal_Rights_Code IN (
					SELECT a.Syn_Deal_Rights_Code FROM (
						SELECT sdr.Syn_Deal_Rights_Code, sdr.Is_Title_Language_Right, 
						(
							SELECT COUNT(*) FROM #Syn_Deal_Rights_Subtitling sdrs
							WHERE sdrs.Syn_Deal_Rights_Code = sdr.Syn_Deal_Rights_Code
						) SubtitlingCount,
						(
							SELECT COUNT(*) FROM #Syn_Deal_Rights_Dubbing sdrd
							WHERE sdrd.Syn_Deal_Rights_Code = sdr.Syn_Deal_Rights_Code
						) DubbingCount
						FROM #Syn_Deal_Rights sdr
					) AS a WHERE Is_Title_Language_Right = 'Y' AND SubtitlingCount = 0 AND DubbingCount = 0
				)

			END

			--SELECT @ValidationStage
			IF(@ValidationStage = 'S4')
			BEGIN

				DECLARE @SynSumOf INT = 0, @SumOf INT = 0
				IF(CAST(@Right_End_Date AS DATE) = '31DEC9999')
					SELECT @SynSumOf = DATEDIFF(d, @Right_Start_Date, @Right_End_Date)
				ELSE
					SELECT @SynSumOf = DATEDIFF(d, @Right_Start_Date, DATEADD(d, 1, @Right_End_Date))

				--SELECT * FROM #Syn_Deal_Rights
				--SELECT * FROM #Syn_Deal_Rights_Platform
				--SELECT * FROM #Syn_Deal_Rights_Territory
				--RETURN
					
				BEGIN ------------ PLATFORM DAYS CALCULATION
					
					ALTER TABLE #Syn_Deal_Rights_Platform ADD AcqDays INT DEFAULT(0)
					ALTER TABLE #Syn_Deal_Rights_Platform ADD SynDays INT DEFAULT(0)
					ALTER TABLE #Syn_Deal_Rights_Platform ADD BBDays INT DEFAULT(0)
					ALTER TABLE #Syn_Deal_Rights_Platform ADD AvailDays AS (ISNULL(AcqDays, 0) - ISNULL(SynDays, 0) + ISNULL(BBDays, 0))

					UPDATE tsdrp SET tsdrp.AcqDays = neo.SumDays
					FROM #Syn_Deal_Rights_Platform tsdrp
					INNER JOIN (
						SELECT SUM(Partition_Of) SumDays, Platform_Code 
						FROM(
							SELECT ADR.Acq_Deal_Rights_Code, tsdrp.Platform_Code,
							SUM(
								CASE 
									WHEN (@Right_Start_Date Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date) AND (@Right_End_Date Not Between ADR.Actual_Right_Start_Date  AND ADR.Actual_Right_End_Date)
										THEN DATEDIFF(d,@Right_Start_Date, DATEADD(d,1, ADR.Actual_Right_End_Date ))   
									WHEN (@Right_Start_Date Not Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date) AND (@Right_End_Date Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date)
										THEN DATEDIFF(d, ADR.Actual_Right_Start_Date,DATEADD(d,1, @Right_End_Date))
									WHEN (@Right_Start_Date < ADR.Actual_Right_Start_Date) AND (@Right_End_Date > ADR.Actual_Right_End_Date)
										THEN DATEDIFF(d,ADR.Actual_Right_Start_Date, DATEADD(d,1, ADR.Actual_Right_End_Date ))
									WHEN (@Right_Start_Date Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date) AND (@Right_End_Date Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date)
										THEN DATEDIFF(d,@Right_Start_Date,DATEADD(d,1, @Right_End_Date  ))
									ELSE 0 
								END
							) --OVER(PARTITION BY ADR.Acq_Deal_Rights_Code) 
							AS Partition_Of
							FROM (
								SELECT DISTINCT Platform_Code, tacin.Acq_Deal_Rights_Code, Actual_Right_Start_Date, Actual_Right_End_Date FROM #Temp_Acq_Country tacin
								INNER JOIN Acq_Deal_Rights adrin ON tacin.Acq_Deal_Rights_Code = adrin.Acq_Deal_Rights_Code
								INNER JOIN Acq_Deal adin ON adrin.Acq_Deal_Code = adin.Acq_Deal_Code
								WHERE adin.Role_Code <> 39
							) AS ADR
							INNER JOIN #Syn_Deal_Rights_Platform tsdrp ON tsdrp.Platform_Code = ADR.Platform_Code
							GROUP BY ADR.Acq_Deal_Rights_Code, Actual_Right_Start_Date, Actual_Right_End_Date, tsdrp.Platform_Code
						) AS a GROUP BY Platform_Code
					) AS neo ON neo.Platform_Code = tsdrp.Platform_Code
					
					UPDATE tsdrp SET tsdrp.SynDays = neo.SumDays
					FROM #Syn_Deal_Rights_Platform tsdrp
					INNER JOIN (
						SELECT SUM(Partition_Of) SumDays, Platform_Code 
						FROM(
							SELECT ADR.Syn_Deal_Rights_Code, tsdrp.Platform_Code,
							SUM(
								CASE 
									WHEN (@Right_Start_Date Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date) AND (@Right_End_Date Not Between ADR.Actual_Right_Start_Date  AND ADR.Actual_Right_End_Date)
										THEN DATEDIFF(d,@Right_Start_Date, DATEADD(d,1, ADR.Actual_Right_End_Date ))   
									WHEN (@Right_Start_Date Not Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date) AND (@Right_End_Date Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date)
										THEN DATEDIFF(d, ADR.Actual_Right_Start_Date,DATEADD(d,1, @Right_End_Date))
									WHEN (@Right_Start_Date < ADR.Actual_Right_Start_Date) AND (@Right_End_Date > ADR.Actual_Right_End_Date)
										THEN DATEDIFF(d,ADR.Actual_Right_Start_Date, DATEADD(d,1, ADR.Actual_Right_End_Date ))
									WHEN (@Right_Start_Date Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date) AND (@Right_End_Date Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date)
										THEN DATEDIFF(d,@Right_Start_Date,DATEADD(d,1, @Right_End_Date  ))
									ELSE 0 
								END
							) --OVER(PARTITION BY ADR.Acq_Deal_Rights_Code) 
							AS Partition_Of
							FROM #Syn_Deal_Rights ADR
							--INNER JOIN Syn_Deal_Rights_Platform sdrpneo ON adr.Syn_Deal_Rights_Code = sdrpneo.Syn_Deal_Rights_Code
							INNER JOIN #Syn_Deal_Rights_Platform tsdrp ON tsdrp.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code
							GROUP BY ADR.Syn_Deal_Rights_Code, Actual_Right_Start_Date, Actual_Right_End_Date, tsdrp.Platform_Code
						) AS a GROUP BY Platform_Code
					) AS neo ON neo.Platform_Code = tsdrp.Platform_Code

					--SELECT * FROM #NotInSynRights

					UPDATE tsdrp SET tsdrp.BBDays = neo.SumDays
					FROM #Syn_Deal_Rights_Platform tsdrp
					INNER JOIN (
						SELECT SUM(Partition_Of) SumDays, Platform_Code 
						FROM(
							SELECT sdrp.Platform_Code,
							SUM(
								CASE 
									WHEN (@Right_Start_Date Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date) AND (@Right_End_Date Not Between ADR.Actual_Right_Start_Date  AND ADR.Actual_Right_End_Date)
										THEN DATEDIFF(d,@Right_Start_Date, DATEADD(d,1, ADR.Actual_Right_End_Date ))   
									WHEN (@Right_Start_Date Not Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date) AND (@Right_End_Date Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date)
										THEN DATEDIFF(d, ADR.Actual_Right_Start_Date,DATEADD(d,1, @Right_End_Date))
									WHEN (@Right_Start_Date < ADR.Actual_Right_Start_Date) AND (@Right_End_Date > ADR.Actual_Right_End_Date)
										THEN DATEDIFF(d,ADR.Actual_Right_Start_Date, DATEADD(d,1, ADR.Actual_Right_End_Date ))
									WHEN (@Right_Start_Date Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date) AND (@Right_End_Date Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date)
										THEN DATEDIFF(d,@Right_Start_Date,DATEADD(d,1, @Right_End_Date  ))
									ELSE 0 
								END
							) AS Partition_Of
							--OVER(PARTITION BY ADR.Acq_Deal_Rights_Code) AS Partition_Of
							FROM #Syn_Deal_Rights_Platform sdrp
							INNER JOIN #NotInSynRights nin ON nin.Syn_Deal_Rights_Code = sdrp.Syn_Deal_Rights_Code
							INNER JOIN Acq_Deal_Rights_Platform adrp ON nin.Acq_Deal_Rights_Code = adrp.Acq_Deal_Rights_Code AND sdrp.Platform_Code = adrp.Platform_Code
							INNER JOIN Acq_Deal_Rights ADR ON adrp.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code 
							INNER JOIN Acq_Deal adin ON ADR.Acq_Deal_Code = adin.Acq_Deal_Code
							WHERE adin.Role_Code = 39 
							--AND ((ADR.Is_Title_Language_Right = @Is_Title_Language_Right)
							--	 --OR (@Is_Title_Language_Right <> 'Y' AND ADR.Is_Title_Language_Right = 'Y')
							--	 --OR (@Is_Title_Language_Right = 'Y' AND ADR.Is_Title_Language_Right = 'N')
							--)
							GROUP BY ADR.Acq_Deal_Rights_Code, Actual_Right_Start_Date, Actual_Right_End_Date, sdrp.Platform_Code
						) AS a GROUP BY Platform_Code
					) AS neo ON neo.Platform_Code = tsdrp.Platform_Code

				END
					
				--SELECT @SynSumOf, * FROM #Syn_Deal_Rights_Platform

				DELETE sdrp
				FROM #Syn_Deal_Rights_Platform sdrp
				INNER JOIN #NotInSynRights nin ON nin.Syn_Deal_Rights_Code = sdrp.Syn_Deal_Rights_Code
				INNER JOIN Acq_Deal_Rights_Platform adrp ON nin.Acq_Deal_Rights_Code = adrp.Acq_Deal_Rights_Code AND sdrp.Platform_Code = adrp.Platform_Code
				INNER JOIN Acq_Deal_Rights ADR ON ADR.Acq_Deal_Rights_Code = adrp.Acq_Deal_Rights_Code AND nin.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
				WHERE @SynSumOf <= AvailDays AND (
					(ADR.Is_Title_Language_Right = 'Y' AND @Is_Title_Language_Right = 'Y') OR
					(ADR.Is_Title_Language_Right = 'Y' AND @Is_Title_Language_Right = 'N') OR
					(ADR.Is_Title_Language_Right = 'N' AND @Is_Title_Language_Right = 'N')
				)
					
				--SELECT @SynSumOf, * FROM #Syn_Deal_Rights_Platform

				--SELECT 2
				BEGIN ------------ TERRITORY / COUNTRY DAYS CALCULATION

					ALTER TABLE #Syn_Deal_Rights_Territory ADD AcqDays INT DEFAULT(0)
					ALTER TABLE #Syn_Deal_Rights_Territory ADD SynDays INT DEFAULT(0)
					ALTER TABLE #Syn_Deal_Rights_Territory ADD BBDays INT DEFAULT(0)
					ALTER TABLE #Syn_Deal_Rights_Territory ADD AvailDays AS (ISNULL(AcqDays, 0) - ISNULL(SynDays, 0) + ISNULL(BBDays, 0))

					UPDATE tsdrp SET tsdrp.AcqDays = neo.SumDays
					FROM #Syn_Deal_Rights_Territory tsdrp
					INNER JOIN (
						SELECT SUM(Partition_Of) SumDays, Country_Code 
						FROM(
							SELECT ADR.Acq_Deal_Rights_Code, tsdrp.Country_Code,
							SUM(
								CASE 
									WHEN (@Right_Start_Date Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date) AND (@Right_End_Date Not Between ADR.Actual_Right_Start_Date  AND ADR.Actual_Right_End_Date)
										THEN DATEDIFF(d,@Right_Start_Date, DATEADD(d,1, ADR.Actual_Right_End_Date ))   
									WHEN (@Right_Start_Date Not Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date) AND (@Right_End_Date Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date)
										THEN DATEDIFF(d, ADR.Actual_Right_Start_Date,DATEADD(d,1, @Right_End_Date))
									WHEN (@Right_Start_Date < ADR.Actual_Right_Start_Date) AND (@Right_End_Date > ADR.Actual_Right_End_Date)
										THEN DATEDIFF(d,ADR.Actual_Right_Start_Date, DATEADD(d,1, ADR.Actual_Right_End_Date ))
									WHEN (@Right_Start_Date Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date) AND (@Right_End_Date Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date)
										THEN DATEDIFF(d,@Right_Start_Date,DATEADD(d,1, @Right_End_Date  ))
									ELSE 0 
								END
							) --OVER(PARTITION BY ADR.Acq_Deal_Rights_Code) 
							AS Partition_Of
							FROM (
								SELECT DISTINCT Country_Code, tacin.Acq_Deal_Rights_Code, Actual_Right_Start_Date, Actual_Right_End_Date 
								FROM #Temp_Acq_Country tacin
								INNER JOIN Acq_Deal_Rights adrin ON tacin.Acq_Deal_Rights_Code = adrin.Acq_Deal_Rights_Code
								INNER JOIN Acq_Deal adin ON adrin.Acq_Deal_Code = adin.Acq_Deal_Code
								WHERE adin.Role_Code <> 39
							) AS ADR
							INNER JOIN #Syn_Deal_Rights_Territory tsdrp ON tsdrp.Country_Code = ADR.Country_Code
							GROUP BY ADR.Acq_Deal_Rights_Code, Actual_Right_Start_Date, Actual_Right_End_Date, tsdrp.Country_Code
						) AS a GROUP BY Country_Code
					) AS neo ON neo.Country_Code = tsdrp.Country_Code
					
					UPDATE tsdrp SET tsdrp.SynDays = neo.SumDays
					FROM #Syn_Deal_Rights_Territory tsdrp
					INNER JOIN (
						SELECT SUM(Partition_Of) SumDays, Country_Code 
						FROM(
							SELECT ADR.Syn_Deal_Rights_Code, tsdrp.Country_Code,
							SUM(
								CASE 
									WHEN (@Right_Start_Date Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date) AND (@Right_End_Date Not Between ADR.Actual_Right_Start_Date  AND ADR.Actual_Right_End_Date)
										THEN DATEDIFF(d,@Right_Start_Date, DATEADD(d,1, ADR.Actual_Right_End_Date ))   
									WHEN (@Right_Start_Date Not Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date) AND (@Right_End_Date Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date)
										THEN DATEDIFF(d, ADR.Actual_Right_Start_Date,DATEADD(d,1, @Right_End_Date))
									WHEN (@Right_Start_Date < ADR.Actual_Right_Start_Date) AND (@Right_End_Date > ADR.Actual_Right_End_Date)
										THEN DATEDIFF(d,ADR.Actual_Right_Start_Date, DATEADD(d,1, ADR.Actual_Right_End_Date ))
									WHEN (@Right_Start_Date Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date) AND (@Right_End_Date Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date)
										THEN DATEDIFF(d,@Right_Start_Date,DATEADD(d,1, @Right_End_Date  ))
									ELSE 0 
								END
							) --OVER(PARTITION BY ADR.Acq_Deal_Rights_Code) 
							AS Partition_Of
							FROM #Syn_Deal_Rights ADR
							--INNER JOIN Syn_Deal_Rights_Platform sdrpneo ON adr.Syn_Deal_Rights_Code = sdrpneo.Syn_Deal_Rights_Code
							INNER JOIN #Syn_Deal_Rights_Territory tsdrp ON tsdrp.Syn_Deal_Rights_Code = adr.Syn_Deal_Rights_Code
							GROUP BY ADR.Syn_Deal_Rights_Code, Actual_Right_Start_Date, Actual_Right_End_Date, tsdrp.Country_Code
						) AS a GROUP BY Country_Code
					) AS neo ON neo.Country_Code = tsdrp.Country_Code

					UPDATE tsdrp SET tsdrp.BBDays = neo.SumDays
					FROM #Syn_Deal_Rights_Territory tsdrp
					INNER JOIN (
						SELECT SUM(Partition_Of) SumDays, Country_Code 
						FROM(
							SELECT sdrp.Country_Code,
							SUM(
								CASE 
									WHEN (@Right_Start_Date Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date) AND (@Right_End_Date Not Between ADR.Actual_Right_Start_Date  AND ADR.Actual_Right_End_Date)
										THEN DATEDIFF(d,@Right_Start_Date, DATEADD(d,1, ADR.Actual_Right_End_Date ))   
									WHEN (@Right_Start_Date Not Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date) AND (@Right_End_Date Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date)
										THEN DATEDIFF(d, ADR.Actual_Right_Start_Date,DATEADD(d,1, @Right_End_Date))
									WHEN (@Right_Start_Date < ADR.Actual_Right_Start_Date) AND (@Right_End_Date > ADR.Actual_Right_End_Date)
										THEN DATEDIFF(d,ADR.Actual_Right_Start_Date, DATEADD(d,1, ADR.Actual_Right_End_Date ))
									WHEN (@Right_Start_Date Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date) AND (@Right_End_Date Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date)
										THEN DATEDIFF(d,@Right_Start_Date,DATEADD(d,1, @Right_End_Date  ))
									ELSE 0 
								END
							)
							OVER(PARTITION BY ADR.Acq_Deal_Rights_Code) AS Partition_Of
							FROM #Syn_Deal_Rights_Territory sdrp
							INNER JOIN #NotInSynRights nin ON nin.Syn_Deal_Rights_Code = sdrp.Syn_Deal_Rights_Code
							INNER JOIN (
								SELECT DISTINCT Acq_Deal_Rights_Code, CASE WHEN ADRT.Territory_Type = 'G' THEN TD.Country_Code ELSE ADRT.Country_Code END AS Country_Code 
								FROM Acq_Deal_Rights_Territory ADRT
								LEFT JOIN Territory_Details TD On ADRT.Territory_Code = TD.Territory_Code
								WHERE adrt.Acq_Deal_Rights_Code IN (
									SELECT ninin.Acq_Deal_Rights_Code FROM #NotInSynRights ninin
								)
							) adrp ON nin.Acq_Deal_Rights_Code = adrp.Acq_Deal_Rights_Code AND sdrp.Country_Code = adrp.Country_Code
							INNER JOIN Acq_Deal_Rights ADR ON adrp.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code 
							INNER JOIN Acq_Deal adin ON ADR.Acq_Deal_Code = adin.Acq_Deal_Code
							WHERE adin.Role_Code = 39
							GROUP BY ADR.Acq_Deal_Rights_Code, Actual_Right_Start_Date, Actual_Right_End_Date, sdrp.Country_Code
						) AS a GROUP BY Country_Code
					) AS neo ON neo.Country_Code = tsdrp.Country_Code
					
				END

				--SELECT @SynSumOf, * FROM #Syn_Deal_Rights_Territory

				DELETE sdrt
				FROM #Syn_Deal_Rights_Territory sdrt
				INNER JOIN #NotInSynRights nin ON nin.Syn_Deal_Rights_Code = sdrt.Syn_Deal_Rights_Code
				INNER JOIN (
					SELECT DISTINCT Acq_Deal_Rights_Code, CASE WHEN ADRT.Territory_Type = 'G' THEN TD.Country_Code ELSE ADRT.Country_Code END AS Country_Code 
					FROM Acq_Deal_Rights_Territory ADRT
					LEFT JOIN Territory_Details TD On ADRT.Territory_Code = TD.Territory_Code
					WHERE adrt.Acq_Deal_Rights_Code IN (
						SELECT Acq_Deal_Rights_Code FROM #NotInSynRights
					)
				) adrt1 ON nin.Acq_Deal_Rights_Code = adrt1.Acq_Deal_Rights_Code AND adrt1.Country_Code = sdrt.Country_Code
				INNER JOIN Acq_Deal_Rights ADR ON ADR.Acq_Deal_Rights_Code = adrt1.Acq_Deal_Rights_Code AND nin.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
				WHERE @SynSumOf <= AvailDays AND (
					(ADR.Is_Title_Language_Right = 'Y' AND @Is_Title_Language_Right = 'Y') OR
					(ADR.Is_Title_Language_Right = 'Y' AND @Is_Title_Language_Right = 'N') OR
					(ADR.Is_Title_Language_Right = 'N' AND @Is_Title_Language_Right = 'N')
				)
					
				--SELECT @SynSumOf, * FROM #Syn_Deal_Rights_Territory

				IF EXISTS(SELECT TOP 1 * FROM #Syn_Deal_Rights_Subtitling)
				BEGIN

					BEGIN ------------ SUBTITLING - LANGUAGE / LANGUAGE GROUP DAYS CALCULATION

						ALTER TABLE #Syn_Deal_Rights_Subtitling ADD AcqDays INT DEFAULT(0)
						ALTER TABLE #Syn_Deal_Rights_Subtitling ADD SynDays INT DEFAULT(0)
						ALTER TABLE #Syn_Deal_Rights_Subtitling ADD BBDays INT DEFAULT(0)
						ALTER TABLE #Syn_Deal_Rights_Subtitling ADD AvailDays AS (ISNULL(AcqDays, 0) - ISNULL(SynDays, 0) + ISNULL(BBDays, 0))

						IF(OBJECT_ID('TEMPDB..#Temp_Acq_Subtitling') IS NOT NULL)
						BEGIN

							UPDATE tsdrp SET tsdrp.AcqDays = neo.SumDays
							FROM #Syn_Deal_Rights_Subtitling tsdrp
							INNER JOIN (
								SELECT SUM(Partition_Of) SumDays, Language_Code 
								FROM(
									SELECT ADR.Acq_Deal_Rights_Code, tsdrp.Language_Code,
									SUM(
										CASE 
											WHEN (@Right_Start_Date Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date) AND (@Right_End_Date Not Between ADR.Actual_Right_Start_Date  AND ADR.Actual_Right_End_Date)
												THEN DATEDIFF(d,@Right_Start_Date, DATEADD(d,1, ADR.Actual_Right_End_Date ))   
											WHEN (@Right_Start_Date Not Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date) AND (@Right_End_Date Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date)
												THEN DATEDIFF(d, ADR.Actual_Right_Start_Date,DATEADD(d,1, @Right_End_Date))
											WHEN (@Right_Start_Date < ADR.Actual_Right_Start_Date) AND (@Right_End_Date > ADR.Actual_Right_End_Date)
												THEN DATEDIFF(d,ADR.Actual_Right_Start_Date, DATEADD(d,1, ADR.Actual_Right_End_Date ))
											WHEN (@Right_Start_Date Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date) AND (@Right_End_Date Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date)
												THEN DATEDIFF(d,@Right_Start_Date,DATEADD(d,1, @Right_End_Date  ))
											ELSE 0 
										END
									) --OVER(PARTITION BY ADR.Acq_Deal_Rights_Code) 
									AS Partition_Of
									FROM (
										SELECT DISTINCT Language_Code, tacin.Acq_Deal_Rights_Code, Actual_Right_Start_Date, Actual_Right_End_Date 
										FROM #Temp_Acq_Subtitling tacin
										INNER JOIN Acq_Deal_Rights adrin ON tacin.Acq_Deal_Rights_Code = adrin.Acq_Deal_Rights_Code
										INNER JOIN Acq_Deal adin ON adrin.Acq_Deal_Code = adin.Acq_Deal_Code
										WHERE adin.Role_Code <> 39
									) AS ADR
									INNER JOIN #Syn_Deal_Rights_Subtitling tsdrp ON tsdrp.Language_Code = ADR.Language_Code
									GROUP BY ADR.Acq_Deal_Rights_Code, Actual_Right_Start_Date, Actual_Right_End_Date, tsdrp.Language_Code
								) AS a GROUP BY Language_Code
							) AS neo ON neo.Language_Code = tsdrp.Language_Code
							
						END

						UPDATE tsdrp SET tsdrp.SynDays = neo.SumDays
						FROM #Syn_Deal_Rights_Subtitling tsdrp
						INNER JOIN (
							SELECT SUM(Partition_Of) SumDays, Language_Code 
							FROM(
								SELECT ADR.Syn_Deal_Rights_Code, tsdrp.Language_Code,
								SUM(
									CASE 
										WHEN (@Right_Start_Date Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date) AND (@Right_End_Date Not Between ADR.Actual_Right_Start_Date  AND ADR.Actual_Right_End_Date)
											THEN DATEDIFF(d,@Right_Start_Date, DATEADD(d,1, ADR.Actual_Right_End_Date ))   
										WHEN (@Right_Start_Date Not Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date) AND (@Right_End_Date Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date)
											THEN DATEDIFF(d, ADR.Actual_Right_Start_Date,DATEADD(d,1, @Right_End_Date))
										WHEN (@Right_Start_Date < ADR.Actual_Right_Start_Date) AND (@Right_End_Date > ADR.Actual_Right_End_Date)
											THEN DATEDIFF(d,ADR.Actual_Right_Start_Date, DATEADD(d,1, ADR.Actual_Right_End_Date ))
										WHEN (@Right_Start_Date Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date) AND (@Right_End_Date Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date)
											THEN DATEDIFF(d,@Right_Start_Date,DATEADD(d,1, @Right_End_Date  ))
										ELSE 0 
									END
								) --OVER(PARTITION BY ADR.Acq_Deal_Rights_Code) 
								AS Partition_Of
								FROM #Syn_Deal_Rights ADR
								--INNER JOIN Syn_Deal_Rights_Platform sdrpneo ON adr.Syn_Deal_Rights_Code = sdrpneo.Syn_Deal_Rights_Code
								INNER JOIN #Syn_Deal_Rights_Subtitling tsdrp ON tsdrp.Syn_Deal_Rights_Code = adr.Syn_Deal_Rights_Code
								GROUP BY ADR.Syn_Deal_Rights_Code, Actual_Right_Start_Date, Actual_Right_End_Date, tsdrp.Language_Code
							) AS a GROUP BY Language_Code
						) AS neo ON neo.Language_Code = tsdrp.Language_Code

						UPDATE tsdrp SET tsdrp.BBDays = neo.SumDays
						FROM #Syn_Deal_Rights_Subtitling tsdrp
						INNER JOIN (
							SELECT SUM(Partition_Of) SumDays, Language_Code 
							FROM(
								SELECT sdrp.Language_Code,
								SUM(
									CASE 
										WHEN (@Right_Start_Date Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date) AND (@Right_End_Date Not Between ADR.Actual_Right_Start_Date  AND ADR.Actual_Right_End_Date)
											THEN DATEDIFF(d,@Right_Start_Date, DATEADD(d,1, ADR.Actual_Right_End_Date ))   
										WHEN (@Right_Start_Date Not Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date) AND (@Right_End_Date Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date)
											THEN DATEDIFF(d, ADR.Actual_Right_Start_Date,DATEADD(d,1, @Right_End_Date))
										WHEN (@Right_Start_Date < ADR.Actual_Right_Start_Date) AND (@Right_End_Date > ADR.Actual_Right_End_Date)
											THEN DATEDIFF(d,ADR.Actual_Right_Start_Date, DATEADD(d,1, ADR.Actual_Right_End_Date ))
										WHEN (@Right_Start_Date Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date) AND (@Right_End_Date Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date)
											THEN DATEDIFF(d,@Right_Start_Date,DATEADD(d,1, @Right_End_Date  ))
										ELSE 0 
									END
								)
								OVER(PARTITION BY ADR.Acq_Deal_Rights_Code) AS Partition_Of
								FROM #Syn_Deal_Rights_Subtitling sdrp
								INNER JOIN #NotInSynRights nin ON nin.Syn_Deal_Rights_Code = sdrp.Syn_Deal_Rights_Code
								INNER JOIN (
									SELECT DISTINCT Acq_Deal_Rights_Code, CASE WHEN ADRT.Language_Type = 'G' THEN TD.Language_Code ELSE ADRT.Language_Code END AS Language_Code 
									FROM Acq_Deal_Rights_Subtitling ADRT
									LEFT JOIN Language_Group_Details TD On ADRT.Language_Group_Code = TD.Language_Group_Code
									WHERE adrt.Acq_Deal_Rights_Code IN (
										SELECT ninin.Acq_Deal_Rights_Code FROM #NotInSynRights ninin
									)
								) adrp ON nin.Acq_Deal_Rights_Code = adrp.Acq_Deal_Rights_Code AND sdrp.Language_Code = adrp.Language_Code
								INNER JOIN Acq_Deal_Rights ADR ON adrp.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code 
								INNER JOIN Acq_Deal adin ON ADR.Acq_Deal_Code = adin.Acq_Deal_Code
								WHERE adin.Role_Code = 39
								GROUP BY ADR.Acq_Deal_Rights_Code, Actual_Right_Start_Date, Actual_Right_End_Date, sdrp.Language_Code
							) AS a GROUP BY Language_Code
						) AS neo ON neo.Language_Code = tsdrp.Language_Code
					
					END

					--SELECT * FROM #Syn_Deal_Rights_Subtitling

					DELETE sdrt
					FROM #Syn_Deal_Rights_Subtitling sdrt
					INNER JOIN #NotInSynRights nin ON nin.Syn_Deal_Rights_Code = sdrt.Syn_Deal_Rights_Code
					INNER JOIN (
						SELECT DISTINCT Acq_Deal_Rights_Code, CASE WHEN ADRT.Language_Type = 'L' THEN ADRT.Language_Code ELSE TD.Language_Code END AS Language_Code 
						FROM Acq_Deal_Rights_Subtitling ADRT
						LEFT JOIN Language_Group_Details TD On ADRT.Language_Group_Code = TD.Language_Group_Code
						WHERE adrt.Acq_Deal_Rights_Code IN (
							SELECT Acq_Deal_Rights_Code FROM #NotInSynRights
						)
					) adrt1 ON adrt1.Acq_Deal_Rights_Code = nin.Acq_Deal_Rights_Code AND adrt1.Language_Code = sdrt.Language_Code
					WHERE @SynSumOf <= AvailDays
					--WHERE @SynSumOf <= @SumOf

					--SELECT * FROM #Syn_Deal_Rights_Subtitling

				END
					
				IF EXISTS(SELECT TOP 1 * FROM #Syn_Deal_Rights_Dubbing)
				BEGIN
					
					BEGIN ------------ DUBBING - LANGUAGE / LANGUAGE GROUP DAYS CALCULATION

						ALTER TABLE #Syn_Deal_Rights_Dubbing ADD AcqDays INT DEFAULT(0)
						ALTER TABLE #Syn_Deal_Rights_Dubbing ADD SynDays INT DEFAULT(0)
						ALTER TABLE #Syn_Deal_Rights_Dubbing ADD BBDays INT DEFAULT(0)
						ALTER TABLE #Syn_Deal_Rights_Dubbing ADD AvailDays AS (ISNULL(AcqDays, 0) - ISNULL(SynDays, 0) + ISNULL(BBDays, 0))

						IF(OBJECT_ID('TEMPDB..#Temp_Acq_Dubbing') IS NOT NULL)
						BEGIN

							UPDATE tsdrp SET tsdrp.AcqDays = neo.SumDays
							FROM #Syn_Deal_Rights_Dubbing tsdrp
							INNER JOIN (
								SELECT SUM(Partition_Of) SumDays, Language_Code 
								FROM(
									SELECT ADR.Acq_Deal_Rights_Code, tsdrp.Language_Code,
									SUM(
										CASE 
											WHEN (@Right_Start_Date Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date) AND (@Right_End_Date Not Between ADR.Actual_Right_Start_Date  AND ADR.Actual_Right_End_Date)
												THEN DATEDIFF(d,@Right_Start_Date, DATEADD(d,1, ADR.Actual_Right_End_Date ))   
											WHEN (@Right_Start_Date Not Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date) AND (@Right_End_Date Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date)
												THEN DATEDIFF(d, ADR.Actual_Right_Start_Date,DATEADD(d,1, @Right_End_Date))
											WHEN (@Right_Start_Date < ADR.Actual_Right_Start_Date) AND (@Right_End_Date > ADR.Actual_Right_End_Date)
												THEN DATEDIFF(d,ADR.Actual_Right_Start_Date, DATEADD(d,1, ADR.Actual_Right_End_Date ))
											WHEN (@Right_Start_Date Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date) AND (@Right_End_Date Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date)
												THEN DATEDIFF(d,@Right_Start_Date,DATEADD(d,1, @Right_End_Date  ))
											ELSE 0 
										END
									) --OVER(PARTITION BY ADR.Acq_Deal_Rights_Code) 
									AS Partition_Of
									FROM (
										SELECT DISTINCT Language_Code, tacin.Acq_Deal_Rights_Code, Actual_Right_Start_Date, Actual_Right_End_Date 
										FROM #Temp_Acq_Dubbing tacin
										INNER JOIN Acq_Deal_Rights adrin ON tacin.Acq_Deal_Rights_Code = adrin.Acq_Deal_Rights_Code
										INNER JOIN Acq_Deal adin ON adrin.Acq_Deal_Code = adin.Acq_Deal_Code
										WHERE adin.Role_Code <> 39
									) AS ADR
									INNER JOIN #Syn_Deal_Rights_Dubbing tsdrp ON tsdrp.Language_Code = ADR.Language_Code
									GROUP BY ADR.Acq_Deal_Rights_Code, Actual_Right_Start_Date, Actual_Right_End_Date, tsdrp.Language_Code
								) AS a GROUP BY Language_Code
							) AS neo ON neo.Language_Code = tsdrp.Language_Code
							
						END

						UPDATE tsdrp SET tsdrp.SynDays = neo.SumDays
						FROM #Syn_Deal_Rights_Dubbing tsdrp
						INNER JOIN (
							SELECT SUM(Partition_Of) SumDays, Language_Code 
							FROM(
								SELECT ADR.Syn_Deal_Rights_Code, tsdrp.Language_Code,
								SUM(
									CASE 
										WHEN (@Right_Start_Date Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date) AND (@Right_End_Date Not Between ADR.Actual_Right_Start_Date  AND ADR.Actual_Right_End_Date)
											THEN DATEDIFF(d,@Right_Start_Date, DATEADD(d,1, ADR.Actual_Right_End_Date ))   
										WHEN (@Right_Start_Date Not Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date) AND (@Right_End_Date Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date)
											THEN DATEDIFF(d, ADR.Actual_Right_Start_Date,DATEADD(d,1, @Right_End_Date))
										WHEN (@Right_Start_Date < ADR.Actual_Right_Start_Date) AND (@Right_End_Date > ADR.Actual_Right_End_Date)
											THEN DATEDIFF(d,ADR.Actual_Right_Start_Date, DATEADD(d,1, ADR.Actual_Right_End_Date ))
										WHEN (@Right_Start_Date Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date) AND (@Right_End_Date Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date)
											THEN DATEDIFF(d,@Right_Start_Date,DATEADD(d,1, @Right_End_Date  ))
										ELSE 0 
									END
								) --OVER(PARTITION BY ADR.Acq_Deal_Rights_Code) 
								AS Partition_Of
								FROM #Syn_Deal_Rights ADR
								--INNER JOIN Syn_Deal_Rights_Platform sdrpneo ON adr.Syn_Deal_Rights_Code = sdrpneo.Syn_Deal_Rights_Code
								INNER JOIN #Syn_Deal_Rights_Dubbing tsdrp ON tsdrp.Syn_Deal_Rights_Code = adr.Syn_Deal_Rights_Code
								GROUP BY ADR.Syn_Deal_Rights_Code, Actual_Right_Start_Date, Actual_Right_End_Date, tsdrp.Language_Code
							) AS a GROUP BY Language_Code
						) AS neo ON neo.Language_Code = tsdrp.Language_Code

						UPDATE tsdrp SET tsdrp.BBDays = neo.SumDays
						FROM #Syn_Deal_Rights_Dubbing tsdrp
						INNER JOIN (
							SELECT SUM(Partition_Of) SumDays, Language_Code 
							FROM(
								SELECT sdrp.Language_Code,
								SUM(
									CASE 
										WHEN (@Right_Start_Date Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date) AND (@Right_End_Date Not Between ADR.Actual_Right_Start_Date  AND ADR.Actual_Right_End_Date)
											THEN DATEDIFF(d,@Right_Start_Date, DATEADD(d,1, ADR.Actual_Right_End_Date ))   
										WHEN (@Right_Start_Date Not Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date) AND (@Right_End_Date Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date)
											THEN DATEDIFF(d, ADR.Actual_Right_Start_Date,DATEADD(d,1, @Right_End_Date))
										WHEN (@Right_Start_Date < ADR.Actual_Right_Start_Date) AND (@Right_End_Date > ADR.Actual_Right_End_Date)
											THEN DATEDIFF(d,ADR.Actual_Right_Start_Date, DATEADD(d,1, ADR.Actual_Right_End_Date ))
										WHEN (@Right_Start_Date Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date) AND (@Right_End_Date Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date)
											THEN DATEDIFF(d,@Right_Start_Date,DATEADD(d,1, @Right_End_Date  ))
										ELSE 0 
									END
								)
								OVER(PARTITION BY ADR.Acq_Deal_Rights_Code) AS Partition_Of
								FROM #Syn_Deal_Rights_Dubbing sdrp
								INNER JOIN #NotInSynRights nin ON nin.Syn_Deal_Rights_Code = sdrp.Syn_Deal_Rights_Code
								INNER JOIN (
									SELECT DISTINCT Acq_Deal_Rights_Code, CASE WHEN ADRT.Language_Type = 'G' THEN TD.Language_Code ELSE ADRT.Language_Code END AS Language_Code 
									FROM Acq_Deal_Rights_Dubbing ADRT
									LEFT JOIN Language_Group_Details TD On ADRT.Language_Group_Code = TD.Language_Group_Code
									WHERE adrt.Acq_Deal_Rights_Code IN (
										SELECT ninin.Acq_Deal_Rights_Code FROM #NotInSynRights ninin
									)
								) adrp ON nin.Acq_Deal_Rights_Code = adrp.Acq_Deal_Rights_Code AND sdrp.Language_Code = adrp.Language_Code
								INNER JOIN Acq_Deal_Rights ADR ON adrp.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code 
								INNER JOIN Acq_Deal adin ON ADR.Acq_Deal_Code = adin.Acq_Deal_Code
								WHERE adin.Role_Code = 39
								GROUP BY ADR.Acq_Deal_Rights_Code, Actual_Right_Start_Date, Actual_Right_End_Date, sdrp.Language_Code
							) AS a GROUP BY Language_Code
						) AS neo ON neo.Language_Code = tsdrp.Language_Code
					
					END

					DELETE sdrt
					FROM #Syn_Deal_Rights_Dubbing sdrt
					INNER JOIN #NotInSynRights nin ON nin.Syn_Deal_Rights_Code = sdrt.Syn_Deal_Rights_Code
					INNER JOIN (
						SELECT DISTINCT Acq_Deal_Rights_Code, CASE WHEN ADRT.Language_Type = 'L' THEN ADRT.Language_Code ELSE TD.Language_Code END AS Language_Code 
						FROM Acq_Deal_Rights_Dubbing ADRT
						LEFT JOIN Language_Group_Details TD On ADRT.Language_Group_Code = TD.Language_Group_Code
						WHERE adrt.Acq_Deal_Rights_Code IN (
							SELECT Acq_Deal_Rights_Code FROM #NotInSynRights
						)
					) adrt1 ON adrt1.Acq_Deal_Rights_Code = nin.Acq_Deal_Rights_Code AND adrt1.Language_Code = sdrt.Language_Code
					--WHERE @SynSumOf <= @SumOf
					
				END
				--SELECT * 
					
				--SELECT @Is_Title_Language_Right, * FROM #Syn_Deal_Rights
				--SELECT * FROM #Syn_Deal_Rights_Platform
				--SELECT * FROM #Syn_Deal_Rights_Territory
				--SELECT * FROM #Syn_Deal_Rights_Subtitling
				--SELECT * FROM #Syn_Deal_Rights_Dubbing

				DELETE FROM #Syn_Deal_Rights WHERE Syn_Deal_Rights_Code NOT IN (
					SELECT DISTINCT Syn_Deal_Rights_Code FROM #Syn_Deal_Rights_Platform UNION
					SELECT DISTINCT Syn_Deal_Rights_Code FROM #Syn_Deal_Rights_Territory UNION
					SELECT DISTINCT Syn_Deal_Rights_Code FROM #Syn_Deal_Rights_Subtitling UNION
					SELECT DISTINCT Syn_Deal_Rights_Code FROM #Syn_Deal_Rights_Dubbing
				)

				--SELECT * FROM #Syn_Deal_Rights

			END
			--IF(OBJECT_ID('TEMPDB..#Acq_Deal_Rights') IS NOT NULL) Drop Table #Acq_Deal_Rights
			IF(OBJECT_ID('TEMPDB..#Temp_Acq_Country') IS NOT NULL) Drop Table #Temp_Acq_Country
			IF(OBJECT_ID('TEMPDB..#Temp_Acq_Subtitling') IS NOT NULL) DROP TABLE #Temp_Acq_Subtitling
			IF(OBJECT_ID('TEMPDB..#Temp_Acq_Dubbing') IS NOT NULL) DROP TABLE #Temp_Acq_Dubbing
				
			--SELECT COUNT(ISNULL(Syn_Deal_Rights_Code,0)) FROM #Syn_Deal_Rights_Platform
			--SELECT COUNT(ISNULL(Syn_Deal_Rights_Code,0)) FROM #Syn_Deal_Rights_Territory

			--SELECT 'ad', * FROM #Syn_Deal_Rights

			IF(
				(SELECT COUNT(ISNULL(Subtitling_Code,0)) FROM @Deal_Rights_Subtitling) = 0 AND 
				(SELECT COUNT(ISNULL(Dubbing_Code,0)) FROM @Deal_Rights_Dubbing) = 0
			)
			BEGIN

				DELETE  FROM #Syn_Deal_Rights WHERE Is_Title_Language_Right = 'N'
				AND Syn_Deal_Rights_Code NOT IN (
					SELECT Syn_Deal_Rights_Code FROM #Syn_Deal_Rights_Platform UNION
					SELECT Syn_Deal_Rights_Code FROM #Syn_Deal_Rights_Territory
				)
				
			END
			ELSE 
			BEGIN
				INSERT INTO #Syn_Rights_Code_Lang
				SELECT Distinct R.Syn_Deal_Rights_Code FROM #Syn_Deal_Rights R
				WHERE (R.Is_Title_Language_Right = 'Y' AND @Is_Title_Language_Right = 'Y')
				
				INSERT INTO #Syn_Rights_Code_Lang
				SELECT Distinct Syn_Deal_Rights_Code FROM #Syn_Deal_Rights_Subtitling 
				WHERE (ISNULL(Language_Code,0) <> 0 OR ISNULL(Language_Group_Code,0) <> 0)
				
				INSERT INTO #Syn_Rights_Code_Lang	
				SELECT Distinct Syn_Deal_Rights_Code FROM #Syn_Deal_Rights_Dubbing 
				WHERE (ISNULL(Language_Code,0) <> 0 OR ISNULL(Language_Group_Code,0) <> 0)
					
				DELETE FROM #Syn_Deal_Rights
				WHERE Syn_Deal_Rights_Code NOT IN(SELECT Deal_Rights_Code FROM #Syn_Rights_Code_Lang) 
				AND Syn_Deal_Rights_Code NOT IN (
					SELECT Syn_Deal_Rights_Code FROM #Syn_Deal_Rights_Platform UNION
					SELECT Syn_Deal_Rights_Code FROM #Syn_Deal_Rights_Territory
				)
					
			END
				
			--SELECT * FROM #Syn_Deal_Rights

			DELETE FROM #Syn_Deal_Rights_Title WHERE Syn_Deal_Rights_Code not in (
				SELECT Syn_Deal_Rights_Code FROM #Syn_Deal_Rights
			)
			DELETE FROM #Syn_Deal_Rights_Territory WHERE Syn_Deal_Rights_Code not in (
				SELECT Syn_Deal_Rights_Code FROM #Syn_Deal_Rights
			)
			DELETE FROM #Syn_Deal_Rights_Platform WHERE Syn_Deal_Rights_Code not in (
				SELECT Syn_Deal_Rights_Code FROM #Syn_Deal_Rights
			)
				
			--SELECT * FROM #Syn_Deal_Rights_Platform
			--SELECT * FROM #Syn_Deal_Rights_Territory
			--SELECT * FROM #Syn_Deal_Rights_Subtitling
			--SELECT * FROM #Syn_Deal_Rights_Dubbing

			DECLARE @Dummy_Platform_Code INT = 0
			SELECT TOP 1 @Dummy_Platform_Code = Platform_Code FROM Syn_Deal_Rights_Platform WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code

			--SELECT 'AD - CoEx'
			IF(@Is_Exclusive = 'C')
			BEGIN
				--SELECT 'AD - CoEx In'
				DECLARE @MaxCoExclusiveSynAllowed INT = 0
				SELECT @MaxCoExclusiveSynAllowed = Parameter_Value FROM System_Parameter WHERE Parameter_Name = 'MaxCoExclusiveSynAllowed'
				SET @MaxCoExclusiveSynAllowed = ISNULL(@MaxCoExclusiveSynAllowed, 0)
					
				IF((SELECT COUNT(DISTINCT Is_Exclusive) FROM #Syn_Deal_Rights sdr) = 1)
				BEGIN
					IF((SELECT DISTINCT Is_Exclusive FROM #Syn_Deal_Rights sdr) = 'C')
					BEGIN
						IF((SELECT COUNT(DISTINCT Vendor_Code) FROM #Syn_Deal_Rights sdr
						INNER JOIN Syn_Deal sd ON sdr.Syn_Deal_Code = sd.Syn_Deal_Code) <= @MaxCoExclusiveSynAllowed)
						BEGIN
							DELETE FROM #Syn_Deal_Rights
						END
					END
				END
				ELSE
				BEGIN

					--SELECT * FROM #Syn_Deal_Rights
					--SELECT * FROM #Syn_Deal_Rights_Platform
					--SELECT * FROM #Syn_Deal_Rights_Territory
					--SELECT * FROM #Syn_Deal_Rights_Subtitling
					--SELECT * FROM #Syn_Deal_Rights_Dubbing

					DELETE FROM #Syn_Deal_Rights_Platform WHERE Platform_Code IN (
						SELECT Platform_Code FROM (
							SELECT DISTINCT Platform_Code, STUFF
							(
								(
									SELECT DISTINCT ',' + CAST(sdr.Is_Exclusive AS VARCHAR) 
									FROM #Syn_Deal_Rights sdr WHERE sdr.Syn_Deal_Rights_Code = sdrp.Syn_Deal_Rights_Code
									FOR XML PATH('')
								), 1, 1, ''
							) AS Is_Exclusive,
							(
								SELECT COUNT(*) FROM #Syn_Deal_Rights sdr WHERE sdr.Syn_Deal_Rights_Code = sdrp.Syn_Deal_Rights_Code
							) AS CNT
							FROM #Syn_Deal_Rights_Platform sdrp
						) AS main WHERE main.Is_Exclusive = 'C' AND CNT = @MaxCoExclusiveSynAllowed
					)

					DELETE FROM #Syn_Deal_Rights_Territory WHERE Country_Code IN (
						SELECT Country_Code FROM (
							SELECT DISTINCT Country_Code, STUFF
							(
								(
									SELECT DISTINCT ',' + CAST(sdr.Is_Exclusive AS VARCHAR) 
									FROM #Syn_Deal_Rights sdr WHERE sdr.Syn_Deal_Rights_Code = sdrp.Syn_Deal_Rights_Code
									FOR XML PATH('')
								), 1, 1, ''
							) AS Is_Exclusive,
							(
								SELECT COUNT(*) FROM #Syn_Deal_Rights sdr WHERE sdr.Syn_Deal_Rights_Code = sdrp.Syn_Deal_Rights_Code
							) AS CNT
							FROM #Syn_Deal_Rights_Territory sdrp
						) AS main WHERE main.Is_Exclusive = 'C' AND CNT = @MaxCoExclusiveSynAllowed
					)
						
					DELETE FROM #Syn_Deal_Rights_Subtitling WHERE Language_Code IN (
						SELECT Language_Code FROM (
							SELECT DISTINCT Language_Code, STUFF
							(
								(
									SELECT DISTINCT ',' + CAST(sdr.Is_Exclusive AS VARCHAR) 
									FROM #Syn_Deal_Rights sdr WHERE sdr.Syn_Deal_Rights_Code = sdrp.Syn_Deal_Rights_Code
									FOR XML PATH('')
								), 1, 1, ''
							) AS Is_Exclusive,
							(
								SELECT COUNT(*) FROM #Syn_Deal_Rights sdr WHERE sdr.Syn_Deal_Rights_Code = sdrp.Syn_Deal_Rights_Code
							) AS CNT
							FROM #Syn_Deal_Rights_Subtitling sdrp
						) AS main WHERE main.Is_Exclusive = 'C' AND CNT = @MaxCoExclusiveSynAllowed
					)
						
					DELETE FROM #Syn_Deal_Rights_Dubbing WHERE Language_Code IN (
						SELECT Language_Code FROM (
							SELECT DISTINCT Language_Code, STUFF
							(
								(
									SELECT DISTINCT ',' + CAST(sdr.Is_Exclusive AS VARCHAR) 
									FROM #Syn_Deal_Rights sdr WHERE sdr.Syn_Deal_Rights_Code = sdrp.Syn_Deal_Rights_Code
									FOR XML PATH('')
								), 1, 1, ''
							) AS Is_Exclusive,
							(
								SELECT COUNT(*) FROM #Syn_Deal_Rights sdr WHERE sdr.Syn_Deal_Rights_Code = sdrp.Syn_Deal_Rights_Code
							) AS CNT
							FROM #Syn_Deal_Rights_Dubbing sdrp
						) AS main WHERE main.Is_Exclusive = 'C' AND CNT = @MaxCoExclusiveSynAllowed
					)
						
					DELETE FROM #Syn_Deal_Rights WHERE Syn_Deal_Rights_Code NOT IN (
						SELECT DISTINCT Syn_Deal_Rights_Code FROM #Syn_Deal_Rights_Platform UNION
						SELECT DISTINCT Syn_Deal_Rights_Code FROM #Syn_Deal_Rights_Territory UNION
						SELECT DISTINCT Syn_Deal_Rights_Code FROM #Syn_Deal_Rights_Subtitling UNION
						SELECT DISTINCT Syn_Deal_Rights_Code FROM #Syn_Deal_Rights_Dubbing
					)
						
					--SELECT * FROM #Syn_Deal_Rights
					--SELECT * FROM #Syn_Deal_Rights_Platform
					--SELECT * FROM #Syn_Deal_Rights_Territory
					--SELECT * FROM #Syn_Deal_Rights_Subtitling
					--SELECT * FROM #Syn_Deal_Rights_Dubbing

				END
			END
				
			SELECT SDR.*, SDRT.Title_Code, SDRT.Episode_From, SDRT.Episode_To, SDRP.Platform_Code
			INTO #Syn_Rights_New
			FROM #Syn_Deal_Rights SDR
			INNER JOIN #Syn_Deal_Rights_Title SDRT ON SDR.Syn_Deal_Rights_Code = SDRT.Syn_Deal_Rights_Code
			LEFT JOIN #Syn_Deal_Rights_Platform SDRP ON SDR.Syn_Deal_Rights_Code = SDRP.Syn_Deal_Rights_Code
				
			--SELECT * FROM #Syn_Deal_Rights
			--SELECT * FROM #Syn_Rights_New

			If Exists(SELECT TOP 1 * FROM #Syn_Rights_New)
			Begin
					
				IF EXISTS(SELECT TOP 1 * FROM #Syn_Deal_Rights_Platform)
				BEGIN

					Insert InTo Syn_Deal_Rights_Error_Details(Syn_Deal_Rights_Code, Title_Name, Platform_Name, Right_Start_Date, Right_End_Date, 
															Right_Type, 
															Is_Sub_Licence, 
															Is_Title_Language_Right, 
															Country_Name, 
															Subtitling_Language, 
															Dubbing_Language, 
															Agreement_No, 
															ErrorMsg, Episode_From, Episode_To, Inserted_On, 
															IsPushback)
					SELECT @Syn_Deal_Rights_Code, Title_Name, abcd.Platform_Hiearachy Platform_Name, Actual_Right_Start_Date, Actual_Right_End_Date,
						CASE WHEN Right_Type = 'Y' THEN 'Year Based' WHEN Right_Type = 'U' THEN 'Perpetuity' ELSE 'Milestone' END Right_Type,
						CASE WHEN Is_Sub_License = 'Y'	THEN 'Yes' ELSE 'No' END Is_Sub_License,
						CASE WHEN Is_Title_Language_Right = 'Y' THEN 'Yes' ELSE 'No' END Is_Title_Language_Right,
						CASE WHEN ISNULL(Country_Name,'')='' THEN 'NA' ELSE Country_Name END Country_Name,
						CASE WHEN ISNULL(Subtitling_Language,'')='' THEN 'NA' ELSE Subtitling_Language END Subtitling_Language,
						CASE WHEN ISNULL(Dubbing_Language,'')='' THEN 'NA' ELSE Dubbing_Language END Dubbing_Language,
						Agreement_No, ISNULL(ErrorMSG ,'NA') ErrorMSG, Episode_From, Episode_To, GETDATE(), 
						CASE WHEN ISNULL(Is_Pushback,'N') = 'N' THEN 'Rights' ELSE 'Pushback' END As Is_Pushback
					FROM(
						SELECT *,
						STUFF
						(
							(
							SELECT ', ' + C.Country_Name FROM Country C 
							WHERE c.Country_Code In(
								SELECT t.Country_Code FROM #Syn_Deal_Rights_Territory t 
								WHERE t.Syn_Deal_Rights_Code In (
									SELECT adrn.Syn_Deal_Rights_Code FROM #Syn_Rights_New adrn WHERE 
										a.Title_Code = adrn.Title_Code AND a.Actual_Right_Start_Date = adrn.Actual_Right_Start_Date 
										AND ISNULL(a.Actual_Right_End_Date,'')=ISNULL(adrn.Actual_Right_End_Date,'')
										AND a.Episode_From = adrn.Episode_From AND a.Episode_To = adrn.Episode_To 
										AND ISNULL(a.Is_Sub_License,'')=ISNULL(adrn.Is_Sub_License,'') 
										AND ISNULL(a.Is_Title_Language_Right,'')=ISNULL(adrn.Is_Title_Language_Right,'')
										AND ISNULL(a.Is_Pushback,'')=ISNULL(adrn.Is_Pushback,'')
								)
							)
							FOR XML PATH('')), 1, 1, ''
						) as Country_Name,
						STUFF
						(
							(
							SELECT ',' + CAST(P.Platform_Code as Varchar) 
							FROM Platform p WHERE p.Platform_Code In
							(
								SELECT adrn.Platform_Code 
								FROM #Syn_Rights_New adrn 
								WHERE a.Title_Code = adrn.Title_Code
								AND adrn.Platform_Code = p.Platform_Code
								AND ISNULL(a.Actual_Right_End_Date,'')=ISNULL(adrn.Actual_Right_End_Date,'')
								AND a.Episode_From = adrn.Episode_From AND a.Episode_To = adrn.Episode_To 
								AND ISNULL(a.Is_Sub_License,'')=ISNULL(adrn.Is_Sub_License,'') 
								AND ISNULL(a.Is_Title_Language_Right,'')=ISNULL(adrn.Is_Title_Language_Right,'')
								AND ISNULL(a.Is_Pushback,'')=ISNULL(adrn.Is_Pushback,'')
							)
							FOR XML PATH('')), 1, 1, ''
						) as Platform_Code,
						STUFF
						(
							(
							SELECT ', ' + l.Language_Name FROM Language l 
							WHERE l.Language_Code In(
								SELECT t.Language_Code FROM #Syn_Deal_Rights_Subtitling t 
								WHERE t.Syn_Deal_Rights_Code In (
									SELECT adrn.Syn_Deal_Rights_Code FROM #Syn_Rights_New adrn 
									WHERE a.Title_Code = adrn.Title_Code AND a.Actual_Right_Start_Date = adrn.Actual_Right_Start_Date 
										AND ISNULL(a.Actual_Right_End_Date,'')=ISNULL(adrn.Actual_Right_End_Date,'')
										AND a.Episode_From = adrn.Episode_From AND a.Episode_To = adrn.Episode_To 
										AND ISNULL(a.Is_Sub_License,'')=ISNULL(adrn.Is_Sub_License,'') 
										AND ISNULL(a.Is_Title_Language_Right,'')=ISNULL(adrn.Is_Title_Language_Right,'')
										AND ISNULL(a.Is_Pushback,'')=ISNULL(adrn.Is_Pushback,'')
								)
							)
							FOR XML PATH('')), 1, 1, ''
						) as Subtitling_Language,
						STUFF
						(
							(
							SELECT ', ' + l.Language_Name FROM Language l 
							WHERE l.Language_Code In(
								SELECT t.Language_Code FROM #Syn_Deal_Rights_Dubbing t WHERE t.Syn_Deal_Rights_Code In (
									SELECT adrn.Syn_Deal_Rights_Code FROM #Syn_Rights_New adrn 
									WHERE a.Title_Code = adrn.Title_Code AND a.Actual_Right_Start_Date = adrn.Actual_Right_Start_Date 
										AND ISNULL(a.Actual_Right_End_Date,'')=ISNULL(adrn.Actual_Right_End_Date,'')
										AND a.Episode_From = adrn.Episode_From AND a.Episode_To = adrn.Episode_To 
										AND ISNULL(a.Is_Sub_License,'')=ISNULL(adrn.Is_Sub_License,'') 
										AND ISNULL(a.Is_Title_Language_Right,'')=ISNULL(adrn.Is_Title_Language_Right,'')
										AND ISNULL(a.Is_Pushback,'')=ISNULL(adrn.Is_Pushback,'')
								)
							)
							FOR XML PATH('')), 1, 1, ''
						) as Dubbing_Language,
						STUFF
						(
							(
							SELECT ', ' + t.Agreement_No FROM Syn_Deal t
							WHERE t.Deal_Workflow_Status NOT IN ('AR') AND t.Syn_Deal_Code In (
								SELECT adrn.Syn_Deal_Code FROM #Syn_Rights_New adrn
								WHERE a.Title_Code = adrn.Title_Code AND a.Actual_Right_Start_Date = adrn.Actual_Right_Start_Date
									AND ISNULL(a.Actual_Right_End_Date,'')=ISNULL(adrn.Actual_Right_End_Date,'')
									AND a.Episode_From = adrn.Episode_From AND a.Episode_To = adrn.Episode_To 
									AND ISNULL(a.Is_Sub_License,'')=ISNULL(adrn.Is_Sub_License,'') 
									AND ISNULL(a.Is_Title_Language_Right,'')=ISNULL(adrn.Is_Title_Language_Right,'')
									AND ISNULL(a.Is_Pushback,'')=ISNULL(adrn.Is_Pushback,'')
							)
							FOR XML PATH('')), 1, 1, ''
						) as Agreement_No
						FROM (
							SELECT T.Title_Code,
								DBO.UFN_GetTitleNameInFormat([dbo].[UFN_GetDealTypeCondition](Deal_Type_Code), T.Title_Name, Episode_From, Episode_To) AS Title_Name,
								ADR.Actual_Right_Start_Date, ADR.Actual_Right_End_Date,
								Is_Sub_License, Is_Title_Language_Right, 
								CASE 
									WHEN @Deal_Code <> ADR.Syn_Deal_Code THEN  'Combination already Syndicated'
									ELSE 'Combination conflicts with other Rights'
								END AS ErrorMSG, 
								Right_Type, Episode_From, Episode_To, Is_Pushback
							FROM #Syn_Rights_New ADR
							INNER JOIN Title T ON T.Title_Code=ADR.Title_Code
							Group By T.Title_Code, T.Title_Name, Actual_Right_Start_Date, Actual_Right_End_Date, Is_Sub_License,
								Is_Title_Language_Right, Right_Type, Episode_From, Episode_To, Deal_Type_Code, ADR.Syn_Deal_Code, Is_Pushback
						) as a
					) as MainOutput
					Cross Apply
					(
						SELECT * FROM [dbo].[UFN_Get_Platform_With_Parent](MainOutput.Platform_Code)
					) as abcd
					
				END
				ELSE
				BEGIN
					
					Insert InTo Syn_Deal_Rights_Error_Details(Syn_Deal_Rights_Code, Title_Name, Platform_Name, Right_Start_Date, Right_End_Date, 
															Right_Type, 
															Is_Sub_Licence, 
															Is_Title_Language_Right, 
															Country_Name, 
															Subtitling_Language, 
															Dubbing_Language, 
															Agreement_No, 
															ErrorMsg, Episode_From, Episode_To, Inserted_On, 
															IsPushback)
					SELECT @Syn_Deal_Rights_Code, Title_Name, 'NA', Actual_Right_Start_Date, Actual_Right_End_Date,
						CASE WHEN Right_Type = 'Y' THEN 'Year Based' WHEN Right_Type = 'U' THEN 'Perpetuity' ELSE 'Milestone' END Right_Type,
						CASE WHEN Is_Sub_License = 'Y'	THEN 'Yes' ELSE 'No' END Is_Sub_License,
						CASE WHEN Is_Title_Language_Right = 'Y' THEN 'Yes' ELSE 'No' END Is_Title_Language_Right,
						CASE WHEN ISNULL(Country_Name,'')='' THEN 'NA' ELSE Country_Name END Country_Name,
						CASE WHEN ISNULL(Subtitling_Language,'')='' THEN 'NA' ELSE Subtitling_Language END Subtitling_Language,
						CASE WHEN ISNULL(Dubbing_Language,'')='' THEN 'NA' ELSE Dubbing_Language END Dubbing_Language,
						Agreement_No, ISNULL(ErrorMSG ,'NA') ErrorMSG, Episode_From, Episode_To, GETDATE(), 
						CASE WHEN ISNULL(Is_Pushback,'N') = 'N' THEN 'Rights' ELSE 'Pushback' END As Is_Pushback
					FROM(
						SELECT *,
						STUFF
						(
							(
							SELECT ', ' + C.Country_Name FROM Country C 
							WHERE c.Country_Code In(
								SELECT t.Country_Code FROM #Syn_Deal_Rights_Territory t 
								WHERE t.Syn_Deal_Rights_Code In (
									SELECT adrn.Syn_Deal_Rights_Code FROM #Syn_Rights_New adrn WHERE 
										a.Title_Code = adrn.Title_Code AND a.Actual_Right_Start_Date = adrn.Actual_Right_Start_Date 
										AND ISNULL(a.Actual_Right_End_Date,'')=ISNULL(adrn.Actual_Right_End_Date,'')
										AND a.Episode_From = adrn.Episode_From AND a.Episode_To = adrn.Episode_To 
										AND ISNULL(a.Is_Sub_License,'')=ISNULL(adrn.Is_Sub_License,'') 
										AND ISNULL(a.Is_Title_Language_Right,'')=ISNULL(adrn.Is_Title_Language_Right,'')
										AND ISNULL(a.Is_Pushback,'')=ISNULL(adrn.Is_Pushback,'')
								)
							)
							FOR XML PATH('')), 1, 1, ''
						) as Country_Name,
						STUFF
						(
							(
							SELECT ',' + CAST(P.Platform_Code as Varchar) 
							FROM Platform p WHERE p.Platform_Code In
							(
								SELECT adrn.Platform_Code 
								FROM #Syn_Rights_New adrn 
								WHERE a.Title_Code = adrn.Title_Code
								AND adrn.Platform_Code = p.Platform_Code
								AND ISNULL(a.Actual_Right_End_Date,'')=ISNULL(adrn.Actual_Right_End_Date,'')
								AND a.Episode_From = adrn.Episode_From AND a.Episode_To = adrn.Episode_To 
								AND ISNULL(a.Is_Sub_License,'')=ISNULL(adrn.Is_Sub_License,'') 
								AND ISNULL(a.Is_Title_Language_Right,'')=ISNULL(adrn.Is_Title_Language_Right,'')
								AND ISNULL(a.Is_Pushback,'')=ISNULL(adrn.Is_Pushback,'')
							)
							FOR XML PATH('')), 1, 1, ''
						) as Platform_Code,
						STUFF
						(
							(
							SELECT ', ' + l.Language_Name FROM Language l 
							WHERE l.Language_Code In(
								SELECT t.Language_Code FROM #Syn_Deal_Rights_Subtitling t 
								WHERE t.Syn_Deal_Rights_Code In (
									SELECT adrn.Syn_Deal_Rights_Code FROM #Syn_Rights_New adrn 
									WHERE a.Title_Code = adrn.Title_Code AND a.Actual_Right_Start_Date = adrn.Actual_Right_Start_Date 
										AND ISNULL(a.Actual_Right_End_Date,'')=ISNULL(adrn.Actual_Right_End_Date,'')
										AND a.Episode_From = adrn.Episode_From AND a.Episode_To = adrn.Episode_To 
										AND ISNULL(a.Is_Sub_License,'')=ISNULL(adrn.Is_Sub_License,'') 
										AND ISNULL(a.Is_Title_Language_Right,'')=ISNULL(adrn.Is_Title_Language_Right,'')
										AND ISNULL(a.Is_Pushback,'')=ISNULL(adrn.Is_Pushback,'')
								)
							)
							FOR XML PATH('')), 1, 1, ''
						) as Subtitling_Language,
						STUFF
						(
							(
							SELECT ', ' + l.Language_Name FROM Language l 
							WHERE l.Language_Code In(
								SELECT t.Language_Code FROM #Syn_Deal_Rights_Dubbing t WHERE t.Syn_Deal_Rights_Code In (
									SELECT adrn.Syn_Deal_Rights_Code FROM #Syn_Rights_New adrn 
									WHERE a.Title_Code = adrn.Title_Code AND a.Actual_Right_Start_Date = adrn.Actual_Right_Start_Date 
										AND ISNULL(a.Actual_Right_End_Date,'')=ISNULL(adrn.Actual_Right_End_Date,'')
										AND a.Episode_From = adrn.Episode_From AND a.Episode_To = adrn.Episode_To 
										AND ISNULL(a.Is_Sub_License,'')=ISNULL(adrn.Is_Sub_License,'') 
										AND ISNULL(a.Is_Title_Language_Right,'')=ISNULL(adrn.Is_Title_Language_Right,'')
										AND ISNULL(a.Is_Pushback,'')=ISNULL(adrn.Is_Pushback,'')
								)
							)
							FOR XML PATH('')), 1, 1, ''
						) as Dubbing_Language,
						STUFF
						(
							(
							SELECT ', ' + t.Agreement_No FROM Syn_Deal t
							WHERE t.Deal_Workflow_Status NOT IN ('AR') AND t.Syn_Deal_Code In (
								SELECT adrn.Syn_Deal_Code FROM #Syn_Rights_New adrn
								WHERE a.Title_Code = adrn.Title_Code AND a.Actual_Right_Start_Date = adrn.Actual_Right_Start_Date
									AND ISNULL(a.Actual_Right_End_Date,'')=ISNULL(adrn.Actual_Right_End_Date,'')
									AND a.Episode_From = adrn.Episode_From AND a.Episode_To = adrn.Episode_To 
									AND ISNULL(a.Is_Sub_License,'')=ISNULL(adrn.Is_Sub_License,'') 
									AND ISNULL(a.Is_Title_Language_Right,'')=ISNULL(adrn.Is_Title_Language_Right,'')
									AND ISNULL(a.Is_Pushback,'')=ISNULL(adrn.Is_Pushback,'')
							)
							FOR XML PATH('')), 1, 1, ''
						) as Agreement_No
						FROM (
							SELECT T.Title_Code,
								DBO.UFN_GetTitleNameInFormat([dbo].[UFN_GetDealTypeCondition](Deal_Type_Code), T.Title_Name, Episode_From, Episode_To) AS Title_Name,
								ADR.Actual_Right_Start_Date, ADR.Actual_Right_End_Date,
								Is_Sub_License, Is_Title_Language_Right, 
								CASE 
									WHEN @Deal_Code <> ADR.Syn_Deal_Code THEN  'Combination already Syndicated'
									ELSE 'Combination conflicts with other Rights'
								END AS ErrorMSG, 
								Right_Type, Episode_From, Episode_To, Is_Pushback
							FROM #Syn_Rights_New ADR
							INNER JOIN Title T ON T.Title_Code=ADR.Title_Code
							Group By T.Title_Code, T.Title_Name, Actual_Right_Start_Date, Actual_Right_End_Date, Is_Sub_License,
								Is_Title_Language_Right, Right_Type, Episode_From, Episode_To, Deal_Type_Code, ADR.Syn_Deal_Code, Is_Pushback
						) as a
					) as MainOutput
					--Cross Apply
					--(
					--	SELECT * FROM [dbo].[UFN_Get_Platform_With_Parent](MainOutput.Platform_Code)
					--) as abcd
					
				END

				UPDATE Syn_Deal_Rights Set Right_Status = 'E' WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
				SET @Is_Error = 'Y'
			END
			--ELSE If(@Is_Error = 'N')
			--Begin
			--	UPDATE Syn_Deal_Rights Set Right_Status = 'C' WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
			--END

			/*Checking of error in two procedures*/
			IF(@Syn_Error = 'Y' OR @Is_Error = 'Y')
			BEGIN
			Print 'Rights Processing Status = Error'
				UPDATE Syn_Deal_Rights Set Right_Status = 'E' WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
			END
			ELSE
			BEGIN
			Print 'Rights Processing Status = Correct'
				UPDATE Syn_Deal_Rights Set Right_Status = 'C' WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
			END
			/*END*/
			--SELECT CAST('ad' As Int)

			IF OBJECT_ID('tempdb..#Syn_Rights_New') IS NOT NULL Drop Table #Syn_Rights_New
			IF OBJECT_ID('tempdb..#Syn_Deal_Rights') IS NOT NULL Drop Table #Syn_Deal_Rights
			IF OBJECT_ID('tempdb..#Syn_Deal_Rights_Title') IS NOT NULL Drop Table #Syn_Deal_Rights_Title
			IF OBJECT_ID('tempdb..#Syn_Deal_Rights_Platform') IS NOT NULL Drop Table #Syn_Deal_Rights_Platform
			IF OBJECT_ID('tempdb..#Syn_Deal_Rights_Territory') IS NOT NULL Drop Table #Syn_Deal_Rights_Territory
			IF OBJECT_ID('tempdb..#Syn_Deal_Rights_Subtitling') IS NOT NULL Drop Table #Syn_Deal_Rights_Subtitling
			IF OBJECT_ID('tempdb..#Syn_Deal_Rights_Dubbing') IS NOT NULL Drop Table #Syn_Deal_Rights_Dubbing
			IF OBJECT_ID('tempdb..#Syn_Rights_Code_Lang') IS NOT NULL Drop Table #Syn_Rights_Code_Lang
			IF OBJECT_ID('tempdb..#NotInSynRights') IS NOT NULL DROP TABLE #NotInSynRights

		END  ------------------------ END

		--Fetch Next FROM CUS_SynRight_Titles InTo @Cur_Title_code, @Cur_From_Episode_No, @Cur_To_Episode_No
	END
	--CLOSE CUS_SynRight_Titles
	--DEALLOCATE CUS_SynRight_Titles
	IF(OBJECT_ID('TEMPDB..#Acq_Deal_Rights') IS NOT NULL) Drop Table #Acq_Deal_Rights
	-----------------------------INSERTION  OF Error in UTO_ExcepitionLog AND Trigger Mail to Dev team Table-------------------------------------			
	IF EXISTS(SELECT * FROM Syn_Deal_Rights WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code AND  Right_Status = 'E')
	BEGIN
		SELECT @Agreement_No = SD.Agreement_No FROM Syn_Deal_Rights SDR
		INNER JOIN Syn_Deal SD ON SDR.Syn_Deal_Code = SD.Syn_Deal_Code
		WHERE SD.Deal_Workflow_Status NOT IN ('AR') AND SDR.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code 

		SET @Sql = 'There is an error occured while validating a syndication rights. Syndication Agreement No : '+ @Agreement_No 

		INSERT INTO UTO_ExceptionLog(Exception_Log_Date,Controller_Name,Action_Name,ProcedureName,Exception,Inner_Exception,StackTrace,Code_Break)
		SELECT GETDATE(),null,null,'USP_Validate_Rights_Duplication_UDT_Syn',@Sql,'NA','NA','DB' 
		FROM Syn_Deal_Rights WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code AND  Right_Status = 'E'

		SELECT @DB_Name = DB_NAME()
		EXEC [dbo].[USP_SendMail_Page_Crashed] 'SysDB User', @DB_Name,'RU','USP_Validate_Rights_Duplication_UDT_Syn','AN','VN',@sql,'DB','IP','FR','TI'
	END
END