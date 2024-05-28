CREATE Procedure USP_Validate_Part_I 
As
Begin			
	IF((SELECT COUNT(*) FROM Syn_Deal_Rights_Process_Validation WHERE STATUS = 'W') = 0)
	BEGIN
		SET NOCOUNT ON;
		DECLARE @Is_Acq_CoExclusive CHAR(1) = 'N', @Tentative VARCHAR(100) = 'N'
		DECLARE @IS_PUSH_BACK_SAME_DEAL CHAR(1) ='N', @Is_Autopush CHAR(1) = 'N',@Sql NVARCHAR(1000),@DB_Name VARCHAR(1000),@Agreement_No VARCHAR(100);
		SELECT @IS_PUSH_BACK_SAME_DEAL  = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'VALIDATE_PUSHBACK_SAME_DEAL'
		
		SELECT @Is_Acq_CoExclusive = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'Is_Acq_CoExclusive'
		
		IF(@Is_Acq_CoExclusive = 'Y')
			SELECT @Tentative = 'N,Y'

		DECLARE @Syn_Deal_Rights_Code INT, @Syn_Deal_Code_Mapping INT = 0
		SELECT TOP 1 @Syn_Deal_Rights_Code = Syn_Deal_Rights_Code FROM Syn_Deal_Rights_Process_Validation WHERE Status = 'P' Order By Created_On ASC
		--SET @Syn_Deal_Rights_Code = 3537
		SELECT @Syn_Deal_Code_Mapping = Syn_Deal_Code FROM Syn_Deal_Rights WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code

		UPDATE Syn_Deal_Rights_Process_Validation SET STATUS = 'W' WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code AND Status = 'P' 
		UPDATE Syn_Deal_Rights Set Right_Status = 'W' WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
		DELETE FROM Syn_Deal_Rights_Error_Details WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code

		IF EXISTS (SELECT * FROM Syn_Deal_Rights WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code AND Right_Type = 'M')
		BEGIN
			UPDATE Syn_Deal_Rights SET Right_Status = 'C' WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
			UPDATE Syn_Deal_Rights_Process_Validation SET Status = 'D' WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
			RETURN;
		END

		BEGIN TRY
			Begin  /* Drop Temp Tables, if exists */
				If OBJECT_ID('tempdb..#Temp_Acq_Dubbing') Is Not Null Drop Table #Temp_Acq_Dubbing
				If OBJECT_ID('tempdb..#NA_Dubbing') Is Not Null Drop Table #NA_Dubbing
				
				If OBJECT_ID('tempdb..#TempCombination') Is Not Null Drop Table #TempCombination
				If OBJECT_ID('tempdb..#TempCombination_Session') Is Not Null Drop Table #TempCombination_Session

				If OBJECT_ID('tempdb..#Temp_Episode_No') Is Not Null Drop Table #Temp_Episode_No
				If OBJECT_ID('tempdb..#Deal_Right_Title_WithEpsNo') Is Not Null Drop Table #Deal_Right_Title_WithEpsNo
				If OBJECT_ID('tempdb..#Temp_Syn_Dup_Records') Is Not Null Drop Table #Temp_Syn_Dup_Records
				If OBJECT_ID('tempdb..#Temp_Exceptions') Is Not Null Drop Table #Temp_Exceptions
				
				If OBJECT_ID('tempdb..#Acq_Titles') Is Not Null Drop Table #Acq_Titles
				If OBJECT_ID('tempdb..#Title_Not_Acquire') Is Not Null Drop Table #Title_Not_Acquire
				If OBJECT_ID('tempdb..#Acq_Avail_Title_Eps') Is Not Null Drop Table #Acq_Avail_Title_Eps
				If OBJECT_ID('tempdb..#Temp_Country') Is Not Null Drop Table #Temp_Country
				If OBJECT_ID('tempdb..#Temp_Platforms') Is Not Null Drop Table #Temp_Platforms
				If OBJECT_ID('tempdb..#Acq_Country') Is Not Null Drop Table #Acq_Country
				If OBJECT_ID('tempdb..#Temp_Country') Is Not Null Drop Table #Temp_Country
				If OBJECT_ID('tempdb..#Temp_Acq_Platform') Is Not Null Drop Table #Temp_Acq_Platform
				If OBJECT_ID('tempdb..#Temp_Acq_Country') Is Not Null Drop Table #Temp_Acq_Country
				If OBJECT_ID('tempdb..#NA_Country') Is Not Null Drop Table #NA_Country
				If OBJECT_ID('tempdb..#Temp_Subtitling') Is Not Null Drop Table #Temp_Subtitling
				If OBJECT_ID('tempdb..#Temp_Acq_Subtitling') Is Not Null Drop Table #Temp_Acq_Subtitling
				If OBJECT_ID('tempdb..#Acq_Sub') Is Not Null Drop Table #Acq_Sub
				If OBJECT_ID('tempdb..#NA_Subtitling') Is Not Null Drop Table #NA_Subtitling
				If OBJECT_ID('tempdb..#Temp_Dubbing') Is Not Null Drop Table #Temp_Dubbing
				If OBJECT_ID('tempdb..#Temp_NA_Title') Is Not Null Drop Table #Temp_NA_Title
				If OBJECT_ID('tempdb..#Acq_Dub') Is Not Null Drop Table #Acq_Dub

				If OBJECT_ID('tempdb..#Min_Right_Start_Date') Is Not Null Drop Table #Min_Right_Start_Date
				If OBJECT_ID('tempdb..#Syn_Deal_Rights_Subtitling') Is Not Null Drop Table #Syn_Deal_Rights_Subtitling
				If OBJECT_ID('tempdb..#Syn_Deal_Rights_Dubbing') Is Not Null Drop Table #Syn_Deal_Rights_Dubbing
				If OBJECT_ID('tempdb..#Syn_Rights_Code_Lang') Is Not Null Drop Table #Syn_Rights_Code_Lang
				If OBJECT_ID('tempdb..#Syn_Deal_Rights_Title') Is Not Null Drop Table #Syn_Deal_Rights_Title				
				If OBJECT_ID('tempdb..#Syn_Deal_Rights_Platform') Is Not Null Drop Table #Syn_Deal_Rights_Platform 
				If OBJECT_ID('tempdb..#Syn_Deal_Rights') Is Not Null Drop Table #Syn_Deal_Rights
				If OBJECT_ID('tempdb..#Syn_Deal_Rights_Territory') Is Not Null Drop Table #Syn_Deal_Rights_Territory
				If OBJECT_ID('tempdb..#Syn_Deal_Rights_Subtitling') Is Not Null Drop Table #Syn_Deal_Rights_Subtitling
				If OBJECT_ID('tempdb..#Syn_Deal_Rights_Dubbing') Is Not Null Drop Table #Syn_Deal_Rights_Dubbing
				If OBJECT_ID('tempdb..#Syn_Rights_Code_Lang') Is Not Null Drop Table #Syn_Rights_Code_Lang
				If OBJECT_ID('tempdb..#Syn_RIGHTS_NEW') Is Not Null Drop Table #Syn_RIGHTS_NEW
				IF OBJECT_ID('TEMPDB..#TempPromoter') IS NOT NULL DROP TABLE #TempPromoter

				IF OBJECT_ID('TEMPDB..#AcqPromoter') IS NOT NULL DROP TABLE #AcqPromoter
				IF OBJECT_ID('TEMPDB..#TempAcqPromoter_TL') IS NOT NULL DROP TABLE #TempAcqPromoter_TL
				IF OBJECT_ID('TEMPDB..#TempPromoter_TL') IS NOT NULL DROP TABLE #TempPromoter_TL
				IF OBJECT_ID('TEMPDB..#NA_Promoter_TL') IS NOT NULL DROP TABLE #NA_Promoter_TL
				IF OBJECT_ID('TEMPDB..#TempAcqPromoter_Sub') IS NOT NULL DROP TABLE #TempAcqPromoter_Sub
				IF OBJECT_ID('TEMPDB..#TempPromoter_Sub') IS NOT NULL DROP TABLE #TempPromoter_Sub
				IF OBJECT_ID('TEMPDB..#NA_Promoter_Sub') IS NOT NULL DROP TABLE #NA_Promoter_Sub
				IF OBJECT_ID('TEMPDB..#TempAcqPromoter_Dub') IS NOT NULL DROP TABLE #TempAcqPromoter_Dub
				IF OBJECT_ID('TEMPDB..#TempPromoter_Dub') IS NOT NULL DROP TABLE #TempPromoter_Dub
				IF OBJECT_ID('TEMPDB..#NA_Promoter_Dub') IS NOT NULL DROP TABLE #NA_Promoter_Dub
				IF OBJECT_ID('tempdb..#NotInSynRights') IS NOT NULL DROP TABLE #NotInSynRights

			END

			Begin /* Create Temp Tables*/
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

				CREATE Table #Temp_Episode_No
				(
					Episode_No Int
				)

				CREATE Table #Deal_Right_Title_WithEpsNo
				(
					Deal_Rights_Code Int,
					Title_Code Int,
					Episode_No Int,
				)
			END

			Declare @RC Int
			Declare @Deal_Rights_Title Deal_Rights_Title
			Declare @Deal_Rights_Platform Deal_Rights_Platform
			Declare @Deal_Rights_Territory Deal_Rights_Territory
			Declare @Deal_Rights_Subtitling Deal_Rights_Subtitling
			Declare @Deal_Rights_Dubbing Deal_Rights_Dubbing
			Declare @CallFrom char(2)='SR'
			Declare @Debug char(1)='T'
			Declare @Syn_Deal_Code Int = 0

			CREATE TABLE #TempPromoter(
				Promoter_Group_Code		INT,
				Promoter_Remarks_Code	INT,
				Promoter_Parent_Code    INT
			)

			SELECT @CallFrom = CASE WHEN ISNULL(Is_Pushback, 'N') = 'N' THEN 'SR' ELSE 'SP' END  FROM Syn_Deal_Rights  
			WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code

			PRINT 'AD 0 ' + CAST(@Syn_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)

			Insert InTo @Deal_Rights_Title(Deal_Rights_Code, Title_Code, Episode_From, Episode_To)
			SELECT  Syn_Deal_Rights_Code, Title_Code, Episode_From, Episode_To
			FROM Syn_Deal_Rights_Title 
			WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code --AND Title_Code = @Title_Code_Cur

			Insert InTo @Deal_Rights_Platform(Deal_Rights_Code,Platform_Code)
			SELECT  Syn_Deal_Rights_Code, Platform_Code
			FROM Syn_Deal_Rights_Platform
			WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code;

			Insert InTo @Deal_Rights_Territory(Deal_Rights_Code, Country_Code)
			SELECT Syn_Deal_Rights_Code, CASE WHEN srter.Territory_Type = 'G' THEN td.Country_Code ELSE srter.Country_Code END Country_Code
			FROM (
				SELECT Syn_Deal_Rights_Code, Territory_Code, Country_Code,  Territory_Type 
				FROM Syn_Deal_Rights_Territory  
				WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
			) As srter
			Left Join Territory_Details td On srter.Territory_Code = td.Territory_Code

			Insert InTo @Deal_Rights_Subtitling(Deal_Rights_Code, Subtitling_Code)
			SELECT Syn_Deal_Rights_Code, CASE WHEN srlan.Language_Type = 'G' THEN lgd.Language_Code ELSE srlan.Language_Code END Language_Code
			FROM (
				SELECT Syn_Deal_Rights_Code, Language_Code, Language_Group_Code, Language_Type
				FROM Syn_Deal_Rights_Subtitling
				WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
			) As srlan
			Left Join Language_Group_Details lgd On srlan.Language_Group_Code = lgd.Language_Group_Code

			Insert InTo @Deal_Rights_Dubbing(Deal_Rights_Code, Dubbing_Code)
			SELECT Syn_Deal_Rights_Code, CASE WHEN srlan.Language_Type = 'G' THEN lgd.Language_Code ELSE srlan.Language_Code END Language_Code
			FROM (
				SELECT Syn_Deal_Rights_Code, Language_Code, Language_Group_Code, Language_Type
				FROM Syn_Deal_Rights_Dubbing
				WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
			) As srlan
			Left Join Language_Group_Details lgd On srlan.Language_Group_Code = lgd.Language_Group_Code

			PRINT 'AD 1 ' + CAST(@Syn_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)

			INSERT INTO #TempPromoter(Promoter_Group_Code, Promoter_Remarks_Code,  Promoter_Parent_Code)
			SELECT DISTINCT PG.PRomoter_Group_Code, SDRPR.Promoter_Remarks_Code, PG.Parent_Group_Code   FROM Syn_Deal_Rights_Promoter SDRP
			INNER JOIN Syn_Deal_Rights_Promoter_Group SDRPG ON SDRPG.Syn_Deal_Rights_Promoter_Code = SDRP.Syn_Deal_Rights_Promoter_Code
			INNER JOIN Syn_Deal_Rights_Promoter_Remarks SDRPR ON SDRPR.Syn_Deal_Rights_Promoter_Code = SDRP.Syn_Deal_Rights_Promoter_Code
			inner  JOIN Promoter_Group PG ON PG.Parent_Group_Code = SDRPG.Promoter_Group_Code
			WHERE SDRP.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
			UNION
			--INSERT INTO #TempPromoter(Promoter_Group_Code, Promoter_Remarks_Code)
			SELECT DISTINCT SDRPG.Promoter_Group_Code, SDRPR.Promoter_Remarks_Code, PG.Parent_Group_Code  FROM Syn_Deal_Rights_Promoter SDRP
			INNER JOIN Syn_Deal_Rights_Promoter_Group SDRPG ON SDRPG.Syn_Deal_Rights_Promoter_Code = SDRP.Syn_Deal_Rights_Promoter_Code
			INNER JOIN Syn_Deal_Rights_Promoter_Remarks SDRPR ON SDRPR.Syn_Deal_Rights_Promoter_Code = SDRP.Syn_Deal_Rights_Promoter_Code
			INNER JOIN Promoter_Group PG ON PG.Promoter_Group_Code = SDRPG.Promoter_Group_Code
			WHERE SDRP.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code

			delete FROM #TempPromoter
			WHERE Promoter_Parent_Code IN(SELECT Promoter_Group_Code FROM #TempPromoter)

			PRINT 'AD 2 ' + CAST(@Syn_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)

			Declare @Right_Start_Date DATETIME,
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
				@Is_Error Char(1) = 'N'

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

			Truncate Table #Temp_Episode_No
			Truncate Table #Deal_Right_Title_WithEpsNo

			Declare @StartNum Int, @EndNum Int
			SELECT @StartNum = MIN(Episode_FROM), @EndNum = MAX(Episode_To) FROM @Deal_Rights_Title;
			
			With gen As (
				SELECT @StartNum As num Union All
				SELECT num+1 FROM gen WHERE num + 1 <= @EndNum
			)

			Insert InTo #Temp_Episode_No
			SELECT * FROM gen
			Option (maxrecursion 10000)

			Insert InTo #Deal_Right_Title_WithEpsNo(Deal_Rights_Code, Title_Code, Episode_No)
			SELECT Deal_Rights_Code,Title_Code, Episode_No 
			FROM (
				SELECT Distinct t.Deal_Rights_Code,t.Title_Code, a.Episode_No 
				FROM #Temp_Episode_No A 
				Cross Apply @Deal_Rights_Title T 
				WHERE A.Episode_No Between T.Episode_FROM AND T.Episode_To
			) As B 
		
			PRINT 'AD 3 ' + CAST(@Syn_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)

			Declare @Count_SubTitle Int = 0, @Count_Dub Int = 0
			Delete FROM @Deal_Rights_Subtitling WHERE Subtitling_Code = 0
			Delete FROM @Deal_Rights_Dubbing WHERE Dubbing_Code = 0

			If((SELECT COUNT(ISNULL(Subtitling_Code,0)) FROM @Deal_Rights_Subtitling)>0)
			Begin
				Set @Count_SubTitle = 1
			END
			If((SELECT COUNT(ISNULL(Dubbing_Code,0)) FROM @Deal_Rights_Dubbing)>0)
			Begin
				Set @Count_Dub = 1
			END
		
			PRINT 'AD 4 ' + CAST(@Syn_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)

			SELECT ADR.Acq_Deal_Rights_Code, Right_Type, Actual_Right_Start_Date, Actual_Right_End_Date, Is_Title_Language_Right,
					Is_Exclusive, ADR.Acq_Deal_Code, AD.Agreement_No,
					(SELECT COUNT(*) FROM Acq_Deal_Rights_Subtitling a WHERE a.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) SubCnt, 
					(SELECT COUNT(*) FROM Acq_Deal_Rights_Dubbing a WHERE a.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) DubCnt,
				   	Sum(                        
						CASE 
							WHEN (@Right_Start_Date Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date) AND (@Right_End_Date Not Between ADR.Actual_Right_Start_Date  AND ADR.Actual_Right_End_Date)
								THEN DATEDIFF(d,@Right_Start_Date, DATEADD(d,1, ADR.Actual_Right_End_Date ))
							WHEN (@Right_Start_Date Not Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date) AND (@Right_End_Date Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date)
								THEN DATEDIFF(d, ADR.Actual_Right_Start_Date,DATEADD(d,1, @Right_End_Date))
							WHEN (@Right_Start_Date < ADR.Actual_Right_Start_Date) AND (@Right_End_Date > ADR.Actual_Right_End_Date)
								THEN DATEDIFF(d,ADR.Actual_Right_Start_Date, DATEADD(d,1, ADR.Actual_Right_End_Date))
							WHEN (@Right_Start_Date Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date) AND (@Right_End_Date Between ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date)
								THEN DATEDIFF(d,@Right_Start_Date,DATEADD(d,1, @Right_End_Date  ))
							ELSE 0 
						END
					)Sum_of,
					Sum(
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
					OVER(
						PARTITION BY ADR.Acq_Deal_Rights_Code, Right_Type, Actual_Right_Start_Date, Actual_Right_End_Date, Is_Title_Language_Right,Is_Exclusive, adr.Acq_Deal_Code
					) Partition_Of
					InTo #Acq_Deal_Rights
			FROM Acq_Deal_Rights ADR
			Inner Join Acq_Deal AD On ADR.Acq_Deal_Code = ad.Acq_Deal_Code AND ISNULL(AD.Deal_Workflow_Status,'') = 'A'
			WHERE 
			ADR.Acq_Deal_Code Is Not Null
			AND ADR.Is_Sub_License='Y'
			AND ADR.Is_Tentative IN (SELECT number FROM dbo.fn_Split_withdelemiter(@Tentative,','))
			--AND ADR.Is_Tentative='N'
			AND
			(
				(
					ADR.Right_Type ='Y' AND
					(
						(CONVERT(DATETIME, @Right_Start_Date, 103) Between CONVERT(DATETIME, ADR.Right_Start_Date, 103) AND CONVERT(DATETIME, ADR.Right_End_Date, 103)) OR
						(CONVERT(DATETIME, @Right_End_Date, 103) Between CONVERT(DATETIME, ADR.Right_Start_Date, 103) AND CONVERT(DATETIME, ADR.Right_End_Date, 103)) OR
						(CONVERT(DATETIME, ADR.Right_Start_Date, 103) Between CONVERT(DATETIME, @Right_Start_Date, 103) AND CONVERT(DATETIME, @Right_End_Date, 103)) OR
						(CONVERT(DATETIME, ADR.Right_End_Date, 103) Between CONVERT(DATETIME, @Right_Start_Date, 103) AND CONVERT(DATETIME, @Right_End_Date, 103))
					)
				)OR(ADR.Right_Type ='U'  OR ADR.Right_Type ='M')
			) AND (    
				(ADR.Is_Title_Language_Right = @Is_Title_Language_Right) OR 
				(@Is_Title_Language_Right <> 'Y' AND ADR.Is_Title_Language_Right = 'Y') OR 
				(@Is_Title_Language_Right = 'Y' AND ADR.Is_Title_Language_Right = 'N')
			) AND (
				(@Is_Exclusive IN ('Y', 'C') AND ISNULL(ADR.Is_exclusive,'') = 'Y') OR @Is_Exclusive = 'N'
			) 
			GROUP BY ADR.Acq_Deal_Rights_Code, Right_Type, Actual_Right_Start_Date, Actual_Right_End_Date, Is_Title_Language_Right,Is_Exclusive, adr.Acq_Deal_Code, AD.Agreement_No
			
			PRINT 'AD 5 ' + CAST(@Syn_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)
		END Try
		Begin Catch
		END Catch

		SELECT * FROM @Deal_Rights_Title
		SELECT * FROM @Deal_Rights_Platform
		SELECT * FROM @Deal_Rights_Territory
		SELECT * FROM @Deal_Rights_Subtitling
		SELECT * FROM @Deal_Rights_Dubbing
		SELECT * FROM #TempPromoter
		SELECT * FROM #Temp_Episode_No
		SELECT * FROM #Deal_Right_Title_WithEpsNo
		SELECT * FROM #Acq_Deal_Rights
		SELECT  @Syn_Deal_Rights_Code as Syn_Deal_Rights_Code
	END
END