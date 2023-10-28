CREATE PROC [dbo].[USPRUR_VALIDATE_Content]
(
	@RightsDefination RightsDefination READONLY
)
AS
BEGIN
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPRUR_VALIDATE_Content]', 'Step 1', 0, 'Started Procedure', 0, ''
		--SELECT * INTO RURRightsDefination FROM @RightsDefination

		DECLARE @Deal_Rights_Title Deal_Rights_Title
		DECLARE @Deal_Rights_Platform Deal_Rights_Platform
		DECLARE @Deal_Rights_Territory Deal_Rights_Territory
		DECLARE @Deal_Rights_Subtitling Deal_Rights_Subtitling
		DECLARE @Deal_Rights_Dubbing Deal_Rights_Dubbing
		DECLARE @Syn_Deal_Code Int = 0

		CREATE TABLE #Temp_Episode_No
		(
			Episode_No Int
		)
	
		CREATE TABLE #Deal_Right_Title_WithEpsNo
		(
			Deal_Rights_Code Int,
			Title_Code Int,
			Episode_No Int,
		)
	
		CREATE TABLE #TempCombination
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
			Data_From CHAR(1),
			Is_Available CHAR(1),
			Error_Description NVARCHAR(MAX),
			Sum_of Int,
			Partition_Of Int
		)
	
		CREATE TABLE #TempCombination_Session
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
			Data_From CHAR(1),
			Is_Available CHAR(1),
			Error_Description NVARCHAR(MAX),
			Sum_of Int,
			Partition_Of Int,
			MessageUpadated CHAR(1) DEFAULT('N')
		)
	
		Create TABLE #TempRightsError(
			IntCode INT,
			TitleName NVARCHAR(500),
			TitleCode INT, 
			EpisodeStart INT, 
			EpisodeEnd INT, 
			PlatformName NVARCHAR(500),
			PlatformCode INT, 
			CountryName NVARCHAR(500),
			CountryCode INT, 
			StartDate Date, 
			EndDate Date,
			ErrorMessage NVARCHAR(MAX)
		);

		With gen As (
			Select 1 As num Union All
			Select num+1 From gen  Where num + 1 <= 10000
		)

		Insert InTo #Temp_Episode_No
		Select * From gen  Option (maxrecursion 10000)
	
		DECLARE @IntCode INT, @TitleCode INT, @EpisodeStart INT, @EpisodeEnd INT, @StartDate Date, @EndDate Date,
				@Is_Title_Language_Right Char(1) = 'Y', @Is_Exclusive Char(1) = 'N', @Is_Error Char(1) = 'N', @Right_Type Char(1) = 'Y',
				@CountryCodes VARCHAR(4000) = '', @PlatformCodes VARCHAR(4000) = '', @DubbingCodes VARCHAR(4000) = '', @SubtitlingCodes VARCHAR(4000) = ''
		DECLARE EUR_Rights CURSOR FOR 
			SELECT IntCode, TitleCode, EpisodeStart, EpisodeEnd, StartDate, EndDate, CountryCodes, PlatformCodes, DubbingCodes, SubtitlingCodes 
			FROM @RightsDefination ORDER BY TitleCode ASC, EpisodeStart ASC
		OPEN EUR_Rights
		FETCH NEXT FROM EUR_Rights INTO @IntCode, @TitleCode, @EpisodeStart, @EpisodeEnd, @StartDate, @EndDate, @CountryCodes, @PlatformCodes, @DubbingCodes, @SubtitlingCodes
		WHILE(@@FETCH_STATUS = 0)
		BEGIN
	
			TRUNCATE TABLE #Deal_Right_Title_WithEpsNo
			TRUNCATE TABLE #TempCombination_Session
			TRUNCATE TABLE #TempCombination

			DELETE FROM @Deal_Rights_Title
			DELETE FROM @Deal_Rights_Territory
			DELETE FROM @Deal_Rights_Platform
		
			INSERT INTO @Deal_Rights_Title(Title_Code, Episode_From, Episode_To)
			SELECT @TitleCode, @EpisodeStart, @EpisodeEnd

			INSERT INTO @Deal_Rights_Territory(Deal_Rights_Code, Country_Code)
			SELECT 0, number FROM dbo.fn_Split_withdelemiter(@CountryCodes, ',') WHERE number <> ''

			INSERT INTO @Deal_Rights_Platform(Deal_Rights_Code, Platform_Code)
			SELECT 0, number FROM dbo.fn_Split_withdelemiter(@PlatformCodes, ',') WHERE number <> ''

			--SELECT * FROM @Deal_Rights_Title

			SELECT @Is_Error = 'N'
	
			INSERT INTO #Deal_Right_Title_WithEpsNo(Title_Code, Episode_No)
			SELECT @TitleCode, Episode_No FROM #Temp_Episode_No WHERE Episode_No Between @EpisodeStart And @EpisodeEnd

	
			SELECT ADR.Acq_Deal_Rights_Code, Right_Type, Actual_Right_Start_Date, Actual_Right_End_Date, Is_Title_Language_Right,
					Is_Exclusive, ADR.Acq_Deal_Code, AD.Agreement_No,
					(Select Count(*) From Acq_Deal_Rights_Subtitling a (NOLOCK) Where a.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) SubCnt, 
					(Select Count(*) From Acq_Deal_Rights_Dubbing a (NOLOCK) Where a.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) DubCnt,
					Sum(                        
						Case 
							When (@StartDate Between ADR.Actual_Right_Start_Date And ADR.Actual_Right_End_Date) And (@EndDate Not Between ADR.Actual_Right_Start_Date  And ADR.Actual_Right_End_Date)
								Then datediff(d,@StartDate, DATEADD(d,1, ADR.Actual_Right_End_Date ))
							When (@StartDate Not Between ADR.Actual_Right_Start_Date And ADR.Actual_Right_End_Date) And (@EndDate Between ADR.Actual_Right_Start_Date And ADR.Actual_Right_End_Date)
								Then datediff(d, ADR.Actual_Right_Start_Date,DATEADD(d,1, @EndDate))
							When (@StartDate < ADR.Actual_Right_Start_Date) And (@EndDate > ADR.Actual_Right_End_Date)
								Then datediff(d,ADR.Actual_Right_Start_Date, DATEADD(d,1, ADR.Actual_Right_End_Date))
							When (@StartDate Between ADR.Actual_Right_Start_Date And ADR.Actual_Right_End_Date) And (@EndDate Between ADR.Actual_Right_Start_Date And ADR.Actual_Right_End_Date)
								Then datediff(d,@StartDate,DATEADD(d,1, @EndDate  ))
							Else 0 
						End
					)Sum_of,
					Sum(
						Case 
							When (@StartDate Between ADR.Actual_Right_Start_Date And ADR.Actual_Right_End_Date) And (@EndDate Not Between ADR.Actual_Right_Start_Date  And ADR.Actual_Right_End_Date)
								Then datediff(d,@StartDate, DATEADD(d,1, ADR.Actual_Right_End_Date ))   
							When (@StartDate Not Between ADR.Actual_Right_Start_Date And ADR.Actual_Right_End_Date) And (@EndDate Between ADR.Actual_Right_Start_Date And ADR.Actual_Right_End_Date)
								Then datediff(d, ADR.Actual_Right_Start_Date,DATEADD(d,1, @EndDate))
							When (@StartDate < ADR.Actual_Right_Start_Date) And (@EndDate > ADR.Actual_Right_End_Date)
								Then datediff(d,ADR.Actual_Right_Start_Date, DATEADD(d,1, ADR.Actual_Right_End_Date ))
							When (@StartDate Between ADR.Actual_Right_Start_Date And ADR.Actual_Right_End_Date) And (@EndDate Between ADR.Actual_Right_Start_Date And ADR.Actual_Right_End_Date)
								Then datediff(d,@StartDate,DATEADD(d,1, @EndDate  ))
							Else 0 
						End
					)
					OVER(
						PARTITION BY ADR.Acq_Deal_Rights_Code, Right_Type, Actual_Right_Start_Date, Actual_Right_End_Date, Is_Title_Language_Right,Is_Exclusive, adr.Acq_Deal_Code
					) Partition_Of
					InTo #Acq_Deal_Rights
			From Acq_Deal_Rights ADR (NOLOCK)
			Inner Join Acq_Deal AD (NOLOCK) On ADR.Acq_Deal_Code = ad.Acq_Deal_Code --And IsNull(AD.Deal_Workflow_Status,'') = 'A'
			Where 
			ADR.Acq_Deal_Code Is Not Null
			--AND AD.Acq_Deal_Code = 695
			--AND Acq_Deal_Rights_Code IN (1071,1072,11481)
			--And ADR.Is_Sub_License='Y'
			--And ADR.Is_Tentative='N'
			And
			(
				(
					ADR.Right_Type ='Y' AND
					(
						(CONVERT(DATETIME, @StartDate, 103) Between CONVERT(DATETIME, ADR.Right_Start_Date, 103) And Convert(DATETIME, ADR.Right_End_Date, 103)) OR
						(CONVERT(DATETIME, @EndDate, 103) Between CONVERT(DATETIME, ADR.Right_Start_Date, 103) And CONVERT(DATETIME, ADR.Right_End_Date, 103)) OR
						(CONVERT(DATETIME, ADR.Right_Start_Date, 103) Between CONVERT(DATETIME, @StartDate, 103) And CONVERT(DATETIME, @EndDate, 103)) OR
						(CONVERT(DATETIME, ADR.Right_End_Date, 103) Between CONVERT(DATETIME, @StartDate, 103) And CONVERT(DATETIME, @EndDate, 103))
					)
				)OR(ADR.Right_Type ='U'  OR ADR.Right_Type ='M')
			) 
			AND (    
				(ADR.Is_Title_Language_Right = @Is_Title_Language_Right) OR 
				(@Is_Title_Language_Right <> 'Y' And ADR.Is_Title_Language_Right = 'Y') OR 
				(@Is_Title_Language_Right = 'Y' And ADR.Is_Title_Language_Right = 'N')
			) AND (
				(@Is_Exclusive = 'Y' And IsNull(ADR.Is_exclusive,'')='Y') OR @Is_Exclusive = 'N'
			) 
			GROUP BY ADR.Acq_Deal_Rights_Code, Right_Type, Actual_Right_Start_Date, Actual_Right_End_Date, Is_Title_Language_Right,Is_Exclusive, adr.Acq_Deal_Code, AD.Agreement_No

			Select Distinct ADR.Acq_Deal_Rights_Code, ADRT.Title_Code, ADRT.Episode_From, ADRT.Episode_To, ADR.SubCnt, ADR.DubCnt,
							ADR.Sum_of, ADR.Partition_Of
			InTo #Acq_Titles_With_Rights
			From #Acq_Deal_Rights ADR
			Inner Join dbo.Acq_Deal_Rights_Title ADRT (NOLOCK) On ADR.Acq_Deal_Rights_Code=ADRT.Acq_Deal_Rights_Code
			Inner Join @Deal_Rights_Title drt On ADRT.Title_Code = drt.Title_Code And 
			(
				(drt.Episode_From Between ADRT.Episode_From And ADRT.Episode_To)
				Or
				(drt.Episode_To Between ADRT.Episode_From And ADRT.Episode_To)
				Or
				(ADRT.Episode_From Between drt.Episode_From And drt.Episode_To)
				Or
				(ADRT.Episode_To Between drt.Episode_From And drt.Episode_To)
			)

			--Select * From @Deal_Rights_Title
			--Select * From #Acq_Deal_Rights
			--Select * From #Acq_Titles_With_Rights

			Begin ----------------- CHECK PLATFORM And TITLE & EPISODE EXISTS OR NOT

				Select Distinct Title_Code, Episode_From, Episode_To InTo #Acq_Titles From #Acq_Titles_With_Rights
			
				--Select * From #Acq_Titles

				Select Title_Code, Episode_No InTo #Acq_Avail_Title_Eps
				From (
					Select Distinct t.Title_Code, a.Episode_No 
					From #Temp_Episode_No A 
					Cross Apply #Acq_Titles T 
					Where A.Episode_No Between T.Episode_FROM And T.Episode_To
				) As B 
		
				--SELECT * FROM #Deal_Right_Title_WithEpsNo

				SELECT ROW_NUMBER() OVER(ORDER BY Title_Code, Episode_No ASC) RowId, * INTO #Title_Not_Acquire FROM #Deal_Right_Title_WithEpsNo deps
				WHERE deps.Episode_No NOT IN (
					SELECT Episode_No FROM #Acq_Avail_Title_Eps aeps WHERE deps.Title_Code = aeps.Title_Code
				)

				--SELECT * FROM #Title_Not_Acquire

				CREATE TABLE #Temp_NA_Title(
					Title_Code INT,
					Episode_From INT,
					Episode_To INT,
					Status CHAR(1)
				)

				DECLARE @Cur_Title_code INT = 0, @Cur_Episode_No INT = 0, @Prev_Title_Code INT = 0, @Prev_Episode_No INT
				DECLARE CUS_EPS CURSOR FOR 
					SELECT Title_code, Episode_No FROM #Title_Not_Acquire ORDER BY Title_code ASC, Episode_No ASC
				OPEN CUS_EPS
				FETCH NEXT FROM CUS_EPS INTO @Cur_Title_code, @Cur_Episode_No
				WHILE(@@FETCH_STATUS = 0)
				BEGIN
	
					If(@Cur_Title_code <> @Prev_Title_Code)
					Begin

						If Exists(Select Top 1 * From #Temp_NA_Title Where Status = 'U' And Title_Code = @Prev_Title_Code)
						Begin
							Update #Temp_NA_Title Set Episode_To = @Prev_Episode_No, Status = 'A' Where Status = 'U' And Title_Code = @Prev_Title_Code
						End

						Insert InTo #Temp_NA_Title(Title_Code, Episode_From, Status)
						Select @Cur_Title_code, @Cur_Episode_No, 'U'
						Set @Prev_Title_Code = @Cur_Title_code
					End
					Else If(@Cur_Title_code = @Prev_Title_Code And @Cur_Episode_No <> (@Prev_Episode_No + 1))
					Begin
						If Exists(Select Top 1 * From #Temp_NA_Title Where Status = 'U' And Title_Code = @Cur_Title_code)
						Begin
							Update #Temp_NA_Title Set Episode_To = @Prev_Episode_No, Status = 'A' Where Status = 'U' And Title_Code = @Cur_Title_code
						End
		
						Insert InTo #Temp_NA_Title(Title_Code, Episode_From, Status)
						Select @Cur_Title_code, @Cur_Episode_No, 'U'
					End
	
					Set @Prev_Episode_No = @Cur_Episode_No

					Fetch Next From CUS_EPS InTo @Cur_Title_code, @Cur_Episode_No
				End
				Close CUS_EPS
				Deallocate CUS_EPS

				If Exists(Select Top 1 * From #Temp_NA_Title Where Status = 'U' And Title_Code = @Prev_Title_Code)
				Begin
					Update #Temp_NA_Title Set Episode_To = @Prev_Episode_No, Status = 'A' Where Status = 'U' And Title_Code = @Prev_Title_Code
				End

				--Select * From #Temp_NA_Title

				If Exists(Select Top 1 * From #Temp_NA_Title)
				Begin
					Insert InTo #TempRightsError(IntCode, TitleName, TitleCode, EpisodeStart, EpisodeEnd, StartDate, EndDate, ErrorMessage)
					Select @IntCode, t.Title_Name, tnt.Title_Code, Episode_From, Episode_To, @StartDate, @EndDate, 'Title not acquired'
					From #Temp_NA_Title tnt
					Inner Join Title t (NOLOCK) On tnt.Title_Code = t.Title_Code

					Set @Is_Error = 'Y'
				End
	
			End ------------------------------ END
				

	
			Begin ----------------- CHECK PLATFORM And TITLE & EPISODE EXISTS OR NOT

				Select Distinct DRT.Title_Code, Episode_From, Episode_To, DRP.Platform_Code
				InTo #Temp_Platforms
				From #Acq_Titles DRT
				Inner Join @Deal_Rights_Platform DRP On 1 = 1

				--SELECT * FROM #Acq_Titles
				--SELECT * FROM #Acq_Titles_With_Rights

				SELECT art.*, adrp.Platform_Code INTO #Temp_Acq_Platform FROM #Acq_Titles_With_Rights art
				Inner Join Acq_Deal_Rights_Platform adrp (NOLOCK) On adrp.Acq_Deal_Rights_Code = art.Acq_Deal_Rights_Code
				Inner Join @Deal_Rights_Platform drp On adrp.Platform_Code = drp.Platform_Code

				--SELECT * FROM #Temp_Acq_Platform

				DELETE FROM #Temp_Acq_Platform WHERE Platform_Code NOT IN (SELECT Platform_Code FROM #Temp_Platforms)

				--SELECT * FROM #Temp_Acq_Platform

				Select Distinct DRT.Title_Code, Episode_From, Episode_To, DRT.Platform_Code InTo #NA_Platforms
				From #Temp_Platforms DRT
				Where DRT.Platform_Code Not In (
					Select ap.Platform_Code From #Temp_Acq_Platform ap
					Where DRT.Title_Code = ap.Title_Code And DRT.Episode_From = ap.Episode_From And DRT.Episode_To = ap.Episode_To
				)

				--SELECT * FROM #Temp_Platforms

				Delete From #Temp_Platforms Where #Temp_Platforms.Platform_Code In (
					Select np.Platform_Code From #NA_Platforms np
					Where np.Title_Code = #Temp_Platforms.Title_Code And np.Episode_From = #Temp_Platforms.Episode_From And np.Episode_To = #Temp_Platforms.Episode_To
				)

				--SELECT * FROM #Temp_Platforms
				--SELECT * FROM #NA_Platforms

				DELETE b FROM #Temp_Platforms a
				INNER JOIN #NA_Platforms b ON a.Platform_Code = b.Platform_Code AND a.Title_Code = b.Title_Code AND 
				(
					(a.Episode_From Between b.Episode_From And b.Episode_To)
					Or
					(a.Episode_To Between b.Episode_From And b.Episode_To)
					Or
					(b.Episode_From Between a.Episode_From And a.Episode_To)
					Or
					(b.Episode_To Between a.Episode_From And a.Episode_To)
				)

				--SELECT * FROM #NA_Platforms


				--DELETE a FROM #NA_Platforms a WHERE Platform_Code IN (
				--	SELECT Platform_Code FROM #Temp_Platforms b WHERE a.Platform_Code
				--)

				Insert InTo #TempRightsError(IntCode, TitleName, TitleCode, EpisodeStart, EpisodeEnd, StartDate, EndDate, PlatformCode, PlatformName, ErrorMessage)
				Select @IntCode, t.Title_Name, t.Title_Code, Episode_From, Episode_To,  @StartDate, @EndDate, np.Platform_Code, p.Platform_Hiearachy, 'Platform not acquired'
				From #NA_Platforms np
				Inner Join Title t (NOLOCK) On np.Title_Code = t.Title_Code
				Inner Join Platform p (NOLOCK) On np.Platform_Code = p.Platform_Code
				WHERE @Is_Error = 'N'

			End ------------------------------ END
				
			Begin ----------------- CHECK COUNTRY And PLATFORM And TITLE & EPISODE EXISTS OR NOT
			
				Select Distinct tp.Title_Code, tp.Episode_From, tp.Episode_To, tp.Platform_Code, tc.Country_Code InTo #Temp_Country
				From #Temp_Platforms tp
				Inner Join @Deal_Rights_Territory TC On 1 = 1


				Select Acq_Deal_Rights_Code, Case When srter.Territory_Type = 'G' Then td.Country_Code Else srter.Country_Code End Country_Code InTo #Acq_Country
				From (
					Select Acq_Deal_Rights_Code, Territory_Code, Country_Code,  Territory_Type 
					From Acq_Deal_Rights_Territory   (NOLOCK)
					Where Acq_Deal_Rights_Code In (Select Acq_Deal_Rights_Code from #Acq_Deal_Rights)
				) srter
				Left Join Territory_Details td (NOLOCK) On srter.Territory_Code = td.Territory_Code

				Select tap.*, adc.Country_Code InTo #Temp_Acq_Country From #Temp_Acq_Platform tap
				Inner Join #Acq_Country adc On tap.Acq_Deal_Rights_Code = adc.Acq_Deal_Rights_Code

				Delete From #Temp_Acq_Country Where Country_Code Not In (Select Country_Code From #Temp_Country)

				Select Distinct DRC.Title_Code, DRC.Episode_From, DRC.Episode_To, DRC.Platform_Code, DRC.Country_Code InTo #NA_Country
				From #Temp_Country DRC
				Where DRC.Country_Code Not In (
					Select ac.Country_Code From #Temp_Acq_Country ac
					Where DRC.Title_Code = ac.Title_Code And DRC.Episode_From = ac.Episode_From And DRC.Episode_To = ac.Episode_To And DRC.Platform_Code = ac.Platform_Code
				)

				Delete From #Temp_Country Where #Temp_Country.Country_Code In (
					Select np.Country_Code From #NA_Country np
					Where np.Title_Code = #Temp_Country.Title_Code And np.Episode_From = #Temp_Country.Episode_From 
							And np.Episode_To = #Temp_Country.Episode_To And np.Platform_Code = #Temp_Country.Platform_Code
				)

				Insert InTo #TempRightsError(IntCode, TitleName, TitleCode, EpisodeStart, EpisodeEnd, StartDate, EndDate, PlatformCode, PlatformName, CountryCode, CountryName, ErrorMessage)
				Select @IntCode, t.Title_Name, t.Title_Code, Episode_From, Episode_To,  @StartDate, @EndDate, np.Platform_Code, p.Platform_Name, c.Country_Code, c.Country_Name, 'Region not acquired'
				From #NA_Country np
				Inner Join Title t (NOLOCK) On np.Title_Code = t.Title_Code
				Inner Join Platform p (NOLOCK) On np.Platform_Code = p.Platform_Code
				Inner Join Country c (NOLOCK) On np.Country_Code = c.Country_Code
				WHERE @Is_Error = 'N'

				If(@Is_Title_Language_Right = 'Y')
				Begin

					INSERT INTO #TempCombination_Session(Title_Code, Episode_From, Episode_To, Platform_Code, Right_Type, Right_Start_Date, Right_End_Date, Is_Title_Language_Right,
															Country_Code, Terrirory_Type, Is_exclusive, Subtitling_Language_Code, Dubbing_Language_Code,
															Data_From, Is_Available, Error_Description,
															Sum_of,partition_of)
					SELECT DISTINCT T.Title_Code, T.Episode_From, T.Episode_To, T.Platform_Code, 'Y', @StartDate, @EndDate, @Is_Title_Language_Right,
						T.Country_Code, 'I', @Is_Exclusive, 0, 0,
						'S', 'N', 'Session',
						Case 
							When @EndDate Is Null Then 0 Else datediff(D, @StartDate, DATEADD(D, 1, @EndDate))
						End Sum_of,
						Case 
							When @EndDate Is Null Then 0 Else datediff(D, @StartDate, DATEADD(D, 1, @EndDate))
						End partition_of
					From #Temp_Country T

				End

				
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
				Where ADR.Is_Title_Language_Right = 'Y'

			End ------------------------------ END
	
			UPDATE b SET b.Sum_of = (
				SELECT SUM(c.Sum_of) FROM(
					SELECT DISTINCT a.Title_Code, a.Episode_From, a.Episode_To, a.Platform_Code, a.Country_Code, a.Sum_of --, a.Subtitling_Language_Code, a.Dubbing_Language_Code
					FROM #TempCombination AS a
				) AS c WHERE c.Title_Code = b.Title_Code And c.Episode_From = b.Episode_From And c.Episode_To = b.Episode_To AND
				c.Platform_Code = b.Platform_Code And c.Country_Code = b.Country_Code 
				--And c.Subtitling_Language_Code = b.Subtitling_Language_Code AND c.Dubbing_Language_Code = b.Dubbing_Language_Code
			) From #TempCombination b			

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
				WHERE CONVERT(DATETIME, @StartDate, 103) <= CONVERT(DATETIME, IsNull(T1.Right_Start_Date,''), 103)				
			END

			UPDATE t2 Set t2.Is_Available = 'Y'
			FROM #TempCombination_Session t2 
			LEFT join #Min_Right_Start_Date MRSD on T2.Title_Code = MRSD.Title_Code
			Inner Join #TempCombination t1 On 
			T1.Title_Code = T2.Title_Code And 
			T1.Episode_From = T2.Episode_From And 
			T1.Episode_To = T2.Episode_To And 
			T1.Platform_Code = T2.Platform_Code And 
			T1.Country_Code= T2.Country_Code
			--And T1.Subtitling_Language_Code = T2.Subtitling_Language_Code And 
			--T1.Dubbing_Language_Code = T2.Dubbing_Language_Code  
			And 
			(
				(
					(t1.sum_of = (Case When T2.Right_Type != 'U' Then datediff(d,@StartDate,dateadd(d,1,@EndDate))  Else 0 End)) OR
					(
						(T1.Right_Type = 'U' OR T2.Right_Type = 'U') AND
						(CONVERT(DATETIME, @StartDate, 103) >= CONVERT(DATETIME, IsNull(MRSD.MIN_Start_DATE,t1.Right_Start_Date), 103))
					)
				)OR
				(t1.Partition_Of = (Case When T2.Right_Type != 'U' Then datediff(d,@StartDate,dateadd(d,1,@EndDate))  Else 0 End))
			)AND 
			(
				((T1.Right_Type <> 'Y'  AND T1.Right_Type <> 'M') AND T2.Right_Type = 'U') OR
				((T1.Right_Type = 'Y' OR T1.Right_Type = 'M') AND (T2.Right_Type = 'Y' OR T2.Right_Type = 'M')) OR
				(T1.Right_Type = 'U' AND (T2.Right_Type = 'Y' OR T2.Right_Type = 'M'))
			)

			Update TCS Set TCS.Error_Description = (
				Case 
					When (
						Select Count(*) Title_Code From #TempCombination TC Where TCS.Title_Code = TC.Title_Code
					) = 0 Then 'TITLE_MISMATCH' Else '' 
				End + 
				Case 
					When (
						Select Count(*) From #TempCombination TC Where TCS.Title_Code = TC.Title_Code And TC.Platform_Code = TCS.Platform_Code
					) = 0 Then 'PLATFORM_MISMATCH' Else '' 
				End +
				Case 
					When (
						Select Count(*) Title_Code From #TempCombination TC Where TCS.Title_Code = TC.Title_Code 
						AND TC.Platform_Code = TCS.Platform_Code AND TC.Country_Code = TCS.Country_Code
					) = 0 Then 'COUNTRY_MISMATCH' Else '' 
				End +
				Case 
					When TCS.Is_Title_Language_Right = 'Y' AND TCS.Subtitling_Language_Code = 0 AND TCS.Dubbing_Language_Code = 0 AND (
						Select Count(*) Title_Code From #TempCombination TC Where TCS.Title_Code = TC.Title_Code And TC.Platform_Code = TCS.Platform_Code
						And TC.Country_Code = TCS.Country_Code And TCS.Subtitling_Language_Code = 0 And 0 = TCS.Dubbing_Language_Code 
						And TCS.Is_Title_Language_Right = TC.Is_Title_Language_Right
					) = 0 Then 'TITLE_LANGAUGE_RIGHT' Else '' 
				End +
				Case 
					When TCS.Dubbing_Language_Code > 0 AND (
						Select Count(*) Title_Code From #TempCombination TC Where TCS.Title_Code = TC.Title_Code And TC.Platform_Code = TCS.Platform_Code
						And TC.Country_Code = TCS.Country_Code And TCS.Subtitling_Language_Code = 0 
						And TC.Dubbing_Language_Code = TCS.Dubbing_Language_Code
					) = 0 Then 'DUBBING_LANGAUGE_RIGHT' Else '' 
				End +
				Case 
					When TCS.Subtitling_Language_Code > 0 And (Select Count(*) Title_Code From #TempCombination TC 
								Where TCS.Title_Code = TC.Title_Code And TC.Platform_Code = TCS.Platform_Code
										And TC.Country_Code = TCS.Country_Code And TCS.Subtitling_Language_Code = TC.Subtitling_Language_Code
										And 0 = TCS.Dubbing_Language_Code) = 0 
					Then 'SUBTITLING_LANGAUGE_RIGHT' Else '' 
				End +
				Case 
					When (Select Count(*) Title_Code From #TempCombination TC Where TCS.Title_Code = TC.Title_Code And TC.Platform_Code = TCS.Platform_Code
						And TC.Country_Code = TCS.Country_Code And TCS.Subtitling_Language_Code = TC.Subtitling_Language_Code
						And TC.Dubbing_Language_Code = TCS.Dubbing_Language_Code And (
							( 
								(TCS.sum_of = (CASE WHEN TC.Right_Type != 'U' Then datediff(d,@StartDate,dateadd(d,1,@EndDate))  ELSE 0 END))OR
								(
									(TCS.Right_Type = 'U' OR TC.Right_Type = 'U') AND
									(CONVERT(DATETIME, @StartDate, 103) >= CONVERT(DATETIME, ISNULL(TCS.Right_Start_Date,'') , 103))
								)
							)OR
							(TCS.partition_of = (CASE WHEN TC.Right_Type != 'U' Then datediff(d,@StartDate,dateadd(d,1,@EndDate))  ELSE 0 END))           
						)
					) = 0 Then 'RIGHT_PERIOD' Else '' 
				End
			) FROM #TempCombination_Session TCS
			Where Is_Available='N'
			
			--Select Error_Description, * From #TempCombination_Session Where Title_Code = 5159 And Is_Available='N'
			UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'TITLE_MISMATCHPLATFORM_MISMATCHCOUNTRY_MISMATCHTITLE_LANGAUGE_RIGHTSUBTITLING_LANGAUGE_RIGHTRIGHT_PERIOD', 'Title not acquired') Where Is_Available='N'
			UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'TITLE_MISMATCHPLATFORM_MISMATCHCOUNTRY_MISMATCHDUBBING_LANGAUGE_RIGHTRIGHT_PERIOD', 'Dubbing Language not acquired') Where Is_Available='N'
			UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'TITLE_MISMATCHPLATFORM_MISMATCHCOUNTRY_MISMATCHSUBTITLING_LANGAUGE_RIGHTRIGHT_PERIOD', 'Subtitling Language not acquired') Where Is_Available='N'
			UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'TITLE_MISMATCHPLATFORM_MISMATCHCOUNTRY_MISMATCHTITLE_LANGAUGE_RIGHTRIGHT_PERIOD', 'Title Language not acquired') Where Is_Available='N'
			
			UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'PLATFORM_MISMATCHCOUNTRY_MISMATCHTITLE_LANGAUGE_RIGHTSUBTITLING_LANGAUGE_RIGHTRIGHT_PERIOD', 'Platform not acquired')Where Is_Available='N'
			UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'PLATFORM_MISMATCHCOUNTRY_MISMATCHDUBBING_LANGAUGE_RIGHTRIGHT_PERIOD', 'Platform not acquired') Where Is_Available='N'
			UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'PLATFORM_MISMATCHCOUNTRY_MISMATCHSUBTITLING_LANGAUGE_RIGHTRIGHT_PERIOD', 'Platform not acquired')Where Is_Available='N'
			UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'PLATFORM_MISMATCHCOUNTRY_MISMATCHTITLE_LANGAUGE_RIGHTRIGHT_PERIOD', 'Platform not acquired')Where Is_Available='N'

			UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'TITLE_LANGAUGE_RIGHTSUBTITLING_LANGAUGE_RIGHTRIGHT_PERIOD', 'TITLE_LANGAUGE_RIGHT&SUBTITLING_LANGAUGE_RIGHT') Where Is_Available='N'
			UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'TITLE_LANGAUGE_RIGHTSUBTITLING_LANGAUGE_RIGHT', 'TITLE_LANGAUGE_RIGHT&SUBTITLING_LANGAUGE_RIGHT') Where Is_Available='N'

			UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'TITLE_LANGAUGE_RIGHTDUBBING_LANGAUGE_RIGHTRIGHT_PERIOD', 'TITLE_LANGAUGE_RIGHT&DUBBING_LANGAUGE_RIGHT') Where Is_Available='N'
			UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'TITLE_LANGAUGE_RIGHTDUBBING_LANGAUGE_RIGHT', 'TITLE_LANGAUGE_RIGHT&DUBBING_LANGAUGE_RIGHT') Where Is_Available='N'
			
			UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'TITLE_MISMATCHPLATFORM_MISMATCH', 'Title not acquired') Where Is_Available='N'

			UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'COUNTRY_MISMATCHTITLE_LANGAUGE_RIGHTRIGHT_PERIOD', 'Region not acquired')Where Is_Available='N'

			UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'SUBTITLING_LANGAUGE_RIGHTRIGHT_PERIOD', 'Subtitling Language not acquired')Where Is_Available='N'
			UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'DUBBING_LANGAUGE_RIGHTRIGHT_PERIOD', 'Dubbing Language not acquired')Where Is_Available='N'
			UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'TITLE_LANGAUGE_RIGHTRIGHT_PERIOD', 'Title Language not acquired')Where Is_Available='N'

			UPDATE #TempCombination_Session Set Error_Description = 'Rights period mismatch' Where Is_Available='N' And Error_Description = ''
	
			Insert InTo #TempRightsError(IntCode, TitleName, TitleCode, EpisodeStart, EpisodeEnd, StartDate, EndDate, PlatformCode, PlatformName, CountryCode, CountryName, ErrorMessage)
			Select @IntCode, t.Title_Name, nsub.Title_Code, Episode_From, Episode_To, @StartDate, @EndDate, nsub.Platform_Code, p.Platform_Hiearachy, c.Country_Code, c.Country_Name, Error_Description
			From #TempCombination_Session nsub 
			Inner Join Title t (NOLOCK) On nsub.Title_Code = t.Title_Code
			Inner Join Platform p (NOLOCK) On nsub.Platform_Code = p.Platform_Code
			Inner Join Country c (NOLOCK) On nsub.Country_Code = c.Country_Code
			Where Is_Available = 'N'

			TRUNCATE TABLE #TempCombination_Session
			TRUNCATE TABLE #TempCombination

			DROP TABLE #Min_Right_Start_Date
			DROP TABLE #NA_Country
			DROP TABLE #Acq_Country
			DROP TABLE #Temp_Acq_Country

			DROP TABLE #Temp_Country
			DROP TABLE #Temp_Acq_Platform			
			DROP TABLE #Temp_Platforms
			DROP TABLE #NA_Platforms
			DROP TABLE #Acq_Avail_Title_Eps
			DROP TABLE #Title_Not_Acquire
			DROP TABLE #Acq_Deal_Rights	
			DROP TABLE #Acq_Titles_With_Rights
			DROP TABLE #Acq_Titles
			DROP TABLE #Temp_NA_Title

			FETCH NEXT FROM EUR_Rights INTO @IntCode, @TitleCode, @EpisodeStart, @EpisodeEnd, @StartDate, @EndDate, @CountryCodes, @PlatformCodes, @DubbingCodes, @SubtitlingCodes
		END
		CLOSE EUR_Rights
		DEALLOCATE EUR_Rights

		SELECT DISTINCT IntCode, TitleName, TitleCode, EpisodeStart, EpisodeEnd, PlatformName, PlatformCode, CountryName, CountryCode, StartDate, EndDate, ErrorMessage 
		FROM #TempRightsError
	
		DROP TABLE #Temp_Episode_No
		DROP TABLE #Deal_Right_Title_WithEpsNo
		DROP TABLE #TempCombination
		DROP TABLE #TempCombination_Session
		DROP TABLE #TempRightsError
	
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPRUR_VALIDATE_Content]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
